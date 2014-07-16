<%@page import="com.twobrain.common.util.RequestHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%
/*
	String[] gTab = new String[]{"","","","","","","","","",""} ;
	if(_globalTabNo>=0 && _globalTabNo<10)gTab[_globalTabNo] = "active" ;
*/
%>
<script type="text/javascript">
	function onLogout() {
		location.href = '<%=CONTEXT_PATH%>/jsp/login/logout.jsp';
	}
	
	// -- GLOBAL MENU - TASK_IDX 가 불필요
	function onViewTaskList() {
		var url = '<%=CONTEXT_PATH%>/jsp/taskList.jsp';
		location.href = url;
	}
	
	function onViewChildTask() {
		var url = '<%=CONTEXT_PATH%>/jsp/taskChildList.jsp';
		location.href = url;
	}
	
	function onViewObserverTask() {
		var url = '<%=CONTEXT_PATH%>/jsp/taskObserverList.jsp';
		location.href = url;
	}
	
	function onViewAllActivities() {
		var url = '<%=CONTEXT_PATH%>/jsp/calendarAll.jsp';
		location.href = url;
	}

	function onViewAllFeedback() {
		var url = '<%=CONTEXT_PATH%>/jsp/feedbackAll.jsp';
		location.href = url;
	}

	function onViewAllFile() {
		var url = '<%=CONTEXT_PATH%>/jsp/fileAll.jsp';
		location.href = url;
	}	
	
	function onViewAllProject() {
		var url = '<%=CONTEXT_PATH%>/jsp/projectAll.jsp';
		location.href = url;
	}
	
	function onViewCalendar(taskidx) {
		var url = '<%=CONTEXT_PATH%>/jsp/calendar.jsp?tsk_idx='+taskidx;
		location.href = url;
	}
	
	function onViewProject(tasklist) {
		var url = '<%=CONTEXT_PATH%>/jsp/project.jsp?tsk_idx='+tasklist;
		location.href = url; 
	}
	
	function onViewAllObserver() {
		var url = '<%=CONTEXT_PATH%>/jsp/observerAll.jsp';
		location.href = url;
	}
	
	function onViewAllActivity() {
		var url = '<%=CONTEXT_PATH%>/jsp/activityAll.jsp';
		location.href = url;
	}
	
	function onLiveChat() {
		var url = '<%=CONTEXT_PATH%>/jsp/chat.jsp';
		location.href = url;
	}
	
	// -- MAIN DASHBOARD
	function onMain() {
		var url = '<%=CONTEXT_PATH%>/jsp/index.jsp' ;
		location.href = url ;
	}
	
	
	// -- TASK HOME
	function onTaskHomeAll(taskList) {
		var url = '<%=CONTEXT_PATH%>/jsp/task.jsp?tsk_idx='+taskList+'&tsk_list='+taskList;
		location.href = url ;
	}
	function onTaskHome(taskidx) {
		var url = '<%=CONTEXT_PATH%>/jsp/task.jsp?tsk_idx='+taskidx<%=Html.trueString(TASK_LIST>0,"+'&tsk_list="+TASK_LIST+"'")%>;
		location.href = url ;
	}
	
	function onTaskHomePop(taskidx) {
		var url = '<%=CONTEXT_PATH%>/jsp/task.jsp?tsk_idx='+taskidx;
		var pop = window.open(url) ; 
		pop.focus() ;
	}	
	
	function onTaskHomeActivityPop(taskidx, idx) {
		var url = '<%=CONTEXT_PATH%>/jsp/task.jsp?tsk_idx='+taskidx +'#ACTIVITY_'+idx;
		var pop = window.open(url) ; 
		pop.focus() ;
	}
</script>
<div class="navbar">
  <div class="navbar-inner">
    <div class="container">
      <a class="btn btn-navbar" data-toggle="collapse" data-target=".navbar-responsive-collapse">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </a>
      <%--<img src="<%=IMG_PATH%>/navi_logo.png"/> --%>
      <a class="brand" href="javascript:onMain();"><img src="<%=IMG_PATH%>/navi_logo.png" width="167px" height="26px" style="float:left; position:absolute; top:5px; left:10px;"/></a>
      <div class="nav-collapse collapse navbar-responsive-collapse" style="margin-left:170px;">
        <ul class="nav">
			<%-- 
			<li class="<%=gTab[2]%>"><a href="javascript:onViewAllActivities();"><%=Html.Icon.ACTIVITY %></a></li>
			<li class="<%=gTab[4]%>"><a href="javascript:onViewAllFile();"><%=Html.Icon.FILE %></a></li>
			<li class="<%=gTab[3]%>"><a href="javascript:onViewAllFeedback();">전체피드백</a></li>
			<li class="<%=gTab[0]%>"><a href="javascript:onViewTaskList();">태스크목록</a></li>
			<li class="<%=gTab[8]%>"><a href="javascript:onViewAllActivity();">전체액티비티</a></li>
			<li class="<%=gTab[1]%>"><a href="javascript:onViewChildTask();">할당태스크</a></li>
			<li class="<%=gTab[7]%>"><a href="javascript:onViewObserverTask();">참조태스크</a></li>
			<li class="<%=gTab[6]%>"><a href="javascript:onViewAllObserver();">전체참조자</a></li>
			<li class="<%=gTab[5]%>"><a href="javascript:onViewAllProject();">전체프로젝트</a></li>
			<li class="<%=gTab[9]%>"><a href="javascript:onLiveChat();">채팅(개발중)</a></li>
			--%>			
        </ul>
		<form class="navbar-search pull-left" action="/jsp/search.jsp">
			<input type='hidden' name='searchType' value='<%=pSearchType %>' />
			<input type="text" name='searchValue' value="<%=pSearchValue %>" class="search-query" placeholder="Search">
		</form>
        <ul class="nav pull-right">
          <li><a href='/jsp/userInfo.jsp?user_idx=<%=oUserSession.getUserIdx()%>'>
              <img src="<%=getProfileImageUrl(oUserSession.getUserIdx())%>" style="height:30px; float:left;position:absolute; top:5px; left:-17px;"/> &nbsp;<%=oUserSession.getUserName() %>님</a>
          </li>
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown"><img src="<%=IMG_PATH %>/setting_icon.png"/></a>
            <ul class="dropdown-menu">
              <li><a href='/jsp/profile/view.jsp'>Profile</a></li>
              <li class="divider"></li>
              <li><a href="javascript:onLogout();">로그아웃</a></li>
            </ul>
          </li>
        </ul>
      </div><!-- /.nav-collapse -->
    </div>
  </div><!-- /navbar-inner -->
</div><!-- /navbar -->