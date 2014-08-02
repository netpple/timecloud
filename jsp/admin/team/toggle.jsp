<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../../common/include/incInit.jspf" %>
<%@ include file="../../common/include/incSession.jspf" %>
<%
    RequestHelper req = new RequestHelper(request, response);
    int idx = req.getIntParam("team_idx", -1);
    String sToggle = req.getParam("toggle", "");

    String url = "", alert = "";
    int result = 0;

    if (idx > 0 && !sToggle.isEmpty()) { // ON/OFF 토글링
        if (sToggle.equalsIgnoreCase("on")) {
            result = QueryHandler.executeUpdate("UPDATE_TEAM_ON", idx);
        } else if (sToggle.equalsIgnoreCase("off")) {
            result = QueryHandler.executeUpdate("UPDATE_TEAM_OFF", idx);
        }
    }

    if (result < 1) alert = "alert('Invalid parameter');";

    url = "location.replace('list.jsp')";
    out.print(JavaScript.write(alert + url));
    return;
%>