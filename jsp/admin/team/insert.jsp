<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../../common/include/incInit.jspf" %>
<%@ include file="../../common/include/incSession.jspf" %>
<%@ include file="auth.jspf"%><%--관리자 권한체크 --%>
<%
    String sName = req.getParam("team_name", "");

    String url = "", alert = "";
    int result = 0;

    url = "location.replace('list.jsp')";

    if (StringUtils.isEmpty(sName)) {
        alert = "alert('팀명을 입력해주세요.');";
        out.print(JavaScript.write(alert + url));
        return;
    }

    sName = sName.trim();
    if (sName.length() < 2) {
        alert = "alert('팀명은 2글자 이상입니다.');";
        out.print(JavaScript.write(alert + url));
        return;
    }

    result = QueryHandler.executeUpdate("INSERT_TEAM", new String[]{sName, USER_IDX, DOMAIN_IDX});
    if (result > 0) {
        alert = "alert('저장되었습니다.');";
    } else {
        alert = "alert('저장실패');";
    }
    out.print(JavaScript.write(alert + url));
%>