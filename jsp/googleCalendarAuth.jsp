<%@page import="com.twobrain.common.util.GoogleCalendarAPI"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %>
<%@ page import = "java.util.HashMap"%>
<%
	String sCode = "";
	String sToken = "";
	GoogleCalendarAPI oGoogleCalendarAPI = new GoogleCalendarAPI(oUserSession);
	if (request.getParameter("code") == null
			&& request.getParameter("token") == null) {
		String sURL = oGoogleCalendarAPI.getAuthUrl("test", ""+request.getRequestURL(),GoogleCalendarAPI.Response_Type.AUTH_CODE);
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
		if(!oUserSession.getAccessToken(SNS_GC).equals(sToken)){
			String sMergedString = sToken+"#"+oUserSession.getGoogleCalendarID();
			QueryHandler.executeUpdate("UPDATE_USER_SNSMAP", new String[] { sMergedString, Integer.toString(oUserSession.getUserIdx()), SNS_GC });;
			oUserSession.updateSNSState();
			%>
			<script type="text/javascript">
			alert("정보가 갱신되었습니다.");
			</script>
			<%
		}
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