<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%
	if(TASK_IDX <= 0 ) { 
		out.println("Parameter is invalid") ;
		return ;
	}
	
	final String STR_TASK_IDX =  ""+TASK_IDX ;
	final String STR_OWNER_IDX = ""+oUserSession.getUserIdx() ;
	
	String sDesc = req.getParam("pDescription","") ;
	if( "".equals(sDesc.trim()) ) {
		out.print(FAIL) ;
		return ;	
	}
	
	// -- PROJECT 마스터  정보
	DataSet ds = QueryHandler.executeQuery("SELECT_TASK_HIERARCHY_LIST_IDX2", TASK_IDX) ;
	if(ds == null || !ds.next()){
		out.print(FAIL) ;
		return ;
	}
	
	final int TASK_LIST_IDX = ds.getInt(1) ;
	if(TASK_LIST_IDX <=0) {
		out.print(FAIL) ;
		return ;
	}
	// -- 
	
	String sStartDate = req.getParam("pStartDate","00000000").replace("-","");
	String sEndDate = req.getParam("pEndDate","00000000").replace("-","");

	// -- 캘린더 수정 시에는 시간값을 처리함.
	String sStartTime = req.getParam("pStartTime","0000").replace(":","");
	String sEndTime = req.getParam("pEndTime","0000").replace(":","");

	String sStartDateTime = sStartDate + sStartTime + "00";
	String sEndDateTime = sEndDate + sEndTime + "00";

	int result = -1 ; // -- 처리 결과 확인용
	String query = null ;
	String[] param = null ;

	int iProjectIdx = req.getIntParam("pIdx", -1) ;
	if(iProjectIdx > 0){ // -- 수정
		query = "UPDATE_PROJECT" ;
		param = new String[]{sDesc, sStartDateTime, sEndDateTime, Integer.toString(iProjectIdx), STR_OWNER_IDX} ;
	}
	else {
		query = "INSERT_PROJECT" ;
		param = new String[]{Integer.toString(TASK_LIST_IDX), sDesc, sStartDateTime, sEndDateTime, STR_OWNER_IDX, DOMAIN_IDX} ;
	}
	
	result = QueryHandler.executeUpdate(query, param) ;
	if(result > 0) out.print(SUCCEESS) ;
	else out.print(FAIL) ;
	
%><%!
public static final int SUCCEESS = 1 ;
public static final int FAIL = -1 ;
%>