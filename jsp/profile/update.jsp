<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/include/incInit.jspf" %>
<%@ include file="../common/include/incSession.jspf" %>
<%
    String alert = update(USER_IDX,request,response);
    String url = "location.replace('view.jsp')";

    out.print(JavaScript.write(alert + url));
%>
<%!
    public String update(final String USER_IDX, HttpServletRequest request, HttpServletResponse response) {
        RequestHelper mReq = new RequestHelper(request, response);

        String sName = mReq.getParam("user_name", "");
        String sTel = mReq.getParam("user_tel", "");
        String sNotiEmail = mReq.getParam("user_noti_email");
        String sPasswd = mReq.getParam("user_passwd");

        String alert = "";

        if (USER_IDX.isEmpty()) {
            return "alert('파라메터 오류.');";
        }

        if ("".equals(sName)) {
            return "alert('이름을 입력하세요.');";
        } else {
            sName = sName.trim();
            if (sName.length() < 3) {
                return "alert('이름을 확인해 주세요.');";
            }
        }

        // -- validation
        if (sPasswd == null) {
            return "alert('비밀번호를 입력해주세요');";
        }

        sNotiEmail = sNotiEmail.trim();
        if (sNotiEmail.length() < 5) {
            return "alert('이메일을 확인해 주십시오.');";
        }

        int result = QueryHandler.executeUpdate("UPDATE_USER", new String[] {sName, sTel, sNotiEmail, USER_IDX, sPasswd});
        if (result > 0) {
            return "alert('사용자정보 저장완료');";
        }

        return "alert('사용자정보 저장실패');";
    }

    private String getExtention(String filename) {
        String suffix = "";
        int pos = filename.lastIndexOf('.');
        if (pos > 0 && pos < filename.length() - 1) {
            suffix = filename.substring(pos + 1);
        }
        return suffix.toLowerCase();
    }
%>
