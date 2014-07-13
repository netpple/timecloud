<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%
	if(TASK_IDX <= 0 ) { 
		out.println("Parameter is invalid") ;
		return ;
	}

	String sFeedback = req.getParam("pFeedback","") ;	// -- 피드백 내용
	String redirectUrl = req.getParam("redirect_url","feedback.jsp");
	if( "".equals(sFeedback.trim()) ){
		out.print("fail to feedback") ;
		return ; 
	}
	
	int feedbackIdx = QueryHandler.executeQueryInt("GET_FEEDBACK_SEQUENCE");
	
	int ret = QueryHandler.executeUpdate("INSERT_FEEDBACK"
			,new String[]{ ""+feedbackIdx, sFeedback, ""+ownerIdx,""+TASK_IDX,DOMAIN_IDX});

	if(ret>0) {
		setTaskUpdateTime(TASK_IDX) ;
		
		NotificationService ntfcService = new NotificationService(oUserSession);
		ntfcService.sendFeedbackNotification(TASK_IDX, feedbackIdx, sFeedback);
		
		out.print(JavaScript.write("location.replace('"+redirectUrl+"?tsk_idx="+TASK_IDX+"');"));
	} else {
		out.print(JavaScript.write("alert('피드 등록 실패');"));
	}
%>
