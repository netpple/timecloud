<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %>
<%@ include file="./common/include/incTaskView.jspf" %><%

	final String STR_TASK_IDX = "" + TASK_IDX ;
	final String STR_OWNER_IDX = "" + ownerIdx ;
	final String STR_SORT = "0";

	
	if(TASK_IDX <= 0){
		out.print(-1);
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
		result = QueryHandler.executeUpdate("TEST_INSERT_FAVORITE",new String[]{ds.getString(2),STR_OWNER_IDX,"TIMECLOUD_"+tblName, ds.getString(1), STR_TASK_IDX, STR_SORT});
	}



	
	 dsTaskHierarchy = QueryHandler.executeQuery("SELECT_TASK_HIERARCHY", new  Object[]{oUserSession.getUserIdx(), "TIMECLOUD_TASK", TASK_IDX});
	 oTaskHierarchy = new TaskHierarchy(dsTaskHierarchy, oUserSession, TASK_IDX, TASK_LIST);
	 hierarchyJson = oTaskHierarchy.get();

	if(result == 1) {
		out.print(hierarchyJson);
	} else {
		out.print(-1);
	}
%>
