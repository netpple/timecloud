<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%
	// -- String[] param = new String[]{""+ownerIdx} ;
	
	DataSet ds = QueryHandler.executeQuery("SELECT_USER_LIST") ; // -- , param) ;
	
	String listOff = "" ;
	String listOn = "" ;
	if(ds != null) {
		UserInfo user = null ;
 	 	while (ds.next()) {
 	 		user = new UserInfo(ds) ;
 	 		if( user.isOFF() ) {
 	 			listOff += "<li>"+user.get()+"</li>" ;
 	 		}
 	 		else listOn += "<li>" + user.get() +"</li>" ;
		}
 	 	
 	 	listOff = "<ul>" + listOff +"</ul>" ;
 	 	listOn = "<ul>" + listOn + "</ul>" ;
	}
	
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>User List</title>
<%@ include file="./common/include/incHead.jspf" %>
</head>
<body>
<div class="row-fluid">
	<div class='span10'><%@ include file="./menuGlobal.jsp" %>
		<div class="row-fluid">
			<div class='span2 vertNav'><%=getVertNav(req, oUserSession) %></div>
			<div class='span10 all'>
<%-- --%>
				<h6>User List</h6>
				<form id='f1' method='post' action='userAction.jsp'>
					<table>
						<caption>사용자추가</caption>
						<tr><td>아이디:</td><td><input type="text" name="pUserEmail" />@2brain.com</td></tr>
						<tr><td>이름:</td><td><input type="text" name="pUserName" /></td></tr>
						<tr><td>비밀번호 입력:</td><td><input type="password" name="pUserPasswd" /></td></tr>
						<tr><td>비밀번호 확인:</td><td><input type="password" name="pUserPasswd2" /></td></tr>
					</table>
					<button onclick="javascript:document.getElementById('f1').submit();">등록</button>
				</form>
				<div id="taskOn">
					사용자 활성
					<%=listOn %>
				</div>
				<div id="taskOff">
					사용자 비활성
					<%=listOff %>
				</div>
<%-- --%>			
			</div>
		</div>
	</div>
	<%=getNotification(oUserSession, "span2 noti") %>		
</div>
</body>
</html><%!

class UserInfo {
	String n_idx ;
	String v_email ;
	String v_name ;
	String v_reg_datetime ;
	String v_edt_datetime ;
	String c_off_yn ;
	
	public UserInfo (DataSet ds) {
		this.n_idx = ds.getString("N_IDX") ;
		this.v_email = ds.getString("V_EMAIL") ;
		this.v_name = ds.getString("V_NAME") ;
		this.c_off_yn = ds.getString("C_OFF_YN") ;
		this.v_reg_datetime = ds.getString("V_REG_DATETIME") ;
		this.v_edt_datetime = ds.getString("V_EDT_DATETIME") ;		
	}
	public boolean isOFF(){
		return "Y".equals(c_off_yn) ;
	}
	public String get() {
		// -- task_idx를 경로에 노출하지 않는 방법은?
		return "<a href='userInfo.jsp?user_idx="+n_idx+"'>"+v_email+"</a>" ;
	}
}
%>