<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%

	final String STR_TASK_IDX = "" + TASK_IDX ;
	final String STR_OWNER_IDX = "" + ownerIdx ;
	final String STR_SORT = "0";
	final String actionUrl = req.getParam("actionUrl","");
	
	
	String replaceUrl = "task.jsp?tsk_idx="+STR_TASK_IDX;
	if(actionUrl.length() > 0 && !actionUrl.equals("undefined")){
		replaceUrl = actionUrl+"?tsk_idx="+STR_TASK_IDX;
	}
	
	if(TASK_IDX <= 0){
		out.print(JavaScript.write("alert('즐겨찾기 추가에 실패했습니다.'); location.replace('"+replaceUrl+"');"));
		return ;
	}
	
	
	DataSet ds = QueryHandler.executeQuery("SELECT_TASK_INFO2", STR_TASK_IDX) ;
	if(ds == null || !ds.next()) {
		out.println("-1") ;
		return ;
	}
	

	final String tblName = req.getParam("tbl_name","");
	int result = 0;
	if(tblName.equals("TASK")){
		result = QueryHandler.executeUpdate("TEST_INSERT_FAVORITE"
                ,new String[]{ds.getString(2),STR_OWNER_IDX,"TIMECLOUD_"+tblName, ds.getString(1), STR_TASK_IDX, STR_SORT,DOMAIN_IDX});
	}


	
	if(result == 1) {
		out.print(
				JavaScript.write("location.replace('"+replaceUrl+"');"));
	} else {
		out.print(JavaScript.write("alert('즐겨찾기 추가에 실패했습니다.'); location.replace('"+replaceUrl+"');"));
	}
%>
