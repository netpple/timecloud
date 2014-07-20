<%@page import="com.sun.org.apache.bcel.internal.generic.SASTORE"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%
	if(TASK_IDX <= 0 ) { 
		out.println("Parameter is invalid") ;
		return ;
	}
	int iOwnerIdx = -1 ; // -- req.getIntParam("task_owner", ownerIdx) ;
	
	// -- 태스크 정보 출력
	DataSet ds = null ;
	ds = QueryHandler.executeQuery("SELECT_TASK_INFO",TASK_IDX ) ; // -- ,""+iTaskList,""+iTaskParent}) ;
	int cnt = -1 ;
	if(ds == null || (cnt = ds.size())<=0) {
		out.println("Task is not exist") ;
		return ;
	}
	
	String taskInfo = "" ;
	Task task = null ;
	Task currentTask = null ;	// -- 현재 태스크
	
	int i = 1 ;
	while (ds.next()) {
		task = new Task(ds, oUserSession) ;
		if(i==cnt) {	// -- 현재 태스크를 가장 아래에 배치함
			currentTask = task ;
			taskInfo += "<h3>"+currentTask.get()+"</h3>" ;
			iOwnerIdx = currentTask.getOwnerIdx() ;
		}
		else taskInfo += "<p>"+task.get()+"</p>" ;
		i++ ;
	}
	
	ds = null ;
	
	// -- 해당 태스크 참조자 출력
	ds = QueryHandler.executeQuery("SELECT_OBSERVER_LIST2", currentTask.getIdx()) ;
	StringBuffer _observerImages = new StringBuffer() ;	// -- TODO - include된 파일에서 사용될 변수명은 _를 붙이면 어떨까? (현재 파일 외에 다른 파일 영역에서도 사용됨을 의미)
	if(ds != null && ds.size()>0) {
		while(ds.next()){
			_observerImages.append(" " + getProfileImage(ds.getInt(1), 30 ) );
		}
	}
	else _observerImages.append("없음") ;
	
	ds = null ;
	
	// -- 달력에 액티비티 출력
	ds = QueryHandler.executeQuery("SELECT_TASK_ALL_ACTIVITY_LIST", TASK_IDX );
	String sLastEndDateTime = "";
	String events = "" ;
	if(ds != null) {
		Activity activity = null ;
		
		long lastEndDateTime = 0;
		
		while (ds.next()) {
			activity = new Activity(ds, TASK_IDX) ;
			
			if(lastEndDateTime < activity.getEndDateTime()) {
				lastEndDateTime = activity.getEndDateTime();
			}
			
			events += activity.get() ; 
		}
		
		// 이후에 DB에서 한번에 조회하는것도 괜찮을듯..
		sLastEndDateTime = Long.toString(lastEndDateTime);
		sLastEndDateTime = sLastEndDateTime.substring(0,4) + "," + (Integer.parseInt(sLastEndDateTime.substring(4,6)) - 1) + "," + sLastEndDateTime.substring(6,8);
		
		ds = null ;
	}
	
	final boolean IS_TASK_OWNER = ( currentTask.getOwnerIdx() == oUserSession.getUserIdx() ) ;
	final boolean IS_TASK_ON = ( !currentTask.isOff() && !currentTask.isDel() ) ;
	
%><html lang="en">
<head>
<title>태스크 일정</title>
<%@ include file="./common/include/incHead.jspf" %>
<%@ include file="taskHierarchyInfo.jsp" %>
<link href="<%=CSS_PATH%>/fullcalendar.css" rel="stylesheet">
<link href="<%=CSS_PATH%>/fullcalendar.print.css" rel="stylesheet" media="print">
<script src="<%=JS_PATH%>/fullcalendar.js"></script>

<script type="text/javascript">
	var calendar;
	
	$(document).ready(function() {
		var wrapHeight = $(document).height();
		var date = new Date();
		var d = date.getDate();
		var m = date.getMonth();
		var y = date.getFullYear();
		
		calendar = $('#calendar').fullCalendar({
			header: {
				left: 'prev,next today',
				center: 'title',
				right: 'month,agendaWeek,agendaDay'
			},			
			editable: false,
			events: [ <%=events%> ]
		});
		
		var _date = new Date(<%=sLastEndDateTime%>);
		$('#calendar').fullCalendar('gotoDate', _date);
		
	});
</script>
</head>
<body>
	<div class="row-fluid">
		<div class=span9><%@ include file="./menuGlobal.jsp" %>
			<div class="row-fluid">
				<div class='span4' id="hierarchy" style="height:100%;"></div>
				<div class='span8'><%@ include file="./menuTool.jsp" %>
					<div id="calendar"></div>
				</div>
			</div>
		</div>
		<%=getNotification(oUserSession, "span3 noti") %>
	</div>
</body>
</html>
<%@ include file="./common/include/incFooter.jspf" %>
<%!
class Task {
	int n_idx = -1;
	int n_level = -1;
	String v_desc ;
	String v_parent_user ;
	String v_task_owner ;	
	int n_owner_idx = -1 ;
	String c_status ;
	String c_off_yn;
	String c_del_yn;
	
	UserSession sess ;
	
	public Task(DataSet ds, UserSession oUserSession) {
		this.n_idx = ds.getInt(1) ;
		this.n_level = ds.getInt(2) ;
		this.v_desc = ds.getString(3) ;
		this.v_parent_user = ds.getString(4) ;
		this.v_task_owner = ds.getString(5) ;
		this.n_owner_idx = ds.getInt(6) ;
		this.c_status = ds.getString(7) ;
		this.c_off_yn = ds.getString(8) ;
		this.c_del_yn = ds.getString(9) ;
		
		this.sess = oUserSession ;
	}
	
	public boolean isOff() {
		return "Y".equals(c_off_yn) ;
	}
	
	public boolean isDel() {
		return "Y".equals(c_off_yn) ;
	}
	
	public int getIdx() {
		return n_idx ;
	}
	
	public int getOwnerIdx() {
		return n_owner_idx ;
	}	
	
	public String get() {
		StringBuffer path = new StringBuffer() ;
		String[] asParentUser = v_parent_user.split("-") ;
		if(asParentUser != null && asParentUser.length ==2) {
			int n_parent_idx = Integer.parseInt(asParentUser[0]) ;
			if(n_owner_idx !=n_parent_idx) {
				path.append(getProfileImage(n_parent_idx, 30)) ;
				path.append("<i class='icon-hand-right'></i>") ;
			}
		}
		path.append( getProfileImage(n_owner_idx, 30) ) ;
		
		String outFormat = "%s %s %s" ;
		return String.format(
				outFormat
				, path
				,v_desc,getStatus()) ;
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
}

class Activity {
	int currentTaskIdx = -1 ;
	String n_idx ;
	String v_desc ;
	String v_start_datetime ;
	String v_end_datetime ;
	int n_start_gap ;
	int n_end_gap ;
	int n_task_idx = -1 ;
	
	public Activity(DataSet ds, int taskIdx) {
		this.currentTaskIdx = taskIdx ;
		
		this.n_idx = ds.getString(1) ;
		this.v_desc = ds.getString(2) ;
		this.v_start_datetime = ds.getString(3) ;
		this.v_end_datetime = ds.getString(4) ;
		
		this.n_start_gap = ds.getInt(5) ;
		this.n_end_gap = ds.getInt(6) ;
		
		this.n_task_idx = ds.getInt(7) ;
	}
	
	public long getEndDateTime() {
		return Long.parseLong(v_end_datetime.substring(0,8));
	}
	
	public String get() {
		String start_gap = "" ; 
		if(n_start_gap != 0)start_gap = ((n_start_gap>0)?"+":"") + n_start_gap ;
		
		String end_gap = "" ; 
		if(n_end_gap != 0) end_gap = ((n_end_gap>0)?"+":"") + n_end_gap ;
		
		// -- 시간처리
		String start_time = v_start_datetime.substring(8) ;
		String end_time = v_end_datetime.substring(8) ;
		
		//System.out.println("start at "+start_time) ;
		//System.out.println("end at "+end_time) ;

		StringBuffer start = new StringBuffer() ;
		StringBuffer end = new StringBuffer() ;

		boolean allday = true ;
		start.append(",start:new Date(y,m,d"+start_gap) ;
		String start_hr=null, start_min=null ;
		if( !"000000".equals(start_time) ) {
			start_hr = start_time.substring(0,2) ;
			start_min = start_time.substring(2,4) ;
			start.append(","+start_hr+","+start_min) ;
			allday = false ;
		}
		start.append(")") ;	// -- TODO - 시간정보 포함요. y,m,d,H,i
		
		
		end.append(",end:new Date(y,m,d"+end_gap) ;
		String end_hr=null, end_min=null ;
		if(!"000000".equals(end_time)) {
			end_hr = end_time.substring(0,2) ;
			end_min = end_time.substring(2,4) ;	
			end.append("," +end_hr+","+end_min) ;
			allday = false ;
		}
		end.append(")") ;

		String actDesc = v_desc.replaceAll("\r\n"," ").replaceAll("\n\r"," ").replace("\\", "\\\\").replace("'", "\\'") ;	// -- 줄바꿈이 있으면 캘린더 출력 못함 // 130806 ' , \ 있을시 달력 안나오는 문제 해결
		
		String sAllDay = (!allday)?",allDay:false":"" ;
		
		String result = "{idx:"+ n_idx +
		",title:'"+ actDesc  +"'" ;	// -- TODO - 특수문자 처리필요. 특히,single quotation
		// -- ",start:new Date(y,m,d"+start_gap+")"+
		// -- ",end:new Date(y,m,d"+end_gap+")"+
		
	 	// -- 현재 태스크의 액티비티 이면 태스크 컬러를 적용한다. 
		if(n_task_idx == currentTaskIdx) {
			result += ",backgroundColor:'#ffff00'" ;
			// -- result += ",textColor:'#999999'" ;
		}
		
		result += start.toString()+ end.toString()+ sAllDay + "}," ;
		
		return result ;		
	}
}

// -- for user combo
class UserCombo {
	String n_idx ;
	String v_email ;
	String v_name ;
	
	public UserCombo (DataSet ds) {
		this.n_idx = ds.getString(1) ;
		this.v_email = ds.getString(2) ;
		this.v_name = ds.getString(3) ;
	}

	public String get() {
		// -- task_idx를 경로에 노출하지 않는 방법은?
		return "<option value='"+n_idx+"'>"+v_name+"("+v_email+")</option>" ;
	}
}
%>