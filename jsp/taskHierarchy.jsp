<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%
	_toolTabNo = 2 ;

	%><%@ include file="taskHierarchyInfo.jsp" %><%

	HierarchyTask currentTask = oTaskHierarchy.getCurrentTask() ;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Task Hierarchy</title>
<%@ include file="./common/include/incHead.jspf" %>
</head>
<body>
	<%@ include file="./menuTool.jsp" %>
	<h3><%=currentTask.getDesc() %></h3>
	<ul>
		<%=oTaskHierarchy.get()%>
	</ul>
</body>
</html>
