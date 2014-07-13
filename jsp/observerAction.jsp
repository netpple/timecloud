<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%
	if(TASK_IDX <= 0 ) { 
		out.println("Parameter is invalid") ;
		return ;
	}

/*
	int iUserIdx = req.getIntParam("pUserIdx",-1) ;	// -- 피드백 내용
	if( iUserIdx <= 0 ){
		out.print("fail to add an observer ..") ;
		return ;
	}
*/
	
	String[] observerUsers = req.getParamValues("pObserver");

	if(observerUsers == null) {
		out.print("select observer user");
		return;
	}

	String pComment = req.getParam("pComment","") ;	// -- 피드백 내용
	
	if( "".equals(pComment.trim()) ){
		out.print("fail to add an observer ..") ;
		return ;
	}
	
	int ret = 0;
	int observerIdx  = 0;
	
	for(int i=0; i < observerUsers.length; i++) {
		observerIdx = QueryHandler.executeQueryInt("GET_OBSERVER_SEQUENCE");
		String userIdx = observerUsers[i];
		ret += QueryHandler.executeUpdate("INSERT_OBSERVER"
                ,new String[]{ ""+observerIdx, pComment, userIdx, ""+TASK_IDX,DOMAIN_IDX});
	}
	
	if(ret>0) {
		NotificationService ntfcService = new NotificationService(oUserSession);
		ntfcService.sendObserverNotification(TASK_IDX);
		out.print(JavaScript.write("alert('참조자 등록 완료'); location.replace('observer.jsp?tsk_idx="+TASK_IDX+"');"));
	} else {
		out.print(JavaScript.write("alert('참조자 등록 실패');"));
	}
%>
