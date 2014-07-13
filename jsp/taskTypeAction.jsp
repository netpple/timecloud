<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ include file="./common/include/incInit.jspf" %><%@ include file="./common/include/incSession.jspf" %><%
	if(TASK_IDX <= 0 ) { 
		out.print(FAIL) ;
		return ;
	}

	int iTaskTypePos = req.getIntParam("pTaskTypePos", -1) ;
	if(iTaskTypePos < 0){
		out.print(FAIL) ;
		return ;
	}
	
	String sNewTaskType = toggleTaskType(iTaskTypePos, TASK_IDX) ;
	if(sNewTaskType == null){
		out.print(FAIL) ;
		return ;
	}
	
	int result = -1 ; // -- 처리 결과 확인용
	result = QueryHandler.executeUpdate("UPDATE_TASK_TYPE"
			, new String[]{sNewTaskType, Integer.toString(TASK_IDX), Integer.toString(oUserSession.getUserIdx())}) ;
	if(result > 0){
		out.print(SUCCESS) ;
	}
	else out.print(FAIL) ;
%><%!
	public static final int SUCCESS = 1 ;
	public static final int FAIL = -1 ;
	
	class Task {
		public static final int TASK_TYPE_SIZE = 10 ;
	}
	
	public static String toggleTaskType(int pos, int taskIdx){	// -- TODO - Task class의 static function으로 들어가야함.
		String taskType = QueryHandler.executeQueryString("SELECT_TASK_TYPE", taskIdx) ;
		if(taskType == null || taskType.length() != Task.TASK_TYPE_SIZE) {	// -- validation
			return null ;
		}
		if(pos<0 || pos>=Task.TASK_TYPE_SIZE)return null ;
		
		String newTaskType ="" ;
		
		String value = taskType.substring(pos,pos+1) ;	// -- 해당 위치(pos)의 값
		value = ("1".equals(value))?"0":"1" ;
		
		String head = taskType.substring(0,pos) ;
		String tail = ((pos+1) != Task.TASK_TYPE_SIZE)?taskType.substring(pos+1):"" ; // -- pos가 제일 마지막이면 tail은 ""임.
		newTaskType = head + value + tail ;
	
		return newTaskType ;
	}
%>