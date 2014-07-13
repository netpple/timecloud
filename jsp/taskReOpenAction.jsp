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
		out.print(JavaScript.write("alert('태스크 활성화에 실패했습니다.'); location.replace('"+replaceUrl+"');"));
		return ;
	}
	
	
	Vector<Object> vInsertTaskTransaction = new Vector<Object>();	
	
	vInsertTaskTransaction.add("UPDATE_TASK_ON");
	vInsertTaskTransaction.add(new String[]{STR_TASK_IDX, STR_OWNER_IDX});
	
	vInsertTaskTransaction.add("INSERT_ACTIVITY3");
	vInsertTaskTransaction.add(new String[]{STR_TASK_IDX,"Re-opened",STR_OWNER_IDX,DOMAIN_IDX});
	
	String sTransactionResult = QueryHandler.executeTransaction(vInsertTaskTransaction);


	if(sTransactionResult.equals(Cs.COMMIT)) {
		out.print(JavaScript.write("alert('태스크가 다시 활성화 되었습니다.'); location.replace('"+replaceUrl+"');"));
	} else {
		out.print(JavaScript.write("alert('태스크 활성화에 실패했습니다.'); location.replace('"+replaceUrl+"');"));
	}
%>
