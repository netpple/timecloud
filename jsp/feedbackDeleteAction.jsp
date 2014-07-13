<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%
	int iIdx = req.getIntParam("idx",-1) ;	// -- 피으백 내용
	
	if(TASK_IDX <=0 || iIdx <=0){
		out.print("fail to delete a feedback") ;
		return ;
	}
	
	int ret = QueryHandler.executeUpdate("DELETE_FEEDBACK" ,new String[]{ ""+iIdx, ""+ownerIdx });

	if(ret>0) {
		out.print(JavaScript.write("alert('삭제되었습니다.'); location.replace('feedback.jsp?tsk_idx="+TASK_IDX+"');"));
	} else {
		out.print(JavaScript.write("alert('삭제 실패');"));
	}
%>
