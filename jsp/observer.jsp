<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ page import="java.util.*,java.io.*" %><%@ include file="./common/include/incInit.jspf" %><%@ include file="./common/include/incSession.jspf" %><%@ include file="./common/include/incTaskView.jspf" %><%
	_toolTabNo = 3 ;
	String repl = null ;
	Object[] param = null ;
	DataSet ds = null ;
	StringBuffer sb = new StringBuffer() ;
	if(isAll) {
		repl="AND Z.N_LIST=?" ;
		param = new Object[]{TASK_LIST} ;
		ds = QueryHandler.executeQuery("TEST_SELECT_TASK_OBSERVER_ALL", param, repl) ;
		if(ds != null) {
			int t_owner_idx = -1 ;
			String t_name = null ;
			String t_stats = "" ;
			StringBuffer li = new StringBuffer() ;
			while(ds.next()) {
				int n_owner_idx = ds.getInt(1) ;
				if(t_owner_idx < 0){
					t_owner_idx = n_owner_idx ;	// -- 최초 한번만 실행
					t_name = ds.getString(2) ;
				}
				String v_type = ds.getString(3) ;
				int n_cnt = ds.getInt(4) ;
				
				
				if( t_owner_idx != n_owner_idx ) {
					String sProfileImageSrc = getProfileImageUrl(t_owner_idx) ;
					li.append(
							Html.li(
								Html.a(Html.img_("class='media-object' src='"+sProfileImageSrc+"' width=50"),"class='pull-left'" )+
							    Html.div(
							      Html.div( t_name + Html.br_() + t_stats )
								,"class='media-body messageBody'") 
							,"class='media' ")
						);
					
					t_owner_idx = n_owner_idx ;
					t_name = ds.getString(2) ;
					t_stats = "" ;
				}
				
				t_stats += Html.Icon.get(v_type) + n_cnt + " " ;
			}
			String sProfileImageSrc = getProfileImageUrl(t_owner_idx) ;
			li.append(
					Html.li(
						Html.a(Html.img_("class='media-object' src='"+sProfileImageSrc+"' width=50"),"class='pull-left'" )+
					    Html.div(
					      Html.div( t_name + Html.br_() + t_stats )
						,"class='media-body messageBody'") 
					,"class='media' ")
				);			
			sb.append( Html.div(Html.ul(li.toString())) ) ;
		}
	}
	else {
		repl="AND Z.N_IDX=?" ;
		param = new Object[]{TASK_IDX} ;
		ds = QueryHandler.executeQuery("TEST_SELECT_TASK_OBSERVER", param, repl) ;
		String result = "" ;
		
		if(ds != null) {
			Observer observer = null ;
			while(ds.next()) {
				observer = new Observer(ds, oUserSession) ;
				sb.append( observer.get() ) ;
			} 
		}
	}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>참조자</title>
<%@ include file="./common/include/incHead.jspf" %>
<%@ include file="taskHierarchyInfo.jsp" %><%
	// -- Task Owner 확인을 해야 하므로, taskHierarchyInfo.jsp 밑에 와야 함.
	if(!isAll && oTaskHierarchy.getCurrentTask().getOwnerIdx() == oUserSession.getUserIdx() ){
		String userCombo = UserComponent.getInstance(USER_IDX,DOMAIN_IDX).getUserCheckBox() ;
		StringBuffer sbForm = new StringBuffer() ;
			sbForm.append("<form method='post' action='observerAction.jsp' class='form-inline' onSubmit='javascript:onSubmitObserver(this) ; return false;'><input type='hidden' name='tsk_idx' value='").append(TASK_IDX).append("'/>")
			.append(userCombo)
			.append("<div class='row-fluid show-grid'>")
				.append("<textarea name='pComment' placeholder='참조자에게 남기실 한마디 ..' rows=2 class='span5'></textarea>")
				.append(" <button type='submit' class='btn btn-primary'>등록</button>")
			.append("</div>")
			.append("</form>");
		sb.append(sbForm) ;
	}
%>
<script type="text/javascript">
	function observer_delete(n_task_idx, n_idx) {
		if( confirm("삭제하시겠습니까?") ){
			location.href="observerDeleteAction.jsp?tsk_idx="+n_task_idx+"&idx="+n_idx ;
		}
	}
	
	var locked = false ;
	function lock(){ if(locked)return locked; locked = true ; return false;}
	function unlock(){ locked = false ;}
	function onSubmitObserver(f) {
		if(lock())return false ;
		
		var observer = f.pObserver;
		var isSelected = false;

		for(var i=0; i < observer.length; i++) {
			if(observer[i].checked == true) {
				isSelected = true;
				break;
			}
		}
		
		if(isSelected == false) {
			alert('참조자를 선택해주세요 ..') ;
			unlock() ;
			return false ;
		}
		
		if(f.pComment.value=="") {
			alert('내용을 입력해 주세요..') ;
			f.pComment.focus() ;
			unlock() ;
			return false ;
		}
		
		f.submit() ;
	}
</script>
</head>
<body>
	<div class="row-fluid">
		<div class=span10><%@ include file="./menuGlobal.jsp" %>
			<div class="row-fluid">
				<div class='span2 vertNav'><%=getVertNav(req, oUserSession) %></div>
				<div id="wrap" class="span4">
					<div id="hierarchy" style="height:100%;"></div>
				</div>
				<div id="tool" class="span6"><%@ include file="./menuTool.jsp" %>
					<div class=contentArea><%=sb.toString()%></div>
				</div>
			</div>
		</div>	
		<%=getNotification(oUserSession, "span2 noti") %>
	</div>
</body>
</html>
<%@ include file="./common/include/incFooter.jspf" %>
<%!
class Observer {
	int n_idx = -1 ;
	int n_owner_idx = -1 ;
	int n_task_idx = -1 ;
	int n_task_owner_idx = -1 ;
	String v_desc ;
	String v_timegap ;
	String v_type ;	// -- TASK, OBSERVER
	String v_name ;
	
	UserSession sess ;
	
	public Observer(DataSet ds, UserSession sess) {
		this.n_idx = ds.getInt(1) ;	// -- type에 따라서 의미가 달라짐. type이 TASK이면 TASK IDX이고, type이 OBSERVER이면 OBSERVER IDX임
		this.n_owner_idx = ds.getInt(2) ;
		this.n_task_idx = ds.getInt(3) ;
		this.n_task_owner_idx = ds.getInt(4) ;
		this.v_desc = ds.getString(5) ;
		this.v_timegap = ds.getString(6) ;
		this.v_type = ds.getString(7) ;
		this.v_name = ds.getString(8) ;
		
		this.sess = sess ;
	}
	
	public int getOwnerIdx() {
		return n_owner_idx ;
	}
	public String getImage() {
		return getProfileImage(n_owner_idx) ;
	}
	
	public String getName() {
		return v_name ;
	}
	
	public String getTypeIcon() {
		return Html.trueString( isOwner(), Html.Icon.TASK, Html.Icon.OBSERVER ) ;
	}
	
	public String getDesc() {
		return addLink( stringToHTMLString(v_desc) ) ;
	}
	
	public String getTimegap() {
		return v_timegap ;
	}
	
	public String getComponent() {
		String component = "" ;
		if( isTaskOwner() && !isOwner() ) {	// -- my observer
			component = " <input type='button' class='btn btn-mini btn-danger' value='Delete' onClick='javascript:observer_delete("+n_task_idx+","+n_idx+");' />";
		}
		return component ;		
	}
	
	public String get() {
		StringBuffer sbOut = new StringBuffer() ;
		
		sbOut.append("<div>")
			.append("<div style='float:left'>") 
				.append("<div style='float:left'>")
				.append( getImage() )
				.append("</div>")
				.append("<div style='float:right;padding:0 0 0 10px'>")
					.append( getName() + getTypeIcon() ).append("<br />")
					.append( getDesc() )	// -- bootstrap 처리 부분에서는 특수문자에 htmlspecialchars 안써도 되네..
				.append("<br/><i>")
				.append( getTimegap() )
				.append("</i>")
				.append( getComponent() )
				.append("</div>")
			.append("</div><br style='clear:both' />") ;
		
		return sbOut.toString() ;
	}
	private boolean isTaskOwner() {
		return n_task_owner_idx == sess.getUserIdx() ;
	}
	private boolean isOwner() {
		return ("TASK".equals(v_type)) ;	
	} 
}
%>