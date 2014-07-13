<%@page import="java.util.Iterator"%><%@page import="java.util.TreeMap"%><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ page import="java.io.*" %><%@ page import="java.util.*" %><%@ page import="com.twobrain.common.core.QueryHandler" %><%@ page import="com.twobrain.common.core.DataSet" %><%
	String host = request.getRequestURL().toString();

	Process proc = Runtime.getRuntime().exec("D:/WebRoot/Timecloud/timecloud/update.bat");	
	out.println("Sync Complete - " + host.replace("sync.jsp",""));
	QueryHandler.reset();
%>