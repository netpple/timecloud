<%@ page import="org.apache.commons.lang3.StringUtils" %>
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
        String sDomainIdx = mReq.getParam("domain_idx", "");
        if(StringUtils.isEmpty(sDomainIdx)){
            return String.format("alert('%s');",Cs.FAIL_MSG_2); //잘못된 접근
        }

        if (StringUtils.isEmpty(sName)) {
            return "alert('이름을 입력하세요.');";
        } else {
            sName = sName.trim();
            if (sName.length() < 3) {
                return "alert('이름을 확인해 주세요.');";
            }
        }

        // -- validation
        if (StringUtils.isEmpty(sPasswd.trim())) {
            return "alert('비밀번호를 입력해주세요');";
        }

        sEmail = sEmail.trim();
        if (StringUtils.isEmpty(sEmail) || sEmail.length() < 5) {
            return "alert('이메일을 확인해 주십시오.');";
        }

        // 도메인 확인
        if(QueryHandler.executeQueryInt("SELECT_IS_DOMAIN",sDomainIdx)<1){
            return String.format("alert('%s');",Cs.FAIL_MSG_2); //잘못된 접근

        }

        // 사용자 기등록여부 확인
        String user_idx = null;
        DataSet ds = QueryHandler.executeQuery("SELECT_DOMAIN_USER_BY_EMAIL",sEmail);
        if(ds != null && ds.size()>0) { // 하나 이상의 도메인에 가입된 경우
            while(ds.next()){
                if(StringUtils.equals(sDomainIdx,ds.getString("N_DOMAIN_IDX"))){ // 동일 도메인으로 가입신청한 경우
                    return "alert('이미 등록된 이메일입니다.');";
                }

                if(user_idx == null)user_idx = ds.getString("N_IDX"); // 사용자코드를 기록
            }
        }

        // int result = QueryHandler.executeUpdate("INSERT_USER", new String[] {sEmail,sPasswd,sName});
        Vector<Object> vInsertTaskTransaction = new Vector<Object>();

        // 사용자 등록
        if(StringUtils.isEmpty(user_idx)){ // 처음 등록하는 사용자이면(user_idx 없음)
            user_idx = Integer.toString(QueryHandler.executeQueryInt("SELECT_USER_SEQ"));
            vInsertTaskTransaction.add("INSERT_USER_JOIN");
            vInsertTaskTransaction.add(new String[]{user_idx,sEmail,sPasswd,sName,sEmail});
        }
        // 도메인에 등록
        vInsertTaskTransaction.add("INSERT_DOMAIN_USER");
        vInsertTaskTransaction.add(new String[]{sDomainIdx,user_idx});

        String sTransactionResult = QueryHandler.executeTransaction(vInsertTaskTransaction);

        if(sTransactionResult.equals(Cs.COMMIT)) {
            return "alert('가입되었습니다. 로그인해 주십시오.');";
        }

        return "alert('사용자정보 저장실패');";
    }
%>