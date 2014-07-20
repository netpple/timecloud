<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%
	_globalTabNo = 1 ;

	DataSet ds = QueryHandler.executeQuery("SELECT_TASK_CHILD_LIST", ownerIdx) ;
	
	String listOff = "" ,tabOff = "<small class='label label-important'>OFF</small>" ; 
	String listOn = "", tabOn = "<small class='label label-warning'>ON</small>" ;
	if(ds != null) {
		int onCnt = 0 ,offCnt = 0 ;		// -- 진행 중, 종료
		int onMyCnt = 0, onOtherCnt = 0 ;	// -- 내가생성, 남이생성
		int offMyCnt = 0, offOtherCnt = 0 ;	// -- 내가생성, 남이생성
		
		Task task = null ;
 	 	while (ds.next()) {
 	 		task = new Task(ds,oUserSession) ;
 	 		if( task.isOFF() ) {
 	 			listOff += "<tr>"+task.get()+"</tr>" ;
 	 			offCnt ++ ;
 	 		}
 	 		else {
 	 			listOn += "<tr>" + task.get() +"</tr>" ;
 	 			onCnt ++  ;
 	 		}
		}
 	 	
 	 	String th = "<thead><tr><th>#</th><th>"+Html.Icon.USER+"</th><th>태스크</th><th>상태</th><th>온/오프</th></tr></thead>" ;
 	 	listOn  = "<table class='table table-bordered table-hover'>" + th + "<tbody>" + listOn  + "</tbody></table>" ;
 	 	listOff = "<table class='table table-bordered table-hover'>" + th + "<tbody>" + listOff + "</tbody></table>" ;
 	 	tabOn +=  Html.small(" "+onCnt+"건") ;
 	 	tabOff += Html.small(" "+offCnt+"건") ;
	}	else {
		listOn = "진행 중인 할당 태스크가 없습니다." ;
		listOff = "종료 된 할당 태스크가 없습니다." ;		
	}
	
	String rankTable = getTaskAssginRank(oUserSession) ;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Task Child List</title>
<%@ include file="./common/include/incHead.jspf" %>
<script type="text/javascript">
	// -- 도구 링크
	function onViewTaskHierarchy(taskidx) {
		location.href= '<%=CONTEXT_PATH%>/jsp/taskHierarchy.jsp?tsk_idx='+taskidx ;
	}
	
	function goToFeedback(taskidx) {
		location.href= '<%=CONTEXT_PATH%>/jsp/feedback.jsp?tsk_idx='+taskidx ;
	}
	
	function goToFileUpload(taskidx) {
		location.href= '<%=CONTEXT_PATH%>/jsp/common/fileupload/form.jsp?tsk_idx='+taskidx ;
	}
</script>
</head>
<body>
<div class='row-fluid'>
	<div class='span10'><%@ include file="./menuGlobal.jsp" %>
		<div class='row-fluid'>
			<div class='span2 vertNav'><%=getVertNav(req, oUserSession) %>
			</div>
			<div class='span10 all'>
				<h7>내가 할당한 태스크 (전체)</h7>
				<div align=right><%=rankTable %></div>
				<div>
					<ul class="nav nav-tabs">
						<li class=active><a href="#tab1" data-toggle="tab"><%=tabOn %></a></li>
						<li><a href="#tab2" data-toggle="tab"><%=tabOff %></a></li>
					</ul><br />
					<div class='tab-content'>
						<div class='tab-pane active' id='tab1'><%=listOn %></div>
						<div class='tab-pane' id='tab2'><%=listOff %></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%=getNotification(oUserSession, "span2 noti") %>
</div>
</body>
</html>
<%@ include file="./common/include/incFooter.jspf" %><%!

class Task {
	int n_idx = -1;
	String v_desc ;
	String v_reg_datetime ;
	String v_edt_datetime ;
	String c_off_yn ;
	String v_child_user ;
	String c_status ;
	// -- 
	int n_list = -1 ;
	int n_parent = -1 ;
	int n_owner_idx = -1 ;
	
	UserSession sess ;
	
	public Task(DataSet ds, UserSession sess) {
		this.n_idx = ds.getInt(1) ;
		this.v_desc = ds.getString(2) ;
		this.c_off_yn = ds.getString(3) ;
		this.v_reg_datetime = ds.getString(4) ;
		this.v_edt_datetime = ds.getString(5) ;
		this.n_list = ds.getInt(6) ;
		this.n_parent = ds.getInt(7) ;
		this.v_child_user = ds.getString(8) ;	 // -- 나한테 할당받은 사람
		this.c_status = ds.getString(9) ;
		
		this.sess = sess ;
	}
	
	public boolean isOFF(){
		return "Y".equals(c_off_yn) ;
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
		String out = null ;
		String desc = null, status = null ;
		desc = "<a href='javascript:onTaskHome("+n_idx+");'>"+stringToHTMLString( v_desc )+"</a>" ;
		if(!isOFF()) {
			status = "<span class='label label-warning'>ON</span>" ;
		}
		else {
			status = "<span class='label label-important'>OFF</span>" ;
		}
		
		String photo = null ;
		String[] asUser = v_child_user.split("-") ;
		if(asUser != null && asUser.length ==2) {
			photo = getProfileImage(Integer.parseInt(asUser[0]),20) ;
			desc += " <small class='badge'>To</small> "+Html.small(asUser[1]) ;
		}
		
		out = 	"<td>"+n_idx+"</td>"
				+ "<td>" +photo+"</td>"
				+ "<td>"+desc+" "+ Html.small(v_edt_datetime)+"</td>"
				/*
				+ "<td><a href='javascript:onTaskHome("+n_idx+");'>"+Html.Icon.TASK+"</a></td>"
				+ "<td><a href='javascript:onViewCalendar("+n_idx+");'>"+Html.Icon.ACTIVITY+"</i></a></td>"
				+ "<td><a href='javascript:goToFeedback("+n_idx+");'>"+Html.Icon.FEEDBACK+"</a></td>"
				+ "<td><a href='javascript:goToFileUpload("+n_idx+");'>"+Html.Icon.FILE+"</a></td>"
				*/
				+"<td>"+getStatus()+"</td>"
				//+"<td>"+DateTime.convertDateFormat(v_reg_datetime)+"</td>"
				+ "<td>"+status+"</td>"
				;
		
		return out ;
	}
}
%>