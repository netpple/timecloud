<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%
	_globalTabNo = 0 ;
	
	// -- 
	int[] taskType = new int[]{0,0,0} ;
	taskType[0] = req.getIntParam("pTaskType0",0) ;
	taskType[1] = req.getIntParam("pTaskType1",0) ;
	taskType[2] = req.getIntParam("pTaskType2",0) ;
	
	String searchKey = req.getParam("pSearchKey","");

	StringBuffer subQuery = new StringBuffer(" ");

	if("".equals(searchKey) == false) {
		subQuery.append(" AND V_DESC LIKE '%"+ searchKey + "%'");
	}
	
	String taskTypeCode = getTaskTypeCode(taskType) ;	

	DataSet ds = QueryHandler.executeQuery("SELECT_TASK_LIST3", new String[]{ ""+ownerIdx, taskTypeCode }, subQuery.toString()) ;
	
	String listOff = "" ,tabOff = "<small class='label label-important'>OFF</small>" ; 
	String listOn = "", tabOn = "<small class='label label-warning'>ON</small>" ;

	StringBuffer ctrlTaskType = new StringBuffer() ;
 	ctrlTaskType
 		.append("<input type='text' name='pSearchKey' class='input-small span5' placeholder='검색어' value='"+searchKey+"' /> ")
 		.append( getCombo(taskType[0], new String[]{"전체","업무","개인"}, "name='pTaskType0' class=span2") ) 
	 	.append( getCombo(taskType[1], new String[]{"전체","단기","장기"}, "name='pTaskType1' class=span2") )
	 	.append( getCombo(taskType[2], new String[]{"전체","한번","반복"}, "name='pTaskType2' class=span2") )
	 	.append( " <button type='submit' class='btn btn-primary'>검색</button>") ;		

	if(ds != null) {
		int onCnt = 0 ,offCnt = 0 ;		// -- 진행 중, 종료
		int onMyCnt = 0, onOtherCnt = 0 ;	// -- 내가생성, 남이생성
		int offMyCnt = 0, offOtherCnt = 0 ;	// -- 내가생성, 남이생성
		int onHideCnt = 0, offHideCnt = 0; // -- 숨긴태스크 Cnt
		
		Task task = null ;
 	 	while (ds.next()) {
 	 		task = new Task(ds,oUserSession) ;
 	 		if(task.isOFF()){
 	 			offCnt ++ ;
	 	 		if( task.isOwnerTask(ownerIdx) )offMyCnt ++ ;
	 	 		else offOtherCnt ++ ; 	
 	 			if(task.isHide()){
 	 				offHideCnt++;
 	 	 		}else{
 	 				listOff += "<tr>"+task.get()+"</tr>" ;
 	 	 		}
 	 		}
 	 		else {
 	 			onCnt ++  ;
	 	 		if( task.isOwnerTask(ownerIdx) )onMyCnt ++ ;
	 	 		else onOtherCnt ++ ;
 	 			if(task.isHide()){
 	 				onHideCnt++;
 	 	 		}else{
	 				listOn += "<tr>" + task.get() +"</tr>" ;
 	 	 		}
 	 		}
		}
 	 	 	 	
 	 	String th = "<thead><tr><th>#</th><th>"+Html.Icon.USER+"</th><th>태스크</th><th>구분</th><th>상태</th><th>종료</th></tr></thead>" ;
 	 	listOn  = "<table class='table table-bordered table-hover'>" + th + "<tbody>" + listOn  + "</tbody></table>" ;
 	 	listOff = "<table class='table table-bordered table-hover'>" + th + "<tbody>" + listOff + "</tbody></table>" ;
 	 	tabOn +=  Html.small("전체 "+onCnt+"건, 자체  "+onMyCnt+"건 , 할당  "+onOtherCnt+"건" ) ;
 	 	tabOff += Html.small("전체 "+offCnt+"건, 자체  "+offMyCnt+"건 , 할당  "+offOtherCnt+"건") ;
	}
	else {
		listOn = "진행 중인 태스크가 없습니다." ;
		listOff = "종료 된 태스크가 없습니다." ;		
	}
	
	String rankTable = getTaskRank(oUserSession) ;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Task List</title>
<%@ include file="./common/include/incHead.jspf" %>
<script type="text/javascript">
	function onViewProfile() {
		var url = '<%=CONTEXT_PATH%>/jsp/userInfo.jsp?user_idx=<%=oUserSession.getUserIdx()%>';
		var pop = window.open(url,'myProfile') ;
		pop.focus() ;
	}
	
	function onTaskReOpen(taskIdx) {
		if(confirm("태스크를 활성화합니다.\n계속하시겠습니까?")){
			location.replace("<%=CONTEXT_PATH%>/jsp/taskReOpenAction.jsp?tsk_idx="+taskIdx) ;
		}
		else return ;
	}
	
	function onTaskClose(taskIdx) { // -- task termination
		if(confirm("태스크 종료를 진행합니다.\n계속하시겠습니까?")){
			location.replace("<%=CONTEXT_PATH%>/jsp/taskCloseAction.jsp?tsk_idx="+taskIdx) ;
		}
		else return ;
	}
	
	function updateTaskStatus(taskIdx,taskStatus) {
		location.href= '<%=CONTEXT_PATH%>/jsp/taskStatusAction.jsp?tsk_idx='+taskIdx+'&pTaskStatus='+taskStatus;
		return ;
	}
	
	// -- 도구 링크
	function onViewTaskHierarchy(taskidx) {
		location.href= '<%=CONTEXT_PATH%>/jsp/taskHierarchy.jsp?tsk_idx='+taskidx;
	}
	
	function goToFeedback(taskidx) {
		location.href= '<%=CONTEXT_PATH%>/jsp/feedback.jsp?tsk_idx='+taskidx;
	}
	
	function goToFileUpload(taskidx) {
		location.href= '<%=CONTEXT_PATH%>/jsp/file.jsp?tsk_idx='+taskidx;
	}	

	// -- TODO - Task Type - ajax request
	function toggleTypePrivate(taskidx){
		return toggleType(taskidx,<%=Task.TASK_TYPE_POS_PRIVATE%>) ;
	}
	function toggleTypeTerm(taskidx){
		return toggleType(taskidx,<%=Task.TASK_TYPE_POS_TERM%>) ;
	}
	function toggleTypeRepeated(taskidx){
		return toggleType(taskidx,<%=Task.TASK_TYPE_POS_REPEATED%>) ;
	}
	function toggleType(taskidx, typepos){
		var f = document.getElementById("f2") ;
		f.tsk_idx.value = taskidx;
		f.pTaskTypePos.value = typepos ;

		$.ajax({
			type: 'post', 
			async: true, 
			url: "taskTypeAction.jsp", 
			data: $("#f2").serialize() , 
			beforeSend: function() {
				// -- TODO - SET PROGRESSBAR
			}, 
			success: function(data) {
				if(data > 0) {	// -- TODO - 방금 등록한 액티비티 시퀀스를 받아서 저장해야 함
					f.tsk_idx.value = "";
					f.pTaskTypePos.value = "" ;
				} else {
					alert('처리 실패'+data);
					// -- TODO - 토글버튼을 돌려놔야 하는데..스크립트로 처리할 방법은 뭐지?
				}
			}, 
			error: function(data, status, err) {
				// -- TODO - 토글버튼을 돌려놔야 하는데..스크립트로 처리할 방법은 뭐지?
				alert("error occurred ..");
			}, 
			complete: function() { 
				// -- TODO - UNSET PROGRESSBAR
			}
		});
	}
	// --
</script>
<script type="text/javascript">
	var isSubmit = false ;
	function onSubmit(f) {
		if(isSubmit) {
			alert('처리 중입니다.') ;
			return ;
		}
		
		if(f.pTaskDesc.value == ""){
			alert('태스크 내용을 입력해 주세요') ;
			f.pTaskDesc.focus() ;
			return ;
		}
		
		isSubmit = true ;
		f.submit() ;
	}
	
	function onSearch() {
		var form = document.forms[0];
		form.action = "taskList.jsp";
		form.submit();
	}
</script>
</head>
<body>
<%--
	<form id='f1' method='post' action='taskAction.jsp' class="form-inline" onSubmit="onSubmit(this); return false;">
		<input type="text" id="taskRegister" name="pTaskDesc" class="input-xxlarge" placeholder="태스크를 적어주세요 .." autofocus onKeyup="if (event.keyCode == 13) onSubmit(document.forms[0]);"/> <button type="submit" class='btn btn-primary'>등록</button>
	</form>	
 --%>	
<div class='row-fluid'>
	<div class='span10'><%@ include file="./menuGlobal.jsp" %>
		<div class='row-fluid'>
			<div class='span2 vertNav'><%=getVertNav(req, oUserSession) %>
			</div>
			<div class='span10 all'>
				<h7>내가 수행할 태스크 (전체)</h7>
				<div class='row-fluid'>
					<div class='span6'><form class='form-inline'><%=ctrlTaskType.toString() %></form></div>
					<div class='span6'><div align=right><%=rankTable %></div></div>
				</div>
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
<form id='f2' method='post'>
	<input type='hidden' name='tsk_idx' value=''/>
	<input type='hidden' name='pTaskTypePos' value=''/>
</form>
</body>
</html>
<%@ include file="./common/include/incFooter.jspf" %><%!
	public static String getTaskTypeCode(int[] taskType) {
	
		StringBuffer typeCode = new StringBuffer() ;
		String type = "" ;
		for(int i=0;i<taskType.length;i++) {
			if(taskType[i] == 1) type = "0" ;
			else if(taskType[i] == 2) type ="1" ;
			else  type = "%" ;
			typeCode.append(type) ;
		}
		typeCode.append("0000000") ;	 // -- 나머지 7자리
		
		return typeCode.toString() ;
	}
	// -- example : String termDropdown = getDropDown(1, new String[]{"전체","단기","장기"}, "selectTerm") ;
	public static String getDropdown(final int SELECTED,
			final String[] caption, final String scriptName) {
		StringBuffer dropdown = new StringBuffer();
		dropdown.append("<div class='btn-group'>")
				.append("<button class='btn btn-mini'>")
				.append(caption[SELECTED])
				.append("</button>")
				.append("<button class='btn btn-mini dropdown-toggle' data-toggle='dropdown'>")
				.append("<span class='caret'></span>").append("</button>")
				.append("<ul class='dropdown-menu'>");
		for (int i = 0; i < caption.length; i++) {
			if (i != SELECTED)
				dropdown.append("<li><a href=\"javascript:").append(scriptName)
						.append("(").append(i).append(");\">")
						.append(caption[i]).append("</a></li>");
		}
		dropdown.append("</ul>").append("</div>");

		return dropdown.toString();
	}

	// -- example : String termCombo = getCombo(1, new String[]{"전체","단기","장기"}, "name='comboTerm' class='combo' onChange='javascript:changeTerm();'") ;
	public static String getCombo(final int SELECTED, final String[] caption,
			final String script) { // -- 선택된 위치, 콤보 옵션레이블들, 콤보에 시작노드에 추가할 어트리뷰트 스트링
		StringBuffer combo = new StringBuffer();
		combo.append("<select ").append(script).append(">");
		for (int i = 0; i < caption.length; i++) {
			combo.append("<option value='").append(i).append("' ");
			if (i == SELECTED)
				combo.append("selected");
			combo.append(">").append(caption[i]).append("</option>");
		}
		combo.append("</select>");
		return combo.toString();
	}

	// -- 
	class Task {
		int n_idx = -1;
		String v_desc;
		String v_reg_datetime;
		String v_edt_datetime;
		String c_off_yn;
		String v_parent_user;
		String c_status;
		String c_hide_yn;
		// -- 
		int n_list = -1;
		int n_parent = -1;
		// -- 
		String c_task_type; // -- size - 10byte, [업무|개인][단기|장기]|[한번|반복][][][][][][][]

		UserSession sess;

		public Task(DataSet ds, UserSession sess) {
			this.n_idx = ds.getInt(1);
			this.v_desc = ds.getString(2);
			this.c_off_yn = ds.getString(3);
			this.v_reg_datetime = ds.getString(4);
			this.v_edt_datetime = ds.getString(5);
			this.n_list = ds.getInt(6);
			this.n_parent = ds.getInt(7);
			this.v_parent_user = ds.getString(8);
			this.c_status = ds.getString(9); // -- 태스크 상태(CHAR(2)) : 00 - 정상, 01 - 지연, 02 - 이슈, 03 - 중단, 04 - 실패, 05 - 성공
			this.c_task_type = ds.getString(10);
			this.c_hide_yn = ds.getString(11);
			try {
				parseTaskTypeCode();
			} catch (Exception e) {
				e.printStackTrace();
			}

			this.sess = sess;
		}
		
		public boolean isHide() {
			return "Y".equals(c_hide_yn);
		}

		public boolean isOFF() {
			return "Y".equals(c_off_yn);
		}

		public boolean isOwnerTask(int ownerIdx) {
			return v_parent_user.substring(0,1).equals(String.valueOf(ownerIdx));
		}
		
		public boolean isTop() {
			return (n_list == n_idx);
		}

		private String getStatus() {
			String status = "";
			if ("01".equals(c_status)) {
				status = "<span class='badge badge-warning'>지연</span>";
			} else if ("02".equals(c_status)) {
				status = "<span class='badge badge-warning'>이슈</span>";
			} else if ("03".equals(c_status)) {
				status = "<span class='badge badge-important'>중단</span>"; // -- 혹은 보류?
			} else if ("04".equals(c_status)) {
				status = "<span class='badge badge-important'>실패</span>";
			} else if ("05".equals(c_status)) {
				status = "<span class='badge badge-success'>성공</span>";
			} else {
				status = "<span class='badge badge-success'>정상</span>";
			}

			return status;
		}

		private String getStatusControl() {

			// -- toggle button style
			String statusControl = getStatusDropdown(); // -- getStatusToggle() ;

			return statusControl;
		}

		private String getStatusDropdown() {
			StringBuffer dropdown = new StringBuffer();
			String active = "정상";
			String statusStyle = "success";
			if ("01".equals(c_status)) {
				active = "지연";
				statusStyle = "warning";
			} else if ("02".equals(c_status)) {
				active = "이슈";
				statusStyle = "warning";
			} else if ("03".equals(c_status)) {
				active = "중단";
				statusStyle = "danger";
			} else if ("04".equals(c_status)) {
				active = "실패";
				statusStyle = "danger";
			} else if ("05".equals(c_status)) {
				active = "성공";
				statusStyle = "success";
			} else {
			}

			dropdown.append("<div class='btn-group'>")

					.append("<button class='btn btn-mini btn-")
					.append(statusStyle)
					.append("'>")
					.append(active)
					.append("</button>")
					.append("<button class='btn btn-mini dropdown-toggle' data-toggle='dropdown'>")
					.append("<span class='caret'></span>").append("</button>")
					.append("<ul class='dropdown-menu'>");

			if (!"00".equals(c_status))
				dropdown.append("<li><a href=\"javascript:updateTaskStatus("
						+ n_idx + ",'00');\">정상</a></li>");
			if (!"01".equals(c_status))
				dropdown.append("<li><a href=\"javascript:updateTaskStatus("
						+ n_idx + ",'01');\">지연</a></li>");
			if (!"02".equals(c_status))
				dropdown.append("<li><a href=\"javascript:updateTaskStatus("
						+ n_idx + ",'02');\">이슈</a></li>");
			if (!"03".equals(c_status))
				dropdown.append("<li><a href=\"javascript:updateTaskStatus("
						+ n_idx + ",'03');\">중단</a></li>");
			if (!"04".equals(c_status))
				dropdown.append("<li><a href=\"javascript:updateTaskStatus("
						+ n_idx + ",'04');\">실패</a></li>");
			if (!"05".equals(c_status))
				dropdown.append("<li><a href=\"javascript:updateTaskStatus("
						+ n_idx + ",'05');\">성공</a></li>");

			dropdown.append("</ul>").append("</div>");

			return String.format(dropdown.toString());
		}

		private String getStatusToggle() {
			String[] active = new String[] { "", "", "", "", "", "" };
			if ("01".equals(c_status)) {
				active[1] = "active";
			} else if ("02".equals(c_status)) {
				active[2] = "active";
			} else if ("03".equals(c_status)) {
				active[3] = "active";
			} else if ("04".equals(c_status)) {
				active[4] = "active";
			} else if ("05".equals(c_status)) {
				active[5] = "active";
			} else {
				active[0] = "active";
			}

			// -- toggle button style
			String toggle = "<div class='btn-group'>"
					+ "<button type='button' class='btn btn-mini "
					+ active[0]
					+ "' onclick=\"javascript:updateTaskStatus("
					+ n_idx
					+ ",'00');\">정상</button>"
					+ "<button type='button' class='btn btn-mini "
					+ active[1]
					+ "' onclick=\"javascript:updateTaskStatus("
					+ n_idx
					+ ",'01');\">지연</button>"
					+ "<button type='button' class='btn btn-mini "
					+ active[2]
					+ "' onclick=\"javascript:updateTaskStatus("
					+ n_idx
					+ ",'02');\">이슈</button>"
					+ "<button type='button' class='btn btn-mini "
					+ active[3]
					+ "' onclick=\"javascript:updateTaskStatus("
					+ n_idx
					+ ",'03');\">중단</button>"
					+ "<button type='button' class='btn btn-mini "
					+ active[4]
					+ "' onclick=\"javascript:updateTaskStatus("
					+ n_idx
					+ ",'04');\">실패</button>"
					+ "<button type='button' class='btn btn-mini "
					+ active[5]
					+ "' onclick=\"javascript:updateTaskStatus("
					+ n_idx
					+ ",'05');\">성공</button>" + "</div><div>";
			return toggle;
		}

		public String get() {
			// -- task_idx를 경로에 노출하지 않는 방법은? 서버에 전송하는 QueryString 전체를 암호화하는게 좋을 듯
			// -- request 할 때, 해당 값을 base64 등으로 인코딩해야 돼. RequestHelper 등에 해당 메쏘드를 탑재
			// -- getParam할 때, 해당 값을 디코딩해야 돼, RequestHelper 쪽에서 파람 받는 상단에 디코딩 옵션 넣어야 함.
			String out = null;
			String desc = null, status = null;
			String calLink = null;
			String taskStatus = null;
			if (!isOFF()) {
				desc = "<a href='javascript:onTaskHome(" + n_idx + ");'>"
						+ stringToHTMLString(v_desc) + "</a>";
				status = "<input type='button' class='btn btn-mini btn-danger' value='Off' onClick='javascript:onTaskClose("
						+ n_idx + ")' />";
				;
				calLink = "<a href='javascript:onViewCalendar(" + n_idx
						+ ");'><i class='icon-calendar'></i></a>";
				taskStatus = getStatusControl();
			} else {
				desc = "<a href='javascript:onTaskHome(" + n_idx + ");'>"
						+ stringToHTMLString(v_desc) + "</a>";
				status = "<input type='button' class='btn btn-mini btn-warning' value='On' onClick='javascript:onTaskReOpen("
						+ n_idx + ")' />";
				calLink = "<a href='javascript:onViewCalendar(" + n_idx
						+ ");'><i class='icon-calendar'></i></a>";
				taskStatus = getStatus();
			}

			String photo = null;
			String[] asUser = v_parent_user.split("-");
			if (!isTop() && asUser != null && asUser.length == 2) {
				photo = getProfileImage(sess.getDomainIdx(),Integer.parseInt(asUser[0]),20);
				
				if(sess.getUserIdx() != Integer.parseInt(asUser[0])) {
					desc += " <small class='badge badge-info'>from</small> "
							+ asUser[1] ;
				}
			} else {
				photo = getProfileImage(sess.getDomainIdx(), sess.getUserIdx(),20);
			}

			out = "<td>" + n_idx + "</td>" + "<td>" + photo + "</td>" 
					+ "<td>"+ desc + " "+ Html.small(v_edt_datetime)+"</td>" 
					+ "<td><div class='btn-toolbar'>"+ getTypePrivateToggle() + getTypeTermToggle()+ getTypeRepeatToggle() + "</div></td>"
/*					
					+ "<td><a href='javascript:onTaskHome("+ n_idx + ");'>"+Html.Icon.TASK+"</a></td>"
					+ "<td>" + calLink+ "</td>" 
					+ "<td><a href='javascript:goToFeedback(" + n_idx+ ");'>"+Html.Icon.FEEDBACK+"</a></td>"
					+ "<td><a href='javascript:goToFileUpload(" + n_idx+ ");'>"+Html.Icon.FILE+"</a></td>"
*/					
					+ "<td>"+ taskStatus + "</td>"
					+ "<td>" + status + "</td>";
					
			return out;
		}

		/* -- 태스크 구분 구현 -- */
		// -- 상수
		private final String TASK_TYPE_DEFAULT = "0000000000";

		public static final int TASK_TYPE_SIZE = 10;
		public static final int TASK_TYPE_POS_PRIVATE = 0;
		public static final int TASK_TYPE_POS_TERM = 1;
		public static final int TASK_TYPE_POS_REPEATED = 2;

		private final String TASK_TYPE_VALUE_PRIVATE = "1"; // -- Default : JOB
		private final String TASK_TYPE_VALUE_TERM_LONG = "1"; // -- Default : SHORT
		private final String TASK_TYPE_VALUE_REPEATED = "1"; // -- Default : EVENT(not repeated)

		// -- member field
		private boolean is_private = false;
		private boolean is_term_long = false;
		private boolean is_repeated = false;

		private void setTypePrivate(String code) {
			is_private = TASK_TYPE_VALUE_PRIVATE.equals(code);
		}

		private void setTypeTerm(String code) {
			is_term_long = TASK_TYPE_VALUE_TERM_LONG.equals(code);
		}

		private void setTypeRepeated(String code) {
			is_repeated = TASK_TYPE_VALUE_REPEATED.equals(code);
		}

		// -- Check type
		private boolean isPrivate() {
			return is_private;
		}

		private boolean isLong() {
			return is_term_long;
		}

		private boolean isRepeated() {
			return is_repeated;
		}

		// -- Parse type codes
		private void parseTaskTypeCode() throws Exception {
			// -- validation - 1.size
			if (c_task_type == null) {
				throw new Exception("c_task_type is invalid - null");
			}
			int len = c_task_type.length();
			if (len != TASK_TYPE_SIZE) {
				throw new Exception("c_task_type is invalid. Please check size");
			}

			setTypePrivate(c_task_type.substring(TASK_TYPE_POS_PRIVATE,
					TASK_TYPE_POS_PRIVATE + 1));
			setTypeTerm(c_task_type.substring(TASK_TYPE_POS_TERM,
					TASK_TYPE_POS_TERM + 1));
			setTypeRepeated(c_task_type.substring(TASK_TYPE_POS_REPEATED,
					TASK_TYPE_POS_REPEATED + 1));
			/* The last slots from 3 to 9 are for extension.*/
		}

		// -- Controls - toggle
		private String getTypePrivateToggle() { // -- 개인|업무
			String[] active = new String[] { "", "" };
			if (isPrivate()) {
				active[1] = "active";
			} else {
				active[0] = "active";
			}

			String toggle = "<div class='btn-group' data-toggle='buttons-radio'><button type='button' class='btn btn-mini %s' onclick=\"javascript:toggleTypePrivate('%s');\">업무</button><button type='button' class='btn btn-mini %s' onclick=\"javascript:toggleTypePrivate('%s');\">개인</button></div>";
			return String.format(toggle, active[0], n_idx, active[1], n_idx);
		}

		private String getTypeTermToggle() { // -- 기간여부
			String[] active = new String[] { "", "" };
			if (isLong()) {
				active[1] = "active";
			} else {
				active[0] = "active";
			}

			String toggle = "<div class='btn-group' data-toggle='buttons-radio'><button type='button' class='btn btn-mini %s' onclick=\"javascript:toggleTypeTerm('%s');\">단기</button><button type='button' class='btn btn-mini %s' onclick=\"javascript:toggleTypeTerm('%s');\">장기</button></div>";
			return String.format(toggle, active[0], n_idx, active[1], n_idx);
		}

		private String getTypeRepeatToggle() { // -- 반복여부
			String[] active = new String[] { "", "" };
			if (isRepeated()) {
				active[1] = "active";
			} else {
				active[0] = "active";
			}

			String toggle = "<div class='btn-group' data-toggle='buttons-radio'><button type='button' class='btn btn-mini %s' onclick=\"javascript:toggleTypeRepeated('%s');\">한번</button><button type='button' class='btn btn-mini %s' onclick=\"javascript:toggleTypeRepeated('%s');\">반복</button></div>";
			return String.format(toggle, active[0], n_idx, active[1], n_idx);
		}
		/**/
	}%>