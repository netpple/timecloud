<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ page import="java.util.*,java.io.*" %><%@ include file="./common/include/incInit.jspf" %><%@ include file="./common/include/incSession.jspf" %><%@ include file="./common/include/incTaskView.jspf" %>
<%
	_toolTabNo = 2 ;
	
	DataSet dsFeedback = QueryHandler.executeQuery("SELECT_FEEDBACK_LIST", TASK_IDX ) ;

	StringBuffer sb = new StringBuffer();
	
	if(dsFeedback != null) {
		while(dsFeedback.next()) {
			Feedback feedback = new Feedback(dsFeedback, oUserSession);
			sb.append(feedback.get());
		}
	}
	
	
	
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>피드백</title>
<%@ include file="./common/include/incHead.jspf" %>
<%@ include file="taskHierarchyInfo.jsp" %>
<script type="text/javascript">
	function feedback_delete(n_task_idx, n_idx) {
		if( confirm("삭제하시겠습니까?") ){
			location.href="feedbackDeleteAction.jsp?tsk_idx="+n_task_idx+"&idx="+n_idx ;
		}
	}
	
	var locked = false ;
	function lock(){ if(locked)return locked; locked = true ; return false;}
	function unlock(){ locked = false ;}
	function onSubmitFeedback(f) {
		if(lock())return false ;
		if(f.pFeedback.value=="") {
			alert('내용을 입력해 주세요..') ;
			f.pFeedback.focus() ;
			unlock() ;
			return false ;
		}
		f.submit() ;
	}
</script>
<style type="text/css">
	.feedback dt {
		float:left;
		width:70px;
		margin:0px;
	}
	.feedback dd {
		margin-left:70px;
	}

</style>
</head>
<body>
<div class="row-fluid">
	<div class="span9"><%@ include file="./menuGlobal.jsp" %>
		<div class="row-fluid">
			<div class='span4' id="hierarchy" style="height:100%;"></div>
			<div class='span8' id="feedback"><%@ include file="./menuTool.jsp" %>
				<div style="clear:both;">
					<form method='post' action='feedbackAction.jsp' class='form-inline' onSubmit='javascript:onSubmitFeedback(this) ; return false;'><input type='hidden' name='tsk_idx' value='<%=TASK_IDX%>'/>
						<div class='row-fluid show-grid'>
							<textarea name='pFeedback' placeholder='피드백을 남겨주세요 ..' rows=7 class='span8'></textarea>
							<button type='submit' class='btn btn-primary'>등록</button>
						</div>
					</form>
				</div>
				<%=sb.toString()%>
			</div>
		</div>
	</div>
	<%=getNotification(oUserSession, "span3 noti") %>
</div>
</body>
</html>
<%@ include file="./common/include/incFooter.jspf" %>
<%!
class Feedback {
	int n_idx = -1 ;
	int n_owner_idx = -1 ;
	int n_task_idx = -1 ;
	String v_desc ;
	String v_reg_datetime ;
	String v_task_desc ;
	int n_task_owner = -1 ;
	String v_feedback_owner ;
	UserSession sess ;
	
	public Feedback(DataSet ds, UserSession sess) {
		this.n_idx = ds.getInt(1) ;
		this.n_owner_idx = ds.getInt(2) ;
		this.n_task_idx = ds.getInt(3) ;
		this.v_desc = ds.getString(4) ;
		this.v_reg_datetime = ds.getString(5) ;
		this.v_task_desc = ds.getString(6) ;
		this.n_task_owner = ds.getInt(7) ;
		this.v_feedback_owner = ds.getString(8) ;
		
		this.sess = sess ;
	}
	
	public int getTaskIdx() {
		return n_task_idx ;
	}
	
	public String get() {
		StringBuffer sbOut = new StringBuffer() ;

		try {
			
			// -- TODO - 사용자 사진은 사용자 인식값(PK등)으로 가져올 수 있으면, DB부하 없이도 쓸 수 있어.. 그게 아니면, 썸네일 정도는 경로정보를 N_OWNER_IDX와 매핑하여 서버 메모리에 로딩 시켜 놓고 쓰는게 유리함.
			
			// -- String sUserInfo = new User(n_owner_idx).get();
			
			String component = "" ;
			if(n_owner_idx == sess.getUserIdx()) {	// -- my feedback
				component = " <input type='button' class='btn btn-mini btn-danger' value='Delete' onClick='javascript:feedback_delete("+n_task_idx+","+n_idx+");' />";
			}
			
			sbOut.append("<div class='feedback'><dl>");
			sbOut.append(	"<dt class='img'>");
			sbOut.append(		getProfileImage(sess.getDomainIdx(), n_owner_idx));
			sbOut.append(	"</dt>");
			sbOut.append(	"<dd>");
			sbOut.append(		v_feedback_owner);
			sbOut.append(	"</dd>");
			sbOut.append(	"<dd class=messageBody>");
			sbOut.append(		addLink( stringToHTMLString(v_desc)));
			sbOut.append(	"</dd>");
			sbOut.append(	"<dd>");
			sbOut.append(		"<i>" + DateTime.convertDateFormat(v_reg_datetime) + "</i>" + component);
			sbOut.append(	"</dd>");
			sbOut.append("</dl></div>");
			
		} catch (Exception e) {}
		return sbOut.toString() ;
	}
}
%>