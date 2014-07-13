<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%
	//_globalTabNo = 2 ;
	// -- 달력에 액티비티 출력
	DataSet oAllActivityDataSet = QueryHandler.executeQuery("SELECT_ALL_ACTIVITY_LIST", oUserSession.getUserIdx()) ;
	
	String events = "" ;
	if(oAllActivityDataSet != null) {
		Activity activity = null ;
		
		while (oAllActivityDataSet.next()) {
			activity = new Activity(oAllActivityDataSet) ;
			events += activity.get() ; 
		}
		
		oAllActivityDataSet = null ;
	}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Communication / Activity Tools</title>
<%@ include file="./common/include/incHead.jspf" %>
<link href="<%=CSS_PATH%>/fullcalendar.css" rel="stylesheet">
<link href="<%=CSS_PATH%>/fullcalendar.print.css" rel="stylesheet" media="print">
<script src="<%=JS_PATH%>/fullcalendar.js"></script>
<script type="text/javascript">
	var registerLayer;
	var calendar;
	
	$(document).ready(function() {
		registerLayer = $("#register");
		registerLayer.hide();
		
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
			eventMouseover : function (calEvent, jsEvent, view) {
				$(this).css('border-color', 'orange');
			},
			eventMouseout : function (calEvent, jsEvent, view) {
				$(this).css('border-color', 'silver');
			},
			eventClick : function(calEvent, jsEvent, view){
				onTaskHomeActivityPop( calEvent.task_idx, calEvent.idx) ;
			},
			eventDragStart : function(calEvent, jsEvent, ui, view){},
			eventDragStop : function(calEvent, jsEvent, ui, view){},
			eventDrop : function (calEvent, dayDelta, minuteDelta, allDay, revertFunc, jsEvent, ui, view){
				onChange(calEvent,revertFunc) ;
			},
			eventResizeStart:function( calEvent, jsEvent, ui, view ) {},
			eventResizeStop:function( calEvent, jsEvent, ui, view ) {},
			eventResize:function( calEvent, dayDelta, minuteDelta, revertFunc, jsEvent, ui, view ) {
				onChange(calEvent,revertFunc) ;
			},
			selectable: true,
			selectHelper: true,
			select: function(start, end, allDay) {
			},
			
			editable: true,
			events: [ <%=events%> ]
		});
	});
	
	function onChange(calEvent,revertFunc) {
		if(!confirm("Are you sure about this change?")){
			revertFunc() ;
		}
		else {
			var frm = document.getElementById("frmActivityMove") ;
			// 최초 액티비티를 Week인 상태에서 생성 후 Allday-> 시간축으로 끌어다 놓으면 idx에 공백이 붙는 현상이 있음. -- 2013.01.18
			frm.pIdx.value = calEvent.idx;
			
			frm.pStartDate.value = convertDate(calEvent.start);
			frm.pStartTime.value = convertTime(calEvent.start);
			if(!calEvent.end) {
				frm.pEndDate.value = frm.pStartDate.value ;
				frm.pEndTime.value = frm.pStartTime.value ;
			}
			else {
				frm.pEndDate.value = convertDate(calEvent.end);
				frm.pEndTime.value = convertTime(calEvent.end);
			}
			$.ajax({
				type: 'post', 
				async: true, 
				url: 'calendarAction2.jsp', 
				data: $("#frmActivityMove").serialize() , 
				beforeSend: function() {
				}, 
				success: function(data) {
					if(data > 0) {
					} else {
						alert('액티비티 등록 실패');
						revertFunc() ;
					}
				}, 
				error: function(data, status, err) {	// -- 결과 수신에 실패한 경우
					alert("Fail to update:"+err);
					revertFunc() ;
				}, complete: function() {}
			});
		}
		
	}
	
	function convertDate(d) {
		var s =
			padZero(d.getFullYear(), 4) + '-' +
			padZero(d.getMonth() + 1, 2) + '-' +
			padZero(d.getDate(), 2);
		return s;
	}
	
	function convertTime(d) {
		var s = 
			padZero(d.getHours(), 2) + ':' +
			padZero(d.getMinutes(), 2);
		return s;
	}

	function padZero(n, digits) {
		var zero = '';
		n = n.toString();

		if (n.length < digits) {
			for (i = 0; i < digits - n.length; i++)
				zero += '0';
		}	
		return zero + n;
	}
	
	function trim(str) {
	    return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
	}
	
	function trim(str) {
	    return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
	}
</script>
</head>
<body>
<div class='row-fluid'>
	<div class='span10'><%@ include file="./menuGlobal.jsp" %>
		<div class='row-fluid'>
			<div class='span2 vertNav'><%=getVertNav(req, oUserSession) %></div>
			<div class='span10 all' id="calendar"></div>
		</div>
	</div>
	<%=getNotification(oUserSession, "span2 noti") %>
</div>
	<form id="frmActivityMove">
		<input type="hidden" name="pIdx" />
		<input type="hidden" name="pStartDate"/><input type="hidden" name="pEndDate" />
		<input type="hidden" name="pStartTime"/><input type="hidden" name="pEndTime" />
	</form>
</body>
</html>
<%@ include file="./common/include/incFooter.jspf" %><%!
class Activity {
	int n_idx ;
	String v_desc ;
	String v_start_datetime ;
	String v_end_datetime ;
	int n_start_gap ;
	int n_end_gap ;
	int n_task_idx ;
	
	public Activity(DataSet ds) {
		this.n_idx = ds.getInt(1) ;
		this.v_desc = ds.getString(2) ;
		this.v_start_datetime = ds.getString(3) ;
		this.v_end_datetime = ds.getString(4) ;
		
		this.n_start_gap = ds.getInt(5) ;
		this.n_end_gap = ds.getInt(6) ;
		
		this.n_task_idx =  ds.getInt(7) ;
	}
	
	public String get() {
		String start_gap = "" ; 
		if(n_start_gap != 0)start_gap = ((n_start_gap>0)?"+":"") + n_start_gap ;
		
		String end_gap = "" ; 
		if(n_end_gap != 0) end_gap = ((n_end_gap>0)?"+":"") + n_end_gap ;
		
		String actDesc = v_desc.replaceAll("\r\n"," ").replaceAll("\n\r"," ").replace("\\", "\\\\").replace("'", "\\'") ;	// -- 줄바꿈이 있으면 캘린더 출력 못함 // 130806 ' , \ 있을시 달력 안나오는 문제 해결
		
		String result =  "{idx:"+ n_idx
			+ ",title:'"+ ( actDesc ) +"'"				// -- TODO - 특수문자 처리필요. 특히,single quotation
			+ ",start:new Date(y,m,d"+start_gap+")" 	// -- TODO - 시간정보 포함요. y,m,d,H,i
			+ ",end:new Date(y,m,d"+end_gap+")"
			+ ",task_idx:"+n_task_idx
			// -- + ",allDay:false"
			+ "}," ;
		
		return result ;		
	}
}
%>