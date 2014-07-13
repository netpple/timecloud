<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%
	String msgFail = JavaScript.redirect("태스크 상태처리 실패","taskList.jsp") ;
	String msgSuccess = JavaScript.redirect("처리 완료","taskList.jsp") ;

	if( TASK_IDX <=0 ){
		out.print(msgFail);
		return ;
	}

	String pTaskStatus = req.getParam("pTaskStatus", null) ;
	if(pTaskStatus == null || "".equals(pTaskStatus.trim())) {
		out.print(msgFail);
		return ;
	}
	
	/* Query
		UPDATE TIMECLOUD_TASK SET C_STATUS=?,v_edt_datetime=TO_CHAR(sysdate,'YYYYMMDDHH24MISS') 
		WHERE n_task_idx=? AND n_owner_idx=? AND C_DEL_YN='N' AND C_OFF_YN = 'N' */
	
	int ret = QueryHandler.executeUpdate("UPDATE_TASK_STATUS", new String[]{pTaskStatus, ""+TASK_IDX, ""+ownerIdx}) ;
	if(ret > 0) {
		out.print(msgSuccess);
	} else {
		out.print(msgFail);
	}
	
	return ;
%>