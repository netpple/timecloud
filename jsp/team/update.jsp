<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/include/incInit.jspf" %>
<%@ include file="../common/include/incSession.jspf" %>
<%
    int idx = req.getIntParam("team_idx",-1) ;
    String sName = req.getParam("team_name", "");

    String url = "", alert = "";
    int result = 0;

    url = "location.replace('list.jsp')";

    if(idx < 1) alert = "alert('잘못된 요청입니다.');";

    if (idx > 0 && !sName.isEmpty()) {
        alert = "alert('팀명을 입력해주세요.');";
    } else {
        sName = sName.trim();
        if (sName.length() < 2) {
            alert = "alert('팀명은 2글자 이상입니다.');";
        }
        else {
            result = QueryHandler.executeUpdate("UPDATE_TEAM", sName);
            if (result > 0) {
                alert = "alert('저장되었습니다.');";
            } else {
                alert = "alert('저장실패');";
            }
        }
    }

    out.print(JavaScript.write(alert + url));
%>