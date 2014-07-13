<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%
	String taskIdx = req.getParam("task_idx","");
	String toolIdx = req.getParam("tool_idx","");
	String toolType = req.getParam("tool_type","");
	String key = "";
	Object[] params = null;
	
	int result = 0;
	
	try {
		if(toolType.equals("FILE")) {
			key = "DELETE_FILE";
			params = new Object[] { toolIdx };
		} else if(toolType.equals("ACTIVITY")) {
			key = "DELETE_ACTIVITY";
			params = new Object[] { toolIdx };
		} else if(toolType.equals("FEEDBACK")) {
			key = "DELETE_FEEDBACK";
			params = new Object[] { toolIdx, oUserSession.getUserIdx() };
		}

		result = QueryHandler.executeUpdate(key, params);
		
	} catch (Exception e) {
	}
	
	if(result > 0) {
		out.print(result);
		//out.print(JavaScript.write("location.replace('task.jsp?tsk_idx="+taskIdx+"');"));
	} else {
		out.print(JavaScript.write("alert('처리실패');"));
	}
%>