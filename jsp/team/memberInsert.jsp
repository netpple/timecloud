<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ include file="../common/include/incInit.jspf" %><%@ include file="../common/include/incSession.jspf" %><%
    RequestHelper mReq = new RequestHelper(request, response);
    final String team_idx = mReq.getParam("team_idx","");
    final String user_idx = mReq.getParam("user_idx","");

    if(StringUtils.isEmpty(user_idx) || StringUtils.isEmpty(team_idx) ){
        out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\"}",Cs.FAIL_TEAMUSER_ADD_PARAM,"잘못된 접근입니다..")); // 파라메터 이상
        return;
    }

    int cnt = QueryHandler.executeUpdate("INSERT_TEAM_USER",new String[]{team_idx, user_idx, DOMAIN_IDX});
    if(cnt<=0){
        out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\"}",Cs.FAIL_TEAMUSER_ADD_ERROR,"등록에 실패하였습니다.")); // 처리실패
        return;
    }

    out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\"}",Cs.SUCCESS,"등록되었습니다.")); // 처리실패
%>