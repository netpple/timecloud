package com.twobrain.common.session;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.twobrain.common.constants.Cs;
import com.twobrain.common.core.DataSet;
import com.twobrain.common.core.QueryHandler;
import com.twobrain.common.log.LogHandler;
import com.twobrain.common.util.RequestHelper;
import com.twobrain.common.util.Util;

public class UserLoginMgr {

	private String sHostName = "";
	
	public UserLoginMgr(String hostName) {
		this.sHostName = hostName;
	}

    /***
     * @param request request
     * @param response response
     * @return 1: 로그인 성공, 2: 패스워드가 틀림, 3: 등록된 사용자가 아님,
     */
    public int loginProcess(HttpServletRequest request, HttpServletResponse response) {
        RequestHelper req = new RequestHelper(request);

        String sCheckPw = null;

        int intRetNum = 0;

//        String sLoginId = req.getParam("pUserId",Util.getCookieValue(request, Cs.TIMECLOUD_LOGIN_ID));
//        String sLoginUserEmail = sLoginId + "@" + sHostName;
        String sLoginDomainId = req.getParam("pUserDomain",Util.getCookieValue(request, Cs.TIMECLOUD_LOGIN_DOMAIN));
        String sLoginEmail = req.getParam("pUserEmail",Util.getCookieValue(request, Cs.TIMECLOUD_LOGIN_EMAIL));
        String sLoginPw = req.getParam("pUserPwd",Util.getCookieValue(request, Cs.TIMECLOUD_LOGIN_PWD));

        try {
            DataSet dsInfo = QueryHandler.executeQuery("SELECT_TIMECLOUD_LOGIN_DOMAIN_USER", new String[]{sLoginEmail, sLoginDomainId} );

            if (dsInfo.next()) {
                sCheckPw = dsInfo.getString(7);

                if(sLoginPw.equals(sCheckPw) || sLoginPw.equals(Util.getMD5Hash(sCheckPw))) {
                    intRetNum = checkDuplicateUser(new UserSession(dsInfo),request);

                    Cookie domainCookie = new Cookie(Cs.TIMECLOUD_LOGIN_DOMAIN,sLoginDomainId);
                    domainCookie.setMaxAge(60*60*24*30);
                    domainCookie.setPath("/");
                    response.addCookie(domainCookie);

                    Cookie idCookie = new Cookie(Cs.TIMECLOUD_LOGIN_EMAIL,sLoginEmail);
                    idCookie.setMaxAge(60*60*24*30);
                    idCookie.setPath("/");
                    response.addCookie(idCookie);

                    Cookie pwdCookie = new Cookie(Cs.TIMECLOUD_LOGIN_PWD,Util.getMD5Hash(sCheckPw));
                    pwdCookie.setMaxAge(60*60*24*30);
                    pwdCookie.setPath("/");
                    response.addCookie(pwdCookie);

                    String userIdx = dsInfo.getString("N_IDX");

                    QueryHandler.executeUpdate("UPDATE_LAST_LOGIN_DATETIME", new Object[] { userIdx } );
                } else {
                    intRetNum = 2;
                }
            } else {
                intRetNum = 3;
            }

        }catch (Exception e) {
            LogHandler.error("UserLoginMgr : checkLoginAuth() : Exception");
            LogHandler.error("Error " + e.toString());
        }

        LogHandler.debug("Process Result : " + intRetNum);
        return intRetNum;
    }

    /***
     * @param request request
     * @param response response
     * @return 1: 로그인 성공, 2: 패스워드가 틀림, 3: 등록된 사용자가 아님, 
     */
	public int checkLoginAuth(HttpServletRequest request, HttpServletResponse response) {
	    RequestHelper req = new RequestHelper(request);
	    
		String sCheckPw = null;

        int intRetNum = 0;
        
        String sLoginId = req.getParam("pUserId",Util.getCookieValue(request, Cs.TIMECLOUD_LOGIN_EMAIL));
        String sLoginUserEmail = sLoginId + "@" + sHostName;        
        String sLoginPw = req.getParam("pUserPwd",Util.getCookieValue(request, Cs.TIMECLOUD_LOGIN_PWD));
        
        try {
            DataSet dsInfo = QueryHandler.executeQuery("SELECT_TIMECLOUD_LOGIN_USER", sLoginUserEmail);

            if (dsInfo.next()) {
            	sCheckPw = dsInfo.getString(7);
            	

            	if(sLoginPw.equals(sCheckPw) || sLoginPw.equals(Util.getMD5Hash(sCheckPw))) {
            		intRetNum = checkDuplicateUser(new UserSession(dsInfo),request);

                	Cookie idCookie = new Cookie(Cs.TIMECLOUD_LOGIN_EMAIL,sLoginId);
                	idCookie.setMaxAge(60*60*24*30);
                	idCookie.setPath("/");
                	response.addCookie(idCookie);
                	
                	Cookie pwdCookie = new Cookie(Cs.TIMECLOUD_LOGIN_PWD,Util.getMD5Hash(sCheckPw));
                	pwdCookie.setMaxAge(60*60*24*30);
                	pwdCookie.setPath("/");
                	response.addCookie(pwdCookie);
                	
                	String userIdx = dsInfo.getString("N_IDX");
                	
                	QueryHandler.executeUpdate("UPDATE_LAST_LOGIN_DATETIME", new Object[] { userIdx } );
            	} else {
            		intRetNum = 2;
            	}
            } else {
            	intRetNum = 3;
            }

        }catch (Exception e) {
			LogHandler.error("UserLoginMgr : checkLoginAuth() : Exception"); 
			LogHandler.error("Error " + e.toString());                        
        }
        
        LogHandler.debug("Process Result : " + intRetNum);
        return intRetNum;
    } 

    /**
     * 현재 로그인을 시도한 사용자의 세션이 있는지 검사하고, 세션이 있다면 이전세션을 삭제하고,
	 * 새로운 세션을 모니터 객체에 넣는다.
     *
     * @param user LgnUserSession
	 * @param request HttpServletRequest
     * @return 사용자가 로그인 했는지 체크한다.(6: 로그인이 되어있어서 이전세션을 로그아웃시킴. 7: 세션에 값저장 실패)
     */
	private int checkDuplicateUser(UserSession user, HttpServletRequest request) {

		String url = request.getRequestURL().toString().replace("http://", "");
		String host = url.substring(0,url.indexOf('/'));
		
		int intRetNum = 1;

		HttpSession currentSession = null;

		user.setLoginIp(request.getRemoteAddr());
		user.setHost("http://" + host);
		
		UserMonitor monitor = UserMonitor.getInstance();
		
		if (monitor.containsKey(user)) {

			HttpSession oldSession = (HttpSession)monitor.getUserSession(user);
			oldSession.invalidate();
			monitor.removeUserSession(user);
		}

		try {
			currentSession = request.getSession();
			currentSession.setAttribute("UserSession", user);
		} catch (IllegalStateException e) { // 세션에 값저장 실패
		}

		//모니터에 사용자 객체를 키로, 세션객체를 값으로 해서 넣는다.
		monitor.putUserSession(user, currentSession);

		return intRetNum;
	}

}