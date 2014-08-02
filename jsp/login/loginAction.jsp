<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.twobrain.common.session.UserLoginMgr" %>
<%@ include file="../common/include/incInit.jspf" %><%

	RequestHelper req = new RequestHelper(request);

	String sRedirectPage = req.getParam("redirectUrl","");

	UserLoginMgr loginMgr = new UserLoginMgr(sHostName);
	
//	int loginResult = loginMgr.checkLoginAuth(request,response);
	int loginResult = loginMgr.loginProcess(request,response);  // ID/HOST 기반에서 EMAIL/DOMAIN기반으로 수정

	switch(loginResult) {
		case 1:
			UserSession userSession = (UserSession)request.getSession().getAttribute("UserSession");
			
			String notiEmail = userSession.getSubEmail();
			
			if(notiEmail == null || "".equals(notiEmail)) {
				StringBuffer sb = new StringBuffer();
				
				out.print(JavaScript.write("alert('태스크투게더 알람을 받기위해 이메일을 설정해주세요!');location.replace('"+CONTEXT_PATH+"/jsp/userInfo.jsp?user_idx="+userSession.getUserIdx()+"');"));
			} else {
				if("".equals(sRedirectPage)) {
//					response.sendRedirect(CONTEXT_PATH + "/jsp/index.jsp");
					response.sendRedirect(CONTEXT_PATH + "/theme/2/index.jsp");
				} else {
					response.sendRedirect(sRedirectPage);
				}	
			}
			
			break;
			
		case 2:
			removeLoginCookie(request,response);
			out.print(JavaScript.write("alert('패스워드를 확인하세요'); location.replace('"+CONTEXT_PATH+"/jsp/login/login.jsp');"));
			
			break;
			
		case 3:
			removeLoginCookie(request,response);
			out.print(JavaScript.write("alert('등록된 사용자가 아닙니다.'); location.replace('"+CONTEXT_PATH+"/jsp/login/login.jsp');"));
			break;
	}
%>
<%!
	public static void removeLoginCookie(HttpServletRequest request, HttpServletResponse response) {
		Cookie loginId = Util.getCookie(request, Cs.TIMECLOUD_LOGIN_EMAIL);
		
		if(loginId != null) {
			loginId.setMaxAge(0);
			loginId.setPath("/");
			response.addCookie(loginId);
		}
		
		Cookie loginPwd = Util.getCookie(request, Cs.TIMECLOUD_LOGIN_PWD);
		
		if(loginPwd != null) {
			loginPwd.setMaxAge(0);
			loginPwd.setPath("/");
			response.addCookie(loginPwd);
		}
		
		HttpSession currentSession = request.getSession();
		currentSession.invalidate();
	}
%>
