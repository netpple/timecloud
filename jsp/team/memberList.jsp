<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/include/incInit.jspf" %>
<%@ include file="../common/include/incSession.jspf" %>
<%
    RequestHelper mReq = new RequestHelper(request, response);
    final String team_idx = mReq.getParam("team_idx", "");
    if(StringUtils.isEmpty(team_idx)){
        out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\"}", Cs.FAIL_PARAM, Cs.FAIL_MSG_2));
        return;
    }

    // 멤버여부 확인 (멤버와 관리자만 목록조회 됨)
    if (!TeamInfo.isTeamMember(USER_IDX,team_idx,DOMAIN_IDX)) {
        out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\"}", Cs.FAIL_READ, Cs.FAIL_MSG_2));
        return;
    }

    // 멤버정보 조회
    List<UserInfo> list = UserInfo.getTeamUsers(team_idx, DOMAIN_IDX);
    if (list == null || list.size() < 1) { // list를 포함할 경우 데이터 개수를 준다.
        out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\",\"count\":\"0\"}", Cs.FAIL_READ, Cs.FAIL_MSG_3, ""));    // 결과없음
        return;
    }

    Iterator<UserInfo> it = list.iterator();
    StringBuffer sbTr = new StringBuffer();
    UserInfo info = null;
    int memberCnt = 0;
    String formatJson = "{\"photo\":\"%s\",\"name\":\"%s\",\"email\":\"%s\",\"tel\":\"%s\",\"idx\":\"%s\"}";
    while (it.hasNext()) {
        info = it.next();
        if(memberCnt > 0)sbTr.append(",");
        sbTr.append(String.format(formatJson,getProfileImageUrl(Integer.parseInt(info.getIdx())),info.getName(),info.getEmail(),info.getTel(),info.getIdx()));
        memberCnt ++;
    }
    out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\",\"count\":\"%d\",\"list\":[%s]}", Cs.SUCCESS, "",memberCnt,sbTr.toString()));
    return;
%>