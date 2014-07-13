<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../common/include/incInit.jspf" %>
<%@ include file="../../common/include/incSession.jspf" %>
<%
    // TODO - 권한 제어 : DOMAIN ADMIN 이상

    RequestHelper mReq = new RequestHelper(request, response);
    int idx = mReq.getIntParam("domain_idx",-1) ;

    String url = "", alert="";
    int result = 0;

    if(idx > 0) {
        result = QueryHandler.executeUpdate("DELETE_DOMAIN", idx) ;
        if(result > 0)
            alert = "alert('삭제되었습니다.');";
    }

    if(idx < 1 || result < 1) alert ="alert('삭제실패');";

    url = "location.replace('list.jsp')";

    out.print(JavaScript.write(alert+url));
    return;
%>