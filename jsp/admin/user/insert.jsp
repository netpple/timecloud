<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../../common/include/incInit.jspf" %>
<%@ include file="../../common/include/incSession.jspf" %>
<%
    String alert = insert(DOMAIN_IDX, req);
    String url = "location.replace('list.jsp')";

    out.print(JavaScript.write(alert + url));
%><%!
    public String insert(final String DOMAIN_IDX, RequestHelper req) {
        String sName = req.getParam("user_name", "");
        String sEmail = req.getParam("user_email");
        String sPasswd = req.getParam("user_passwd");


        String alert = "";

        if (DOMAIN_IDX.isEmpty()) {
            return "alert('도메인정보가 없습니다.');";
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
        if (sEmail == null || sPasswd == null) {
            return "alert('Email or password is null');";
        }

        sEmail = sEmail.trim();
        if (sEmail.length() < 5) {
            return "alert('이메일을 확인해 주십시오.');";
        }

        sPasswd = sPasswd.trim();
        if (sPasswd.length() < 4) { // -- email과 비밀번호 길이 체크
            return "alert('비밀번호는 4글자 이상입니다. ');";
        }

        // -- TODO - EMAIL 및 비밀번호 정규화 체크 로직 필요
        // -- TODO - VALIDATION 공통함수 필요
        int result = transaction(DOMAIN_IDX, sEmail, sPasswd, sName);
        if (result > 0) {
            return "alert('사용자정보 저장완료');";
        }

        return "alert('사용자정보 저장실패');";
    }

    int transaction(String DOMAIN_IDX, String sEmail, String sPasswd, String sName) {
        int seq = QueryHandler.executeQueryInt("SELECT_USER_SEQ");
        final String user_idx = Integer.toString(seq);
        Vector<Object> vInsertTaskTransaction = new Vector<Object>();

        vInsertTaskTransaction.add("INSERT_USER");
        vInsertTaskTransaction.add(new String[]{user_idx, sEmail, sPasswd, sName});
        vInsertTaskTransaction.add("INSERT_DOMAIN_USER");
        vInsertTaskTransaction.add(new String[]{DOMAIN_IDX, user_idx});

        String sTransactionResult = QueryHandler.executeTransaction(vInsertTaskTransaction);

        if (sTransactionResult.equals(Cs.COMMIT)) {
            return seq;
        }

        return -1;
    }
%>