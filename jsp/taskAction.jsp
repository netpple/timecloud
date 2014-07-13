<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%
	String pRedirect = req.getParam("redirect","taskList.jsp") ;
	String pTaskDesc = req.getParam("pTaskDesc", null) ;
	if(pTaskDesc == null || "".equals(pTaskDesc.trim())) {
		out.print(JavaScript.write("alert('태스크 등록 실패 - 태스크 내용을 입력하세요.');"));
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
			pTaskDesc,
			""+ownerIdx,
            DOMAIN_IDX} ;
	
	// -- TODO - 로그성 액티비티는 삭제해야 하지 않을까? 그런데, 이 경우는 태스크 등록 시 액티비티를 자동 등록해주고, 사용자가 날짜를 옮길 수 있게 해주니깐, 더 간편하지 않을까?
	String[] asActivityParam = new String[]{
			seq,
			pTaskDesc,
			""+ownerIdx,
            DOMAIN_IDX
		} ;

	vInsertTaskTransaction.add("INSERT_TASK");
	vInsertTaskTransaction.add(asTaskParam);
	vInsertTaskTransaction.add("INSERT_ACTIVITY3");
	vInsertTaskTransaction.add(asActivityParam);
	
	String sTransactionResult = QueryHandler.executeTransaction(vInsertTaskTransaction);

	if(sTransactionResult.equals(Cs.COMMIT)) {
		out.print(JavaScript.write("location.replace('"+pRedirect+"');"));
	} else {
		out.print(JavaScript.write("alert('태스크 등록 실패');"));
	}
%>