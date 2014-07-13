<%@ page import="java.io.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%
	_globalTabNo = 8 ;

	int activityType = req.getIntParam("type", SELECT_ALL) ;
	
	String[] selected = new String[]{"","","","",""} ;
	String[] params;
	String qKey = "SELECT_ACTIVITY_ALL" ;
	String sType = ALL_TASK ;
	switch (activityType) {
		case SELECT_MY:
			qKey = "SELECT_ACTIVITY_MYTASK" ;
			sType = MY_TASK ;
			selected[SELECT_MY] = SELECTED_VALUE ;
			params = new String[] { Integer.toString(ownerIdx) };
			break ;
		case SELECT_MYCHILD:
			qKey = "SELECT_ACTIVITY_CHILD" ;
			sType = MYCHILD_TASK ;
			selected[SELECT_MYCHILD] = SELECTED_VALUE ;
			params = new String[] { Integer.toString(ownerIdx) };
			break ;
		case SELECT_OBSERVER :
			qKey = "SELECT_ACTIVITY_OBSERVER" ;
			sType = OBSERVER_TASK ;
			selected[SELECT_OBSERVER] = SELECTED_VALUE ;
			params = new String[] { Integer.toString(ownerIdx) };
			break;			
		default:
			selected[SELECT_ALL] = SELECTED_VALUE ;
			params = new String[] { Integer.toString(ownerIdx), Integer.toString(ownerIdx) };
			break;
	}

	DataSet ds = null ;
	StringBuffer sbActivityList = null ;
	ds = QueryHandler.executeQuery(qKey,params) ;
	if(ds != null) {
		sbActivityList = new StringBuffer() ;
		Activity oActivity = null ;
		while(ds.next()) {
			oActivity = new Activity(ds) ;
			sbActivityList.append( oActivity.get(oUserSession) ) ;
		}
	}
	
	// -- 랭킹 출력
	String rankTable = getActivityRankTable(oUserSession) ;	
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Activities from <%=sType %></title>
<%@ include file="./common/include/incHead.jspf" %>
<script type="text/javascript">
	var SELECT_ALL = <%=SELECT_ALL%> ;
	var SELECT_MY = <%=SELECT_MY%> ;
	var SELECT_MYCHILD = <%=SELECT_MYCHILD%> ;
	var SELECT_OBSERVER = <%=SELECT_OBSERVER%> ;
	
	function allTaskActivity(){
		return getActivity(SELECT_ALL) ;
	}
	function myTaskActivity(){
		return getActivity(SELECT_MY) ;
	}
	function childTaskActivity(){
		return getActivity(SELECT_MYCHILD) ;
	}
	function observerTaskActivity() {
		return getActivity(SELECT_OBSERVER);
	}
	function getActivity(type) {
		location.replace("activityAll.jsp?type="+type) ;
		return ;
	}
</script>
</head>
<body>
	<%@ include file="./menuGlobal.jsp" %>
	<div>	
		<div style='float:left'>
			<span class="label label-info" >Activities from</span>
			<ul class="nav nav-pills">
				<li class="<%=selected[SELECT_ALL]%>"><a href="javascript:allTaskActivity();"><%=ALL_TASK %></a></li>
				<li class="<%=selected[SELECT_MY]%>"><a href="javascript:myTaskActivity();"><%=MY_TASK %></a></li>
				<li class="<%=selected[SELECT_MYCHILD]%>"><a href="javascript:childTaskActivity();"><%=MYCHILD_TASK %></a></li>
				<li class="<%=selected[SELECT_OBSERVER]%>"><a href="javascript:observerTaskActivity();"><%=OBSERVER_TASK %></a></li>
			</ul>
		</div>
		<div style='float:right'><%=rankTable%></div><br style='clear:both' />
	</div>
	<div><%=(sbActivityList != null)?sbActivityList.toString():"" %></div>
</body>
</html><%!
class Activity {
	int n_idx = -1 ;
	int n_owner_idx = -1 ;
	int n_task_idx = -1 ;
	String v_desc ;
	String v_reg_datetime ;
	String v_task_desc ;
	int n_task_owner = -1 ;
	String v_activity_owner ;
	String c_task_status ;
	
	public Activity(DataSet ds) {
		this.n_idx = ds.getInt(1) ;
		this.n_owner_idx = ds.getInt(2) ;
		this.n_task_idx = ds.getInt(3) ;
		this.v_desc = ds.getString(4) ;
		this.v_reg_datetime = ds.getString(5) ;
		this.v_task_desc = ds.getString(6) ;
		this.n_task_owner = ds.getInt(7) ;
		this.v_activity_owner = ds.getString(8) ;
		this.c_task_status = ds.getString(9) ;
	}
	
	public String get(UserSession sess) {
		StringBuffer sbOut = new StringBuffer() ;
		
		sbOut.append("<div style='float:left'>") 
				.append("<div style='float:left'>")
				.append( getProfileImage(sess.getDomainIdx(), n_owner_idx) )
				.append("</div>")
				.append("<div style='float:right;padding:0 0 0 10px'>")
					.append(v_activity_owner).append("<br />")
					.append("<a href='javascript:onViewCalendar(").append(n_task_idx)
					.append(");'>")
					.append( stringToHTMLString( v_desc )  ).append( "</a>")
					.append("<br /><a href='javascript:onViewCalendar(").append(n_task_idx)
					.append(");'><span class='label'>태스크</span> ").append( stringToHTMLString( v_task_desc ) )
				.append("</a> ").append(getTaskStatus()).append("<br /><i>")
				.append( DateTime.convertDateFormat(v_reg_datetime) )
				.append("</i></div>")
			.append("</div><br style='clear:both' />") ;
		return sbOut.toString() ;
	}
	
	// -- 이 메쏘는 Task에서 온것으로, 추후 Task 클래스의 static 메쏘드로 선언해야 할 듯함.
	private String getTaskStatus() {
		String status = "" ;
		if( "01".equals(c_task_status) ) {
			status = "<span class='badge badge-warning'>지연</span>" ;
		}
		else if( "02".equals(c_task_status) ) {
			status = "<span class='badge badge-warning'>이슈</span>" ;
		}
		else if( "03".equals(c_task_status) ) {
			status = "<span class='badge badge-important'>중단</span>" ;	// -- 혹은 보류?
		}
		else if( "04".equals(c_task_status) ) {
			status = "<span class='badge badge-important'>실패</span>" ;
		}
		else if( "05".equals(c_task_status) ) {
			status = "<span class='badge badge-success'>성공</span>" ;
		}
		else {
			status = "<span class='badge badge-success'>정상</span>" ;
		}
		
		return status ;
	}
}
%>
<%!
	public static final int SELECT_ALL = 1 ;
	public static final int SELECT_MY = 2 ;
	public static final int SELECT_MYCHILD = 3 ;
	public static final int SELECT_OBSERVER = 4;
	
	public static final String SELECTED_VALUE = "active" ;
	
	public static final String ALL_TASK = "전체태스크" ;
	public static final String MY_TASK = "마이태스크" ;
	public static final String MYCHILD_TASK = "할당태스크" ;
	public static final String OBSERVER_TASK = "참조태스크";
%>