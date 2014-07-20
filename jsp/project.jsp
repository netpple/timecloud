<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%
	if(TASK_IDX <= 0){
		out.print( JavaScript.redirect("잘못된 접근입니다.", "taskList.jsp") ) ;
		return ;
	}

	_toolTabNo = -1 ; // 4 ;	// -- tooltab에서 제거 
	
	String btnTitle = "등록" ;
	
	DataSet ds = QueryHandler.executeQuery("SELECT_PROJECT_INFO", TASK_IDX) ;
	Project project = null ;
	if(ds != null && ds.next())  {
		project = new Project(ds, oUserSession) ;
		btnTitle = "수정" ;
	}
	else {
		String url = "calendar.jsp?tsk_idx="+TASK_IDX ;
		final String FAIL = JavaScript.redirect("프로젝트 정보가 없습니다", url) ;
		// -- TODO - 현재 태스크 소유주 정보를 확인하여, 태스크 소유주만이 쓸 수 있게 한다. -- 현재 태스크 관련정보는 세션에서 임시 관리하는게 어떨까?
		ds = QueryHandler.executeQuery("SELECT_TASK_INFO3", TASK_IDX) ;
		if(ds == null) {	// -- 최상위 태스크 정보 획득에 실패한 경우
			out.print( FAIL ) ;
			return ;	
		}
		
		if(!ds.next()) {
			out.print( FAIL ) ;
			return ;
		}
	}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Communication / Project Tools</title>
<%@ include file="./common/include/incHead.jspf" %>
<script type="text/javascript">
	$(document).ready(function() {
		$('#endDate').datepicker({
			format : 'yyyy-mm-dd',
			language : "kr"
		});
		$('#startDate').datepicker({
			format : 'yyyy-mm-dd',
			language : "kr"
		});
	});
	
	var isSubmit = false ;
	function lock(){ if(isSubmit)return isSubmit ;  isSubmit = true ; }
	function unlock(){ isSubmit = false ; }
	
	function projectForm() {
		$("#register").modal('show') ;
	}
	function save() {
		if( lock() ) {
			alert("처리 중입니다..") ;	
			return false ;
		}
		
		var desc = document.getElementById("desc");
		var startDate = document.getElementById("startDate");
		var endDate = document.getElementById("endDate");
		/*
		var startTime = document.getElementById("startTime");
		var endTime = document.getElementById("endTime");
		*/
		if(desc.value == '') {
			alert('내용을 입력하세요');
			desc.focus();
			return;
		}
		
		$.ajax({
			type: 'post', 
			async: true, 
			url: 'projectAction.jsp', 
			data: $("#frmProjectAdd").serialize() , 
			beforeSend: function() {
			}, 
			success: function(data) {
				if(data > 0) {	// -- TODO - 방금 등록한 액티비티 시퀀스를 받아서 저장해야 함
					alert('저장되었습니다.');
					
					/*
					desc.value = "";
					startDate.value = "";
					endDate.value = "";
					startTime.value = "";
					endTime.value = "";
					
					$("#register").modal('hide') ;
					*/
				} else {
					alert('저장 실패');
				}
			}, 
			error: function(data, status, err) {
				alert('저장 실패');
			}, 
			complete: function() { 
				// -- unlock() ;
				// -- TODO - 본 처리는 임시처리로, 원래 AJAX 처리 후에는 테이블 값들이 새로 동기화 돼야 하나, RELOAD 시켜서 동기화 하도록 임시 처리함
				location.reload() ;
			}
		});
	}
	
<%if(project != null){%>
	function updateProjectStatus(projectStatus) {
		location.href= '<%=CONTEXT_PATH%>/jsp/projectStatusAction.jsp?tsk_idx=<%=TASK_IDX%>&pProjectIdx=<%=project.getIdx()%>&pProjectStatus='+projectStatus;
		return ;
	}
	
	function onProject() {
		if(confirm("프로젝트를 활성화합니다.\n계속하시겠습니까?")){
			location.replace("<%=CONTEXT_PATH%>/jsp/projectReOpenAction.jsp?tsk_idx=<%=TASK_IDX%>&pProjectIdx=<%=project.getIdx()%>") ;
		}
		else return ;
	}
	
	function offProject() { // -- task termination
		if(confirm("프로젝트 종료를 진행합니다.\n계속하시겠습니까?")){
			location.replace("<%=CONTEXT_PATH%>/jsp/projectCloseAction.jsp?tsk_idx=<%=TASK_IDX%>&pProjectIdx=<%=project.getIdx()%>") ;
		}
		else return ;
	}
<%}%>
</script>
</head>
<body>
	<%--<%@ include file="./menuTool.jsp" %>--%>
	
	<%	if(project != null) { 
		if(project.isOwner()){	// -- project owner만 수정 가능
	%>
		<div style='float:right;padding:0 0 5px 0'>
			<button type=button class='btn btn-primary' onclick="javascript:projectForm()">프로젝트 <%=btnTitle %></button>
		</div><br style='clear:both' />
	<%			
		}
	%>			
	<div><%= project.get()%></div>
	<% } else { 
		Task task = new Task(ds,oUserSession) ;
		if( task.isOwner() ) {	// -- 최상위태스크의 소유주면 프로젝트를  생성할 수 없음
	%>
	<div class="hero-unit">
	  <h1>프로젝트를 생성하십시오 ..</h1>
	  <p>최상위 태스크로 부터 프로젝트를 시작할 수 있습니다. 프로젝트 관점에서 태스크들을 구조적으로 관리할 수 있도록 지원합니다. </p>
	  <p>
	    <a class="btn btn-primary btn-large" onclick="javascript:projectForm()">
	      	프로젝트 생성
	    </a>
	  </p>
	</div>	
	<% } else { %>
	<div class="hero-unit">
	  <h1>프로젝트를 생성하십시오 ..</h1>
	  <p>최상위 태스크로 부터 프로젝트를 시작할 수 있습니다. 프로젝트 관점에서 태스크들을 구조적으로 관리할 수 있도록 지원합니다. </p>
	  <p>
		최상위 태스크 오너만이 프로젝트를 만들 수 있습니다.
		<%=task.get() %>
	  </p>
	</div>
	<% }
	}%>
	<div id="register" class="modal hide fade" tabindex="-1" role="dialog" 
		aria-labelledby="registerLabel" aria-hidden="true">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			<h3 id="registerLabel">프로젝트 <%=btnTitle %></h3>
		</div>
			<div class="modal-body">
			<form id="frmProjectAdd" class="form-horizontal">
				<input type="hidden" name="tsk_idx" value="<%=TASK_IDX%>"/>
				<input type="hidden" name="pIdx" value="<%=(project != null)?project.getIdx():""%>"/>
				<div class="control-group">
					<label class="control-label" for="startDate">시작 </label>
					<div class="controls">
						<input type="text" id="startDate" name="pStartDate" value="<%=(project != null)?project.getStartDate():"" %>" /> <!-- input type="time" id="startTime" name="pStartTime" value=""/-->
					</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="endDate">종료</label>
					<div class="controls">
						<input type="text" id="endDate" name="pEndDate" value="<%=(project != null)?project.getEndDate():"" %>" /> <!-- input type="time" id="endTime" name="pEndTime" value=""/-->
					</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="desc">내용</label>
					<div class="controls">
						<textarea id="desc" name="pDescription" rows=3 placeholder="프로젝트 개요를 남겨주세요 .."><%=(project != null)?project.getDesc():"" %></textarea>
					</div>
				</div>
			</form>		
			</div>
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
				<button class="btn btn-primary" onClick="javascript:save();">Save changes</button>
			</div>
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
		
		this.sess = oUserSession ;
	}
	
	public boolean isOwner() {
		return (n_owner_idx == sess.getUserIdx()) ;
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
	
	private String getStatusControl() {
		
		// -- toggle button style
		String statusControl = getStatusDropdown() ; // -- getStatusToggle() ;
							
		return statusControl ;
	}
	
	private String getStatusDropdown() {
		StringBuffer dropdown = new StringBuffer() ;
		String active = "정상" ;
		String statusStyle = "success" ;
		if( "01".equals(c_status) ) {
			active = "지연" ;
			statusStyle = "warning" ;
		}
		else if( "02".equals(c_status) ) {
			active = "이슈" ;
			statusStyle = "warning" ;
		}
		else if( "03".equals(c_status) ) {
			active = "중단" ;
			statusStyle = "danger" ;
		}
		else if( "04".equals(c_status) ) {
			active = "실패" ;
			statusStyle = "danger" ;
		}
		else if( "05".equals(c_status) ) {
			active = "성공" ;
			statusStyle = "success" ;
		}
		else {}

		dropdown.append("<div class='btn-group'>")
		
				.append("<button class='btn btn-mini btn-").append(statusStyle).append("'>").append(active).append("</button>")
				.append("<button class='btn btn-mini dropdown-toggle' data-toggle='dropdown'>")
					.append("<span class='caret'></span>")
				.append("</button>")
				.append("<ul class='dropdown-menu'>") ;
		
		if(!"00".equals(c_status))dropdown.append("<li><a href=\"javascript:updateProjectStatus('00');\">정상</a></li>") ;
		if(!"01".equals(c_status))dropdown.append("<li><a href=\"javascript:updateProjectStatus('01');\">지연</a></li>") ;
		if(!"02".equals(c_status))dropdown.append("<li><a href=\"javascript:updateProjectStatus('02');\">이슈</a></li>") ;
		if(!"03".equals(c_status))dropdown.append("<li><a href=\"javascript:updateProjectStatus('03');\">중단</a></li>") ;
		if(!"04".equals(c_status))dropdown.append("<li><a href=\"javascript:updateProjectStatus('04');\">실패</a></li>") ;
		if(!"05".equals(c_status))dropdown.append("<li><a href=\"javascript:updateProjectStatus('05');\">성공</a></li>") ;
		
		dropdown.append("</ul>")
				.append("</div>") ;
		
		return String.format(dropdown.toString()) ; 
	}
	
	private String getStatusToggle() {
		String[] active = new String[]{"","","","","",""} ;
		if( "01".equals(c_status) ) {
			active[1] = "active" ;
		}
		else if( "02".equals(c_status) ) {
			active[2] = "active" ;
		}
		else if( "03".equals(c_status) ) {
			active[3] = "active" ;
		}
		else if( "04".equals(c_status) ) {
			active[4] = "active" ;
		}
		else if( "05".equals(c_status) ) {
			active[5] = "active" ;
		}
		else {
			active[0] = "active" ;
		}
		
		// -- toggle button style
		String toggle = "<div class='btn-group' data-toggle='buttons-radio'>"
							+ "<button type='button' class='btn btn-mini "+active[0]+"' onclick=\"javascript:updateProjectStatus('00');\">정상</button>"
							+ "<button type='button' class='btn btn-mini "+active[1]+"' onclick=\"javascript:updateProjectStatus('01');\">지연</button>"					
							+ "<button type='button' class='btn btn-mini "+active[2]+"' onclick=\"javascript:updateProjectStatus('02');\">이슈</button>"
							+ "<button type='button' class='btn btn-mini "+active[3]+"' onclick=\"javascript:updateProjectStatus('03');\">중단</button>"
							+ "<button type='button' class='btn btn-mini "+active[4]+"' onclick=\"javascript:updateProjectStatus('04');\">실패</button>"
							+ "<button type='button' class='btn btn-mini "+active[5]+"' onclick=\"javascript:updateProjectStatus('05');\">성공</button>"
							+ "</div><div>" ;
		return toggle ;		
	}
	
	public boolean isOFF(){
		return "Y".equals(c_off_yn) ;
	}
	
	private String getOnOffToggle() {
		String[] active = new String[]{"",""} ;
		if( isOFF() ) {
			active[1] = "active" ;
		}
		else {
			active[0] = "active" ;
		}
		
		String toggle = "<div class='btn-group'><button type='button' class='btn btn-mini %s' onclick=\"javascript:onProject();\">On</button><button type='button' class='btn btn-mini %s' onclick=\"javascript:offProject();\">Off</button></div>" ;		
		return String.format(toggle, active[0],active[1]) ;
	}
	
	public String get() {
		// -- task_idx를 경로에 노출하지 않는 방법은? 서버에 전송하는 QueryString 전체를 암호화하는게 좋을 듯
		// -- request 할 때, 해당 값을 base64 등으로 인코딩해야 돼. RequestHelper 등에 해당 메쏘드를 탑재
		// -- getParam할 때, 해당 값을 디코딩해야 돼, RequestHelper 쪽에서 파람 받는 상단에 디코딩 옵션 넣어야 함.
		String out = null ;
		String desc = null, onOffStatus = null ;
		String projectStatus = null ;

		desc = stringToHTMLString( v_desc ) ;
		onOffStatus = getOnOffToggle() ;	
		projectStatus = getStatusControl() ;
		
		String photo = null ;
		photo = getProfileImage(n_owner_idx) ;
		
		out = 	"<tr><td>"+n_idx+"</td>"
				+ "<td>" +photo+"</td>"
				+ "<td>"+desc+"</td>"
				+ "<td>"+getStartDate() +" ~ "+getEndDate()+"</td>"
				+ "<td>" + projectStatus +"<div>"+DateTime.convertDateFormat(v_edt_datetime)+"</div></td>"
				//+"<td>"+DateTime.convertDateFormat(v_reg_datetime)+"</td>"
				+ "<td>"+onOffStatus+"</td></tr>"
				;
 	 	String th = "<thead><tr><th>#</th><th>만든이</th><th>프로젝트</th><th>프로젝트 기간</th><th>상태</th><th>온/오프</th></tr></thead>" ;
 	 	out = "<table class='table table-bordered table-hover'>" + th + "<tbody>" + out  + "</tbody></table>" ;
		
			
		return out ;
	}
}

class Task {
	int n_idx = -1;
	String v_desc ;
	String v_reg_datetime ;
	String v_edt_datetime ;
	String c_off_yn ;
	String v_parent_user ;
	// -- 
	int n_list = -1 ;
	int n_parent = -1 ;
	int n_owner_idx = -1 ;
	
	String c_status ;
	String c_del_yn ;
	
	UserSession sess ;
	
	public Task(DataSet ds, UserSession oUserSession) {
		this.n_idx = ds.getInt(1) ;
		this.v_desc = ds.getString(2) ;
		this.c_off_yn = ds.getString(3) ;
		this.v_reg_datetime = ds.getString(4) ;
		this.v_edt_datetime = ds.getString(5) ;
		this.n_list = ds.getInt(6) ;
		this.n_parent = ds.getInt(7) ;
		this.v_parent_user = ds.getString(8) ;
		this.n_owner_idx = ds.getInt(9) ;
		this.c_status = ds.getString(10) ;
		this.c_del_yn = ds.getString(11) ;
		
		this.sess = oUserSession ;
	}
	
	public boolean isOwner() {
		return (n_owner_idx == sess.getUserIdx()) ;
	}
	
	public boolean isOFF(){
		return "Y".equals(c_off_yn) ;
	}
	
	private boolean isTop() {
		return (n_list==n_idx) ;
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
	
	public String get() {
		// -- task_idx를 경로에 노출하지 않는 방법은? 서버에 전송하는 QueryString 전체를 암호화하는게 좋을 듯
		// -- request 할 때, 해당 값을 base64 등으로 인코딩해야 돼. RequestHelper 등에 해당 메쏘드를 탑재
		// -- getParam할 때, 해당 값을 디코딩해야 돼, RequestHelper 쪽에서 파람 받는 상단에 디코딩 옵션 넣어야 함.
		StringBuffer sbOut = new StringBuffer() ;
		String[] asParentUser = v_parent_user.split("-") ;
		String task_owner = null ;
		if(asParentUser != null && asParentUser.length ==2) {
			task_owner = asParentUser[1] ;
		}
		
		sbOut.append("<div style='float:left'>") 
				.append("<div style='float:left'>")
				.append( getProfileImage(n_owner_idx) )
				.append("</div>")
				.append("<div style='float:right;padding:0 0 0 10px'>")
					.append(task_owner).append("<i class='icon-cog'></i><sub>최상위태스크오너</sub>").append("<br />")
					.append("<a href='/jsp/feedback.jsp?tsk_idx=").append(n_idx)	// -- 파일함에서 다운로드
					.append("'>")
					.append( "<i class='icon-comment'></i>피드백에 <strong>프로젝트 개설요청</strong> 남기기" ).append("</a>")
					.append("<br /><a href='javascript:onViewCalendar(").append(n_idx)
					.append(");'><span class='label'>태스크</span> ").append( stringToHTMLString( v_desc ) )
				.append("</a> ").append(getStatus()).append("<br /><i>")
				.append( DateTime.convertDateFormat(v_reg_datetime) )
				.append("</i></div>")
			.append("</div><br style='clear:both' />") ;
		return sbOut.toString() ;
	}
}
%>