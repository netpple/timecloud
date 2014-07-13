<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %>

<%
	String uri = request.getRequestURL().toString();
%>


<script type="text/javascript">
var url = '<%=CONTEXT_PATH%>/jsp/main.jsp' ;

<%if(uri.contains("tt.2brain.com") || uri.contains("localhost")) {%>
	url = '<%=CONTEXT_PATH%>/jsp/main.jsp' ;
<%}%>
location.href = url ;
</script>