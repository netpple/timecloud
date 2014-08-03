<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%
	//_globalTabNo = 4 ;

	int fileType = req.getIntParam("type", SELECT_ALL) ;
	
	String[] selected = new String[]{"","","","",""} ;
	String[] params;
	String qKey = "SELECT_FILE_ALL" ;
	String sType = ALL_TASK ;
	
	switch (fileType) {
		case SELECT_MY:
			qKey = "SELECT_FILE_MYTASK" ;
			sType = MY_TASK ;
			selected[SELECT_MY] = SELECTED_VALUE ;
			params = new String[] { Integer.toString(ownerIdx) };
			break ;
		case SELECT_MYCHILD:
			qKey = "SELECT_FILE_CHILD" ;
			sType = MYCHILD_TASK ;
			selected[SELECT_MYCHILD] = SELECTED_VALUE ;
			params = new String[] { Integer.toString(ownerIdx) };
			break ;
		case SELECT_OBSERVER :
			qKey = "SELECT_FILE_OBSERVER" ;
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
	StringBuffer sbFileList = null ;
	ds = QueryHandler.executeQuery(qKey,params) ;
	if(ds != null) {
		sbFileList = new StringBuffer() ;
		FileObject oFile = null ;
		while(ds.next()) {
			oFile = new FileObject(ds) ;
			sbFileList.append( oFile.get(oUserSession) ) ;
		}
	}

    // TODO - TEAM RANKING  - DOMAIN RANKING, GLOBAL RANKING 구분 적용방법 필요
    String rankTable = Html.trueString(TEAM_IDX>0,getFileTeamRankTable(oUserSession,Integer.toString(TEAM_IDX)));//getFileRankTable(oUserSession) ;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Files in <%=sType %></title>
<%@ include file="./common/include/incHead.jspf" %>
<script type="text/javascript">
	var SELECT_ALL = <%=SELECT_ALL%> ;
	var SELECT_MY = <%=SELECT_MY%> ;
	var SELECT_MYCHILD = <%=SELECT_MYCHILD%> ;
	var SELECT_OBSERVER = <%=SELECT_OBSERVER%> ;
	
	function allTaskFile(){
		return getFile(SELECT_ALL) ;
	}
	function myTaskFile(){
		return getFile(SELECT_MY) ;
	}
	function childTaskFile(){
		return getFile(SELECT_MYCHILD) ;
	}
	function observerTaskFile() {
		return getFile(SELECT_OBSERVER);
	}
	function getFile(type) {
		location.replace("fileAll.jsp?type="+type) ;
		return ;
	}
</script>
</head>
<body>
<div class='row-fluid'>
	<div class='span12'>
        <%@ include file="./menuGlobal.jsp" %>
		<div class='row-fluid'>
			<%--<div class='span2 vertNav'><%=getVertNav(req, oUserSession) %></div>--%>
			<div class='span12 all'>
				<div class='row-fluid'>	
					<div class='span6'>
						<span class="label label-success" >Files in</span>
						<ul class="nav nav-pills">
							<li class="<%=selected[SELECT_ALL]%>"><a href="javascript:allTaskFile();"><%=ALL_TASK %></a></li>
							<li class="<%=selected[SELECT_MY]%>"><a href="javascript:myTaskFile();"><%=MY_TASK %></a></li>
							<li class="<%=selected[SELECT_MYCHILD]%>"><a href="javascript:childTaskFile();"><%=MYCHILD_TASK %></a></li>
							<li class="<%=selected[SELECT_OBSERVER]%>"><a href="javascript:observerTaskFile();"><%=OBSERVER_TASK %></a></li>
						</ul>
					</div>
					<div class='span6' align=right><%=rankTable%></div>
				</div>
				<div><%=(sbFileList != null)?sbFileList.toString():"" %></div>
			</div>
		</div>
	</div>
    <%--<div class="span1"></div>--%>
	<%--<%=getNotification(oUserSession, "span3 noti") %>--%>
</div>
</body>
</html>
<%@ include file="./common/include/incFooter.jspf" %><%!
class FileObject {
	int n_idx = -1 ;
	int n_owner_idx = -1 ;
	int n_task_idx = -1 ;
	String v_origin_name ;
	String v_reg_datetime ;
	String v_task_desc ;
	int n_task_owner = -1 ;
	String v_file_owner ;
	String c_task_status ;
	
	public FileObject(DataSet ds) {
		this.n_idx = ds.getInt(1) ;
		this.n_owner_idx = ds.getInt(2) ;
		this.n_task_idx = ds.getInt(3) ;
		this.v_origin_name = ds.getString(4) ;
		this.v_reg_datetime = ds.getString(5) ;
		this.v_task_desc = ds.getString(6) ;
		this.n_task_owner = ds.getInt(7) ;
		this.v_file_owner = ds.getString(8) ;
		this.c_task_status = ds.getString(9) ;
	}
	
	public String get(UserSession sess) {
		StringBuffer sbOut = new StringBuffer() ;
		
		sbOut.append("<div style='float:left'>") 
				.append("<div style='float:left'>")
				.append( getProfileImage(n_owner_idx) )
				.append("</div>")
				.append("<div style='float:right;padding:0 0 0 10px'>")
					.append(v_file_owner).append("<br />")
					.append("<a href='/jsp/file.jsp?tsk_idx=").append(n_task_idx)	// -- 파일함에서 다운로드
					.append("'>")
					.append( stringToHTMLString( v_origin_name ) ).append("</a>")
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