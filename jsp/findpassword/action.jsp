<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/include/incInit.jspf" %>
<%--<%@ include file="../common/include/incSession.jspf" %>--%>
<%
    String alert = action(request, response);
    String url = "location.replace('/theme/1/pages/login/login.jsp')";
    out.print(JavaScript.write(alert + url));
%>
<%!
    private boolean sendEmail(final String email, final String password) {
        NotificationService service = new NotificationService();
        return service.sendEmailFindNotification(email, password);
    }

    private boolean updatePassword(final String email, final String password) {
        int cnt = QueryHandler.executeUpdate("UPDATE_USER_PASSWD_BY_EMAIL",new String[]{password,email});
        return (cnt > 0);
    }

    private String createPassword(final String email) {
        String password = randomPassword();
        if(!updatePassword(email,password)) return null;

        return password;
    }

    private boolean isMember(String email) {
        int cnt = QueryHandler.executeQueryInt("SELECT_USERCNT_BY_EMAIL",email);
        return (cnt == 1);
    }

    private String randomPassword(){
        String password = "";
        for(int i = 0; i < 8; i++){
            //char upperStr = (char)(Math.random() * 26 + 65);
            char lowerStr = (char)(Math.random() * 26 + 97);
            if(i%2 == 0){
                password += (int)(Math.random() * 10);
            }else{
                password += lowerStr;
            }
        }

        return password;
    }

    private String action(HttpServletRequest request, HttpServletResponse response) {
        RequestHelper mReq = new RequestHelper(request, response);
        String email = mReq.getParam("user_email", "");
        if(StringUtils.isEmpty(email))return "alert('이메일을 입력해주세요.');";

        // 해당 이메일로 사용자 여부 조회
        if(!isMember(email))return "alert('등록된 사용자가 아닙니다.')";
        // 임시비밀번호 생성
        String password = createPassword(email);
        // 비밀번호 업데이트
        if(password == null) return "alert('임시비밀번호 발급이 실패했습니다.');";
        // 이메일 전송
        if(!sendEmail(email,password)) return "alert('이메일 전송에 실패했습니다.');";

        return "alert('해당 이메일로 임시비밀번호를 전송하였습니다.');";
    }
%>
