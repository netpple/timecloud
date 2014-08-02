<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/include/incInit.jspf" %>
<%@ include file="../common/include/incSession.jspf" %>
<%
    String sPasswordNow = req.getParam("user_passwd_now", "");
    String sPasswordNew = req.getParam("user_passwd_new", "");

    String alert = "";
    String url = "location.replace('view.jsp')";

    if (!sPasswordNow.isEmpty() && !sPasswordNew.isEmpty()) {

        int result = QueryHandler.executeUpdate("UPDATE_USER_PASSWD",new String[]{sPasswordNew,sPasswordNow,USER_IDX});
        if(result > 0){
            // 쿠키갱신
            Cookie loginPwd = Util.getCookie(request, Cs.TIMECLOUD_LOGIN_PWD);
            if (loginPwd != null) {
                loginPwd.setMaxAge(60 * 60 * 24 * 30);
                loginPwd.setValue(Util.getMD5Hash(sPasswordNew));
                response.addCookie(loginPwd);
            }

            alert = "alert('비밀번호가 변경되었습니다.');";
        }
        else {
            alert = "alert('비밀번호 변경 실패');";
        }
    }

    out.print(JavaScript.write(alert + url));
%>