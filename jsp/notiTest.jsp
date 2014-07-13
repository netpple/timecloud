<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.twobrain.common.util.NotificationService" %>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%
	int taskIdx = 1344;

	String sFeedback = "피드백 노티피케이션 테스트";
	int feedbackIdx = 25300;//QueryHandler.executeQueryInt("GET_FEEDBACK_SEQUENCE");
	
	//int ret = QueryHandler.executeUpdate("INSERT_FEEDBACK" ,new String[]{ ""+feedbackIdx, sFeedback, ""+ownerIdx,""+taskIdx,DOMAIN_IDX});

	NotificationService ntfcService = new NotificationService(oUserSession);
	ntfcService.sendFeedbackNotificationTest(taskIdx, feedbackIdx, sFeedback);
%>
