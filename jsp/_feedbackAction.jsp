<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%
	if(TASK_IDX <= 0 ) { 
		out.println("Parameter is invalid") ;
		return ;
	}

	String sFeedback = req.getParam("pFeedback","") ;	// -- 피드백 내용
	String feedType = req.getParam("feedType","") ;	// -- 피드백 내용
	if( "".equals(sFeedback.trim()) ){
		out.print("fail to feedback") ;
		return ;
	} 

	String serverTime = QueryHandler.executeQueryString("GET_SERVER_TIME");
	String v_timegap = QueryHandler.executeQueryString("GET_TIME_GAP",serverTime);
	int feedbackIdx = QueryHandler.executeQueryInt("GET_FEEDBACK_SEQUENCE");
	
	int ret = QueryHandler.executeUpdate("TEST_INSERT_FEEDBACK"
			,new String[]{ ""+feedbackIdx, sFeedback, ""+ownerIdx,""+TASK_IDX,""+serverTime});

	if(ret>0) {
		setTaskUpdateTime(TASK_IDX) ;
		NotificationService ntfcService = new NotificationService(oUserSession);
		ntfcService.sendFeedbackNotification(TASK_IDX, feedbackIdx, sFeedback);
		
		StringBuffer sbOut = new StringBuffer() ;
		
		if(feedType.equals("GAP")){
			String component = "" ;
			String message = null ;
			component = " <input type='button' class='btn btn-mini btn-danger' value='Delete' onClick=\"javascript:tool_delete("+TASK_IDX+","+feedbackIdx+",'FEEDBACK');\" />";
			message = "내가 남긴 피드백입니다."+Html.Icon.FEEDBACK ;
			message += " " + v_timegap ;
			sbOut.append("<div id='FEEDBACK_"+feedbackIdx+"' class='tool'><dl>");
			sbOut.append(	"<dt class='img'>");
			sbOut.append(		getProfileImage(oUserSession.getDomainIdx(), ownerIdx));
			sbOut.append(	"</dt>");
			sbOut.append(	"<dd><small>");
			sbOut.append(		message );
			sbOut.append(	"</small></dd>");
			sbOut.append(	"<dd class=messageBody>");
			sbOut.append( addLink( stringToHTMLString(sFeedback) ) );
			sbOut.append(	"</dd>");
			sbOut.append(	"<dd>");
			sbOut.append( component );
			sbOut.append(	"</dd>");
			sbOut.append("</dl></div>");
		}else{
			sbOut.append("<div class='feedback' feedbackIdx="+feedbackIdx+"><dl>");
			sbOut.append(	"<dt class='img'>");
			sbOut.append(		getProfileImage(oUserSession.getDomainIdx(), ownerIdx));
			sbOut.append(	"</dt>");
			sbOut.append(	"<dd>");
			sbOut.append(		oUserSession.getUserName());
			sbOut.append(	"</dd>");
			sbOut.append(	"<dd>");
			sbOut.append(		addLink( stringToHTMLString(sFeedback)));
			sbOut.append(	"</dd>");
			sbOut.append(	"<dd>");
			sbOut.append(		"<i>" + DateTime.convertDateFormat(serverTime) + "</i>");
			sbOut.append(		" <input type='button' class='btn btn-mini btn-danger' value='Delete' onClick='javascript:feedback_delete("+TASK_IDX+","+feedbackIdx+");' />");
			sbOut.append(	"</dd>");
			sbOut.append("</dl></div>");
		}
		
		out.print(sbOut.toString());
		//out.print(JavaScript.write("location.replace('"+redirectUrl+"?tsk_idx="+TASK_IDX+"');"));
	} else {
		out.print(JavaScript.write("alert('피드백 등록 실패');"));
	}
%>
