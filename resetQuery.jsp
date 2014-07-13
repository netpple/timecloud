<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import = "java.net.InetAddress" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "org.apache.log4j.*" %>

<%


	com.twobrain.common.core.QueryHandler.reset();
%>
<HTML>
<HEAD>
<TITLE>ResetQuery</TITLE>
</HEAD>

<BODY>
ResetQuery
<br>
Host : <%= InetAddress.getLocalHost().getHostName() %>
(<%= InetAddress.getLocalHost().getHostAddress() %>)&nbsp;&nbsp;
<% SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss", Locale.KOREA); %>
<br>
Date : <%= formatter.format(new Date()) %>

<FORM METHOD=POST >
    <INPUT TYPE="submit" value="- RESET QUERY -">
</FORM>
</BODY>
</HTML>


