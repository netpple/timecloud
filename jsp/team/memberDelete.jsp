<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/include/incInit.jspf" %>
<%@ include file="../common/include/incSession.jspf" %>
<%
    final String team_idx = req.getParam("team_idx", "");
    final String user_idx = req.getParam("user_idx", "");

    if (StringUtils.isEmpty(user_idx) || StringUtils.isEmpty(team_idx)) {    // 파라메터 체크
        out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\"}", Cs.FAIL_PARAM, Cs.FAIL_MSG_2)); // 파라메터 이상
        return;
    }

    // 권한체크 - 관리자, 팀장만 수행할 수 있다. 단, 본인꺼는 삭제가능(탈퇴)
    if(!StringUtils.equals(USER_IDX,user_idx)){
        if (QueryHandler.executeQueryInt("SELECT_IS_TEAM_OWNER", new String[]{USER_IDX, team_idx, DOMAIN_IDX}) < 1) {
            out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\"}", Cs.FAIL_AUTH, Cs.FAIL_MSG_2)); // 권한 없음
            return;
        }
    }

    // 삭제
    int cnt = QueryHandler.executeUpdate("DELETE_TEAM_USER", new String[]{user_idx, team_idx, DOMAIN_IDX});
    if (cnt <= 0) { // 삭제 실패
        out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\"}", Cs.FAIL_DELETE, Cs.FAIL_MSG_1)); // 처리실패
        return;
    }

    out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\"}", Cs.SUCCESS, "삭제되었습니다.")); // 처리실패
%>