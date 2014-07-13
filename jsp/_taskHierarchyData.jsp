<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %>
<%@ include file="./common/include/incTaskView.jspf" %><%

	
	if(TASK_IDX <= 0){
		out.print(-1);
		return ;
	}
	
	 dsTaskHierarchy = QueryHandler.executeQuery("SELECT_TASK_HIERARCHY", new  Object[]{oUserSession.getUserIdx(), "TIMECLOUD_TASK", TASK_IDX});
	 oTaskHierarchy = new TaskHierarchy(dsTaskHierarchy, oUserSession, TASK_IDX, TASK_LIST);
	 hierarchyJson = oTaskHierarchy.get();
	 
	 if(hierarchyJson != ""){
		out.print(hierarchyJson);
	 }else{
		out.print(-1);
	 }
%>
