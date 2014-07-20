<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%
	_globalTabNo = 5 ;

	DataSet ds = QueryHandler.executeQuery("SELECT_PROJECT_ALL", oUserSession.getUserIdx()) ;
	
	String listOn = "" ;
	String listOff = "" ;
	
	if(ds != null) {
		int onCnt = 0 ,offCnt = 0 ;		// -- 진행 중, 종료
		
		Project project = null ;
 	 	while (ds.next()) {
 	 		project = new Project(ds,oUserSession) ;
 	 		if( project.isOFF() ) {
 	 			listOff += project.get() ;
 	 			offCnt ++ ;
 	 		}
 	 		else {
 	 			listOn += project.get() ;
 	 			onCnt ++  ;
 	 		}
		}
 	 	
 	 	String th = "<thead><tr><th>#</th><th>만든이</th><th>프로젝트</th><th>프로젝트 기간</th><th>상태</th><th>온/오프</th></tr></thead>" ;
 	 	listOn  = "<table class='table table-bordered table-hover'><caption><span class='label label-warning'>진행 중 프로젝트</span> 전체 "+onCnt+"건</caption>" + th + "<tbody>" + listOn  + "</tbody></table>" ;
 	 	listOff = "<table class='table table-bordered table-hover'><caption><span class='label label-important'>종료된 프로젝트</span> 전체 "+offCnt+"건</caption>" + th + "<tbody>" + listOff + "</tbody></table>" ;
	}
	else {
		listOn = "진행 중인 프로젝트가 없습니다." ;
		listOff = "종료 된 프로젝트가 없습니다." ;		
	}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Task List</title>
<%@ include file="./common/include/incHead.jspf" %>
</head>
<body>
 	<%@ include file="./menuGlobal.jsp" %>
	<div class='row-fluid'>
		<div class='span6'><%=listOn %></div>
		<div class='span6'><%=listOff %></div>
	</div>
</body>
</html><%!
class Project {
	String n_idx ;
	String v_desc ;
	String v_start_datetime ;
	String v_end_datetime ;
	String v_reg_datetime ;
	String v_edt_datetime ;
	String c_status ;
	String c_off_yn ;
	int n_owner_idx ;
	String v_project_owner ;
	int n_task_list ;
	
	UserSession sess ;
	
	String v_start_date = null;
	String v_end_date = null;
	// -- String v_start_time ;
	// -- String v_end_time ;
	
	public Project(DataSet ds, UserSession oUserSession) {
		this.n_idx = ds.getString(1) ;
		this.v_desc = ds.getString(2) ;
		this.v_start_datetime = ds.getString(3) ;
		this.v_end_datetime = ds.getString(4) ;
		this.v_reg_datetime = ds.getString(5) ;
		this.v_edt_datetime = ds.getString(6) ;
		this.c_status = ds.getString(7) ;
		this.c_off_yn = ds.getString(8) ;
		this.n_owner_idx = ds.getInt(9) ;
		this.v_project_owner = ds.getString(10) ;
		this.n_task_list = ds.getInt(11) ;
		
		this.sess = oUserSession ;
	}
	
	public String getIdx() {
		return n_idx ;
	}
	
	public String getStartDate(){
		if(v_start_date == null) {
			this.v_start_date = DateTime.convertDateFormat(v_start_datetime, "yyyy-MM-dd") ;
		}
		return v_start_date ;
	}
	
	public String getEndDate(){
		if(v_end_date == null){
			this.v_end_date = DateTime.convertDateFormat(v_end_datetime, "yyyy-MM-dd") ;
		}
		return v_end_date ;
	}
	
	public String getDesc() {
		return v_desc ;
	}
	
	private String getStatus() {
		String status = "" ;
		if( "01".equals(c_status) ) {
			status = "<span class='badge badge-warning'>지연</span>" ;
		}
		else if( "02".equals(c_status) ) {
			status = "<span class='badge badge-warning'>이슈</span>" ;
		}
		else if( "03".equals(c_status) ) {
			status = "<span class='badge badge-important'>중단</span>" ;	// -- 혹은 보류?
		}
		else if( "04".equals(c_status) ) {
			status = "<span class='badge badge-important'>실패</span>" ;
		}
		else if( "05".equals(c_status) ) {
			status = "<span class='badge badge-success'>성공</span>" ;
		}
		else {
			status = "<span class='badge badge-success'>정상</span>" ;
		}
		
		return status ;
	}
	
	public boolean isOFF(){
		return "Y".equals(c_off_yn) ;
	}
	
	public String get() {
		// -- task_idx를 경로에 노출하지 않는 방법은? 서버에 전송하는 QueryString 전체를 암호화하는게 좋을 듯
		// -- request 할 때, 해당 값을 base64 등으로 인코딩해야 돼. RequestHelper 등에 해당 메쏘드를 탑재
		// -- getParam할 때, 해당 값을 디코딩해야 돼, RequestHelper 쪽에서 파람 받는 상단에 디코딩 옵션 넣어야 함.
		String out = null ;
		String desc = null, status = null ;

		desc = stringToHTMLString( v_desc ) ;
		
		if(!isOFF()) {
			status = "<span class='label label-warning'>ON</span>" ;
		}
		else {
			status = "<span class='label label-important'>OFF</span>" ;
		}
		
		String photo = null ;
		photo = getProfileImage(n_owner_idx) ;
		
		out = 	"<tr><td>"+n_idx+"</td>"
				+ "<td>" +photo+"</td>"
				+ "<td><a href='javascript:onViewProject("+n_task_list+")'>"+desc+"</a></td>"
				+ "<td>"+getStartDate() +" ~ "+getEndDate()+"</td>"
				+ "<td>" + getStatus() +"<div>"+DateTime.convertDateFormat(v_edt_datetime)+"</div></td>"
				//+"<td>"+DateTime.convertDateFormat(v_reg_datetime)+"</td>"
				+ "<td>"+status+"</td></tr>"
				;
			
		return out ;
	}
}

%>