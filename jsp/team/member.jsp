<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ include file="../common/include/incInit.jspf" %><%@ include file="../common/include/incSession.jspf" %><%
    RequestHelper mReq = new RequestHelper(request, response);
    final String email = mReq.getParam("email","");
    String result = "0"; // 성공, 나머지는 실패코드임
    if(StringUtils.isEmpty(email)){
        out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\"}",Cs.FAIL_PARAM,"이메일을 입력해주세요."));
        return;
    }

    UserInfo userInfo = UserInfo.getUserByEmail(email);
    if(userInfo == null){
        out.print(String.format("{\"result\":\"%s\",\"msg\":\"%s\"}",Cs.FAIL_READ,"등록되지 않은 사용자입니다.")); //결과없음(0) - GET에만 해당
        return;
    }
%>
{
"result":"<%=Cs.SUCCESS%>",
"msg":"",
"idx":"<%=userInfo.getIdx()%>",
"email":"<%=userInfo.getEmail()%>",
"name":"<%=userInfo.getName()%>",
"photo":"<%=getProfileImageUrl(Integer.parseInt(userInfo.getIdx()))%>",
"tel":"<%=userInfo.getTel()%>"
}