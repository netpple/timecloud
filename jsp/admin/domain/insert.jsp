<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../../common/include/incInit.jspf" %>
<%@ include file="../../common/include/incSession.jspf" %>
<%
    RequestHelper mReq = new RequestHelper(request, response);
    String sName = mReq.getParam("domain_name", "");

    String url = "", alert = "";
    int result = 0;

    url = "location.replace('list.jsp')";

    if (!sName.isEmpty()) {
        alert = "alert('도메인명을 입력해주세요.');";
    } else {
        sName = sName.trim();
        if (sName.length() < 2) {
            alert = "alert('도메인명은 2글자 이상입니다.');";
        }
        else {
            result = QueryHandler.executeUpdate("INSERT_DOMAIN", sName);
            if (result > 0) {
                alert = "alert('저장되었습니다.');";
            } else {
                alert = "alert('저장실패');";
            }
        }
    }
    out.print(JavaScript.write(alert + url));
%>