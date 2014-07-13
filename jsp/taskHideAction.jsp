<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%
	String msgFail = JavaScript.redirect("태스크 상태처리 실패","taskList.jsp") ;
	String msgSuccess = JavaScript.redirect("처리 완료","taskList.jsp") ;

	if( TASK_IDX <=0 ){
		out.print(msgFail);
		return ;
	}

	String control = req.getParam("control", "N") ;
	
	int ret = QueryHandler.executeUpdate("UPDATE_TASK_HIDE", new String[]{control, ""+TASK_IDX, ""+ownerIdx}) ;
	if(ret > 0) {
		out.print(msgSuccess);
	} else {
		out.print(msgFail);
	}
	
	return ;
%>