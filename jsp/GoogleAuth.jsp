<%@page import="com.twobrain.common.util.GoogleCalendarAPI"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %>
<%
	String sCode = "";
	String sToken = "";
	GoogleCalendarAPI oGoogleCalendarAPI = new GoogleCalendarAPI(oUserSession);
	if (request.getParameter("code") == null
			&& request.getParameter("token") == null) {
		String sURL = oGoogleCalendarAPI.getAutyhURL("test", ""+request.getRequestURL(),GoogleCalendarAPI.Response_Type.AUTH_CODE);
%>
	<script type="text/javascript">
			function getUserAuthentication(){
				window.location = '<%=sURL%>'
			}   
	</script>
	<button onClick="getUserAuthentication();">인증받기</button>
<%
	} else if (request.getParameter("code") != null) {
		sCode = request.getParameter("code");
		sToken = oGoogleCalendarAPI.getToken(sCode);
%>
	
	<script type="text/javascript"> 
		function getTokenURL(){
			window.location = '<%=request.getRequestURL() + "?token=" + sToken%>'
		}
		getTokenURL();
	</script>
<%
	} else if (request.getParameter("token") != null && request.getParameter("calendarID") == null) {
		sToken = request.getParameter("token");
%>
		<script type="text/javascript">
			function createCalendar(){
				window.location = '<%=request.getRequestURL() + "?token=" + sToken%>'+'&calendarID=need';
			}
		</script>
		<button onClick="createCalendar();">캘린더 생성</button>
		<%
	} else if(request.getParameter("calendarID").equals("need")){
		sToken = request.getParameter("token");
		String sCalendarID = oGoogleCalendarAPI.insertCalendars(sToken,"Umbrellas Calendar");
		String sMergedString = sToken+"#"+sCalendarID;
		QueryHandler.executeUpdate("INSERT_USER_SNSMAP", new String[] { Integer.toString(oUserSession.getUserIdx()), SNS_GC, sMergedString });;
		oUserSession.updateSNSState();
	}
%>
</body>
</html>