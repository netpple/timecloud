<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%

	if( TASK_IDX <=0 ){
		out.print(JavaScript.redirect("잘못된 접근입니다.","taskList.jsp"));
		return ;
	}

	String msgFail = JavaScript.redirect("프로젝트 상태처리 실패","project.jsp?tsk_idx="+TASK_IDX) ;
	String msgSuccess = JavaScript.redirect("처리 완료","project.jsp?tsk_idx="+TASK_IDX) ;
	
	final int PROJECT_IDX = req.getIntParam("pProjectIdx",-1) ;
	if( PROJECT_IDX <=0) {
		out.print(msgFail) ;	
	}
	

	String pProjectStatus = req.getParam("pProjectStatus", null) ;
	if(pProjectStatus == null || "".equals(pProjectStatus.trim())) {
		out.print(msgFail);
		return ;
	}
	
	/* Query
		UPDATE TIMECLOUD_PROJECT SET C_STATUS=?,v_edt_datetime=TO_CHAR(sysdate,'YYYYMMDDHH24MISS') 
		WHERE n_task_idx=? AND n_owner_idx=? AND C_DEL_YN='N' AND C_OFF_YN = 'N' */
	
	int ret = QueryHandler.executeUpdate(
			"UPDATE_PROJECT_STATUS"
			, new String[]{pProjectStatus, Integer.toString(PROJECT_IDX), Integer.toString(oUserSession.getUserIdx())}) ;
	if(ret > 0) {
		out.print(msgSuccess);
	} else {
		out.print(msgFail);
	}
	
	return ;
%>