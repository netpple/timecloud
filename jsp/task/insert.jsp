<%@ page import="com.google.gson.Gson" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/include/incInit.jspf" %>
<%@ include file="../common/include/incSession.jspf" %><%
    String desc = req.getParam("desc", null) ;
    String domain_yn = "N";
    if(IS_DOMAIN_ADMIN){
        domain_yn = req.getParam("domain_yn", "N") ;    // 도메인공유태스크 여부
    }

    JsonResult result = new JsonResult();
    result.count = 0;
    if(desc == null || "".equals(desc.trim())) { // 파람이상
        result.result = Cs.FAIL_PARAM;
        result.msg = Cs.FAIL_MSG_2;
        out.print(new Gson().toJson(result));
        return ;
    }

    String seq = QueryHandler.executeQueryString("SELECT_TASK_SEQ") ;
    Vector<Object> vInsertTaskTransaction = new Vector<Object>();
    String[] asTaskParam = new String[]{
            seq,
            seq,
            seq,
            "0",
            "0",
            desc,
            domain_yn,
            ""+ownerIdx,
            DOMAIN_IDX} ;

    // -- TODO - 로그성 액티비티는 삭제해야 하지 않을까? 그런데, 이 경우는 태스크 등록 시 액티비티를 자동 등록해주고, 사용자가 날짜를 옮길 수 있게 해주니깐, 더 간편하지 않을까?
    String[] asActivityParam = new String[]{
            seq,
            desc,
            ""+ownerIdx,
            DOMAIN_IDX
    } ;
    vInsertTaskTransaction.add("INSERT_TASK");
    vInsertTaskTransaction.add(asTaskParam);
    vInsertTaskTransaction.add("INSERT_ACTIVITY3");
    vInsertTaskTransaction.add(asActivityParam);

    String sTransactionResult = QueryHandler.executeTransaction(vInsertTaskTransaction);

    if(!sTransactionResult.equals(Cs.COMMIT)) { // 생성실패
        result.result = Cs.FAIL_CREATE;
        result.msg = Cs.FAIL_MSG_1;
        out.print(new Gson().toJson(result));
        return;
    }

    Task task = new Task();
    task.idx = Integer.parseInt(seq);
    task.desc = desc;
    task.offyn = "N";
    task.timegap ="방금";


    result.count = 1;
    result.msg = Cs.SUCCESS_MSG_1;
    result.result = Cs.SUCCESS;
    result.task = task;

    out.print(new Gson().toJson(result));
%><%!
    public class JsonResult {
        public String result;
        public String msg;
        public int count;
        public Task task;
    }

    public class Task {
        public int idx;
        public String desc;
        public String offyn;
        public String timegap;
        public Task(){}
        public Task(DataSet ds) {
            idx = ds.getInt(1);
            desc = ds.getString(2);
            offyn = ds.getString(3);
            timegap = ds.getString(4);
        }
    }
%>