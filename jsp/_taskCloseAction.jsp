<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%

	final String STR_TASK_IDX = "" + TASK_IDX ;
	final String STR_OWNER_IDX = "" + ownerIdx ;
	final String actionUrl = req.getParam("actionUrl","");
	
	String replaceUrl = "task.jsp?tsk_idx="+STR_TASK_IDX;
	if(actionUrl.length() > 0 && !actionUrl.equals("undefined")){
		replaceUrl = actionUrl+"?tsk_idx="+STR_TASK_IDX;
	}
	
	if(TASK_IDX <= 0){
		out.print(JavaScript.write("alert('태스크 종료에 실패했습니다.'); location.replace('"+replaceUrl+"');"));
		return ;
	}
	
	Vector<Object> vInsertTaskTransaction = new Vector<Object>();	
	vInsertTaskTransaction.add("UPDATE_TASK_OFF");
	vInsertTaskTransaction.add(new String[]{STR_TASK_IDX, STR_OWNER_IDX});
	
	/*
	vInsertTaskTransaction.add("INSERT_ACTIVITY3");
	vInsertTaskTransaction.add(new String[]{
			STR_TASK_IDX,
			"Terminated",
			STR_OWNER_IDX
		});
	*/
	String sTransactionResult = QueryHandler.executeTransaction(vInsertTaskTransaction);


	if(sTransactionResult.equals(Cs.COMMIT)) {
		out.print(JavaScript.write("alert('태스크가 종료처리되었습니다.'); location.replace('"+replaceUrl+"');"));
	} else {
		out.print(JavaScript.write("alert('태스크 종료에 실패했습니다.'); location.replace('"+replaceUrl+"');"));
	}
%>
