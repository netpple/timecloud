<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %><%@ include file="./common/include/incSession.jspf" %><%
	int iActivityIdx = req.getIntParam("pActivityIdx", -1) ;
	if(iActivityIdx < 0){
		out.print("fail to access") ;
		return ;
	}
	
	DataSet ds = QueryHandler.executeQuery("SELECT_ACTIVITY_INFO", new String[]{""+iActivityIdx, ""+ownerIdx}) ;
	Activity activity = null ;
	if(ds != null) {
 	 	if(ds.next()) {
 	 		activity = new Activity(ds) ;
		}
	}
	
	if(activity == null) {
		out.println("Fail to access .") ;
		return ;
	}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title><%=activity.getDesc() %></title>
<%@ include file="./common/include/incHead.jspf" %>
</head>
<body>
	<h1><%=stringToHTMLString( activity.getDesc() ) %></h1>
	<table>
		<tr><td>시작:</td><td><%=activity.getStartDatetime()%></td></tr>
		<tr><td>종료:</td><td><%=activity.getEndDatetime()%></td></tr>		
	</table>
</body>
</html><%!

class Activity {
	String n_idx ;
	String v_desc ;
	String v_start_datetime ;
	String v_end_datetime ;
	String v_reg_datetime ;
	String v_edt_datetime ;
	
	public Activity (DataSet ds) {
		this.n_idx = ds.getString("N_IDX") ;
		this.v_desc = ds.getString("V_DESC") ;
		this.v_start_datetime = ds.getString("V_START_DATETIME") ;
		this.v_end_datetime = ds.getString("V_END_DATETIME") ;
		this.v_reg_datetime = ds.getString("V_REG_DATETIME") ;
		this.v_edt_datetime = ds.getString("V_EDT_DATETIME") ;		
	}

	public String getDesc() {
		return v_desc ;
	}
	
	public String getStartDatetime() {
		return v_start_datetime ;
	}
	
	public String getEndDatetime() {
		return v_end_datetime ;
	}
}
%>