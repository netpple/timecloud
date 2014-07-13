<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ include file="./common/include/incInit.jspf" %><%@ include file="./common/include/incSession.jspf" %><%!
%><%
	final int myIdx = oUserSession.getUserIdx() ;

	DataSet ds = null ;
	ds = QueryHandler.executeQuery("TEST_SELECT_MYTASK", myIdx ) ;	
	String myTask = getTaskLi(ds) ;
	
	ds = QueryHandler.executeQuery("TEST_SELECT_MYCOMMAND", new Object[]{myIdx, myIdx}) ;	
	String myCommand = getTaskLi(ds) ;
	
	ds = QueryHandler.executeQuery("TEST_SELECT_MYOBSERVED", myIdx) ;
	String myObserved = getTaskLi(ds) ;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Task List</title>
<%@ include file="./common/include/incHead.jspf" %>
</head>
<body>
<div class='row-fluid'>
	<div class='span10'>
		<%@ include file="./menuGlobal.jsp" %>
		<div class='row-fluid'>
			<div class='span2 vertNav'><%=getVertNav(req, oUserSession) %></div>
			<div class='span5'>
				<form id='f1' method='post' action='taskAction.jsp' class="form-inline" onSubmit="onSubmit(this); return false;">
					<input type='hidden' name='redirect' value='main.jsp' />
					<input type="text" id="taskRegister" name="pTaskDesc" class="input-xlarge" placeholder="태스크를 적어주세요 .." autofocus onKeyup="if (event.keyCode == 13) onSubmit(document.forms[0]);"/> <button type="submit" class='btn btn-primary'>등록</button>
				</form>
			<%--
			 --%>
				<div>
					<h6>할 일<small> <a href="javascript:onViewTaskList();">더보기</a></small></h6>
					<ul><%=myTask %></ul>			
				</div>
			</div>
			<div class='span5'>
				<div>
					<h6>시킨 일<small> <a href="javascript:onViewChildTask();">더보기</a></small></h6>
					<ul><%=myCommand %></ul>			
				</div>
				<div>
					<h6>CC<small> <a href="javascript:onViewObserverTask();">더보기</a></small></h6>
					<ul><%=myObserved %></ul>			
				</div>						
			</div>		
		</div>
	</div>
	<%=getNotification(oUserSession, "span2 noti") %>
</div>
</body>
</html>
<%@ include file="./common/include/incFooter.jspf" %>