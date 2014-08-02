<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/include/incInit.jspf" %>
<%@ include file="../common/include/incSession.jspf" %>
<%
    RequestHelper req = new RequestHelper(request, response);
    final String team_idx = req.getParam("team_idx", "");
    final String user_idx = req.getParam("user_idx", "");

    if (StringUtils.isEmpty(user_idx) || StringUtils.isEmpty(team_idx)) {
        out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\"}", Cs.FAIL_PARAM, Cs.FAIL_MSG_2)); // 파라메터 이상
        return;
    }

    // 권한체크 - 관리자, 팀장만 수행할 수 있다.
    if (QueryHandler.executeQueryInt("SELECT_IS_TEAM_OWNER", new String[]{USER_IDX, team_idx, DOMAIN_IDX}) < 1) {
        out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\"}", Cs.FAIL_AUTH, Cs.FAIL_MSG_2)); // 권한 없음
        return;
    }


    int cnt = QueryHandler.executeUpdate("INSERT_TEAM_USER", new String[]{team_idx, user_idx, DOMAIN_IDX});
    if (cnt <= 0) {
        out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\"}", Cs.FAIL_CREATE, Cs.FAIL_MSG_1)); // 등록실패
        return;
    }

    out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\"}", Cs.SUCCESS, Cs.SUCCESS_MSG_2)); // 저장성공
%>