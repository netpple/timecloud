<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.twobrain.common.session.UserLoginMgr" %>
<%@ include file="../common/include/incInit.jspf" %>
<%@ page session="true" %><%
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

	response.sendRedirect(CONTEXT_PATH + "/jsp/login/login.jsp");
	

%>
