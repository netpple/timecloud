<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/include/incInit.jspf" %>
<%--<%@ include file="../common/include/incSession.jspf" %>--%>
<%

    String alert = action(request,response);
    String url = "location.replace('/theme/1/pages/login/login.jsp')";
    out.print(JavaScript.write(alert + url));
%>
<%!
    private String action(HttpServletRequest request, HttpServletResponse response) {
        RequestHelper mReq = new RequestHelper(request, response);

        String sName = mReq.getParam("user_name", "");
        String sEmail = mReq.getParam("user_email", "");
        String sPasswd = mReq.getParam("user_passwd", "");
        String sDomainIdx = mReq.getParam("domain_idx", "1");

        String alert = "";

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

        sEmail = sEmail.trim();
        if (sEmail.length() < 5) {
            return "alert('이메일을 확인해 주십시오.');";
        }

        // 기등록여부 확인
        int cnt = QueryHandler.executeQueryInt("SELECT_USERCNT_BY_EMAIL",sEmail);
        if(cnt > 0){
            return "alert('이미 등록된 이메일입니다.');";
        }

//        int result = QueryHandler.executeUpdate("INSERT_USER", new String[] {sEmail,sPasswd,sName});
        int seq = QueryHandler.executeQueryInt("SELECT_USER_SEQ") ;
        final String user_idx = Integer.toString(seq);
        Vector<Object> vInsertTaskTransaction = new Vector<Object>();

        vInsertTaskTransaction.add("INSERT_USER_JOIN");
        vInsertTaskTransaction.add(new String[]{user_idx,sEmail,sPasswd,sName,sEmail});
        vInsertTaskTransaction.add("INSERT_DOMAIN_USER");
        vInsertTaskTransaction.add(new String[]{sDomainIdx,user_idx});

        String sTransactionResult = QueryHandler.executeTransaction(vInsertTaskTransaction);

        if(sTransactionResult.equals(Cs.COMMIT)) {
            return "alert('가입되었습니다. 로그인해 주십시오.');";
        }

        return "alert('사용자정보 저장실패');";
    }
%>
