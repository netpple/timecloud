<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ include file="./common/include/incInit.jspf" %><%@ include file="./common/include/incSession.jspf" %><%
// -- ajax action
	int result = -1 ;	
	
	int pTaskIdx = req.getIntParam("pTaskIdx", -1) ;
	if(pTaskIdx <= 0) {
		out.print( result ) ;
		return  ;
	}
	
	String pTaskDesc = req.getParam("pTaskDesc", null) ;
	if(pTaskDesc == null || "".equals(pTaskDesc.trim())) {
		out.print( result ) ;
		return ;
	}
	
	Object[] param = new Object[]{pTaskDesc, pTaskIdx, oUserSession.getUserIdx()} ;
	out.print( QueryHandler.executeUpdate("TEST_UDPATE_TASK_DESC",param) ) ;
%>