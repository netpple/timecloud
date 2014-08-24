<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../../common/include/incInit.jspf" %>
<%@ include file="../../common/include/incSession.jspf" %>
<%@ include file="../auth.jspf"%><%--관리자 권한체크 --%>
<%
    final int team_idx = req.getIntParam("team_idx", -1);
    if (team_idx < 1) { // 파라메터 이상
        out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\"}", Cs.FAIL, Cs.FAIL_MSG_2));
        return;
    }

    // TODO -  멤버여부 확인 (멤버와 관리자만 목록조회 됨)
//    if (!TeamInfo.isTeamMember(USER_IDX, Integer.toString(team_idx), DOMAIN_IDX)) {
//        out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\"}", Cs.FAIL_READ, Cs.FAIL_MSG_2));
//        return;
//    }

    TeamInfo team = TeamInfo.getInstance(Integer.toString(team_idx), DOMAIN_IDX);
    if (team == null) { // 조회실패
        out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\"}", Cs.FAIL_READ, Cs.FAIL_MSG_3));
        return;
    }

    final String team_name = team.getName();
    final String owner_name = team.getOwnerName();
    final String owner_idx = team.getOwnerIdx();
    final String owner_photo = getProfileImageUrl(Integer.parseInt(owner_idx));
    final String regdate = team.getRegDatetime();
    final String upddate = team.getEdtDatetime();

    out.print(
            String.format(
                    "{\"result\":\"%s\",\"msg\":\"%s\",\"team_idx\":\"%s\",\"team_name\":\"%s\",\"owner_name\":\"%s\",\"owner_idx\":\"%s\",\"owner_photo\":\"%s\",\"regdate\":\"%s\",\"upddate\":\"%s\"}"
                    , Cs.SUCCESS, "", team_idx, team_name, owner_name, owner_idx, owner_photo, regdate, upddate));
%>
