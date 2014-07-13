<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%
	// -- final boolean IS_TASK_OWNER -- 각 도구 페이지에서 정의됨

	String[] tTab = new String[]{"","","",""} ; // -- tool 개수 만큼 생성, 선택된 도구 탭에 active들어가면 됨.
	if(_toolTabNo > 4) {
		out.println("Check ToolTabNo:"+_toolTabNo) ;
		return ;
	}
	tTab[_toolTabNo] = "active" ;
%>
<script type="text/javascript">	
	function onViewCalendar(taskidx) {
		var url = '<%=CONTEXT_PATH%>/jsp/calendar.jsp?tsk_idx='+taskidx<%=Html.trueString(TASK_LIST>0,"+'&tsk_list="+TASK_LIST+"'")%>;
		location.href = url;
	}
	
	function onViewAllCalendar(taskidx) {
		var url = '<%=CONTEXT_PATH%>/jsp/calendarTaskAll.jsp?tsk_idx='+taskidx;
		location.href = url;
	}

	function onViewTaskHierarchy() {
		location.href= '<%=CONTEXT_PATH%>/jsp/taskHierarchy.jsp?tsk_idx=<%=TASK_IDX%>';
	}
	
	function goToFeedback() {
		location.href= '<%=CONTEXT_PATH%>/jsp/feedback.jsp?tsk_idx=<%=TASK_IDX%>';
	}
	
	function goToFileUpload() {
		location.href= '<%=CONTEXT_PATH%>/jsp/file.jsp?tsk_idx=<%=TASK_IDX%><%=Html.trueString(TASK_LIST>0,"&tsk_list="+TASK_LIST)%>';
	}		
	
	function tabToProject(taskidx) {
		location.href= '<%=CONTEXT_PATH%>/jsp/project.jsp?tsk_idx='+taskidx;
	}
	
	function tabToObserver() {
		location.href= '<%=CONTEXT_PATH%>/jsp/observer.jsp?tsk_idx=<%=TASK_IDX%><%=Html.trueString(TASK_LIST>0,"&tsk_list="+TASK_LIST)%>';
	}
</script>
<div>
	<ul class="nav nav-tabs">
		<li class='<%=tTab[0]%>'><a href="javascript:onTaskHome('<%=TASK_IDX %>');" class='tabhome ellipsis'><%=Html.trueString(isAll,"전체 보기",oTaskHierarchy.getCurrentTask().getDesc()) %></a></li>
		<li class='<%=tTab[1]%>'><a href="javascript:onViewCalendar('<%=TASK_IDX %>');">일정</a></li>
		<li class='<%=tTab[2]%>'><a href="javascript:goToFileUpload();">자료</a></li>
		<li class='<%=tTab[3]%>'><a href="javascript:tabToObserver();">CC</a></li>
		<%--		
		<li class='<%=tTab[2]%>'><a href="javascript:goToFeedback();">태스크피드백</a></li>
		 <li class='<%=tTab[2]%>'><a href="javascript:onViewAllCalendar('<%=TASK_IDX %>');">태스크 전체일정</a></li>		
		 <li class='<%=tTab[2]%>'><a href="javascript:onViewTaskHierarchy();">태스크구조</a></li> 
		 <li class='<%=tTab[4]%>'><a href="javascript:tabToProject('<%=TASK_IDX %>');">프로젝트</a></li>
		 --%>
	</ul>
</div>