<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ include file="../common/include/incInit.jspf" %><%@ include file="../common/include/incSession.jspf" %><%
    RequestHelper mReq = new RequestHelper(request, response);
    final String team_idx = mReq.getParam("team_idx","");
    final String user_idx = mReq.getParam("user_idx","");
    String result = "0"; // 성공, 나머지는 실패코드임
    if(StringUtils.isEmpty(user_idx) || StringUtils.isEmpty(team_idx) ){
        out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\"}",Cs.FAIL_TEAMUSER_DEL_PARAM,"잘못된 접근입니다..")); // 파라메터 이상
        return;
    }

    int cnt = QueryHandler.executeUpdate("DELETE_TEAM_USER",new String[]{user_idx, team_idx, DOMAIN_IDX});
    if(cnt<=0){
        out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\"}",Cs.FAIL_TEAMUSER_DEL_ERROR,"삭제에 실패하였습니다.")); // 처리실패
        return;
    }

    out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\"}",Cs.SUCCESS,"삭제되었습니다.")); // 처리실패
%>