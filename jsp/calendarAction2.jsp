<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%

	int result = -1 ; // -- 처리 결과 확인용

	int iActivityIdx = req.getIntParam("pIdx", -1) ;
	if(iActivityIdx < 0){
		out.println("fail") ;
		return ;
	}
	
	String sStartDate = req.getParam("pStartDate","").replace("-","");
	String sEndDate = req.getParam("pEndDate","").replace("-","");

	// -- 캘린더 수정 시에는 시간값을 처리함.
	String sStartTime = req.getParam("pStartTime","").replace(":","");
	String sEndTime = req.getParam("pEndTime","").replace(":","");

	String sStartDateTime = sStartDate + sStartTime + "00";
	String sEndDateTime = sEndDate + sEndTime + "00";
	
	result = QueryHandler.executeUpdate("UPDATE_ACTIVITY_DATETIME"
			, new String[]{sStartDateTime, sEndDateTime, ""+iActivityIdx, ""+ownerIdx}) ;
	
	if(result > 0){
		out.print(1) ;
	}
	else out.print("-1") ;
%>