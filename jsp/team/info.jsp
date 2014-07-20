<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ include file="../common/include/incInit.jspf" %><%@ include file="../common/include/incSession.jspf" %><%
    RequestHelper mReq = new RequestHelper(request, response);
    final int team_idx = mReq.getIntParam("team_idx", -1);
    if (team_idx < 1) { // 파라메터 이상
        out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\"}", Cs.FAIL, Cs.FAIL_MSG_2));
        return;
    }

    // 멤버여부 확인 (멤버와 관리자만 목록조회 됨)
    int cnt = QueryHandler.executeQueryInt("SELECT_IS_MEMBER", new String[]{USER_IDX, Integer.toString(team_idx), DOMAIN_IDX});
    if (cnt <= 0) {
        out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\"}", Cs.FAIL_READ, Cs.FAIL_MSG_2));
        return;
    }

    TeamInfo team = TeamInfo.getInstance(USER_IDX, Integer.toString(team_idx), DOMAIN_IDX);
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
                    ,Cs.SUCCESS,"", team_idx, team_name, owner_name, owner_idx, owner_photo, regdate, upddate));
%>
