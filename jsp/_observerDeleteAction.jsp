<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%
	int iIdx = req.getIntParam("idx",-1) ;	// -- 참조자
	
	if(TASK_IDX <=0 || iIdx <=0){
		out.print("fail to delete an observer") ;
		return ;
	}
	
	int ret = QueryHandler.executeUpdate("DELETE_OBSERVER" ,new String[]{ ""+iIdx });

	if(ret>0) {
		out.print(ret);
		//out.print(JavaScript.write("alert('삭제되었습니다.'); location.replace('observer.jsp?tsk_idx="+TASK_IDX+"');"));
	} else {
		out.print(JavaScript.write("alert('삭제 실패');"));
	}
%>
