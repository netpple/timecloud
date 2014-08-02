<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/include/incInit.jspf" %>
<%@ include file="../common/include/incSession.jspf" %>
<%
    String sName = req.getParam("team_name", "");

    String url = "", alert = "팀 생성실패";
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

    // 팀등록
    final String team_idx = QueryHandler.executeQueryString("SELECT_TEAM_SEQ_NEXTVAL");
    if (StringUtils.isEmpty(team_idx)) {
        out.print(JavaScript.write(alert + url));
        return;
    }

    // 팀구성원 등록
    Vector<Object> vInsertTransaction = new Vector<Object>();
    vInsertTransaction.add("INSERT_TEAM2");
    vInsertTransaction.add(new String[]{team_idx, sName, USER_IDX, DOMAIN_IDX});
    vInsertTransaction.add("INSERT_TEAM_USER");
    vInsertTransaction.add(new String[]{team_idx, USER_IDX, DOMAIN_IDX});
    String sTransactionResult = QueryHandler.executeTransaction(vInsertTransaction);

    if (sTransactionResult.equals(Cs.COMMIT)) {
        alert = "alert('팀이 생성되었습니다.');";
    }

    out.print(JavaScript.write(alert + url));
    return;
%>