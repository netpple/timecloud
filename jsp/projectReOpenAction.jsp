<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%
	if(TASK_IDX <= 0){
		out.print( JavaScript.redirect("잘못된 접근입니다.", "taskList.jsp") ) ;
		return ;
	}

	String url = "project.jsp?tsk_idx="+TASK_IDX ;
	final String SUCCESS = JavaScript.redirect("프로젝트가 재개 되었습니다.", url) ;
	final String FAIL = JavaScript.redirect("프로젝트 활성화에 실패했습니다", url) ; 

	final int PROJECT_IDX = req.getIntParam("pProjectIdx", -1) ;
	if(PROJECT_IDX <=0){
		out.print( FAIL ) ;
		return ;
	}

	int ret = QueryHandler.executeUpdate("UPDATE_PROJECT_ON"
			, new String[]{Integer.toString(PROJECT_IDX), Integer.toString(oUserSession.getUserIdx())}) ;
	
	if(ret > 0) {
		out.print( SUCCESS );
	} else {
		out.print( FAIL );
	}
%>
