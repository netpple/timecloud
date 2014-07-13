<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %>
<%

	String PROFILE_IMAGE_TYPE = "0001"; 

	String pUserIdx = req.getParam("user_idx", ""+oUserSession.getUserIdx()) ;
	DataSet ds = QueryHandler.executeQuery("SELECT_USER_INFO", new String[] { pUserIdx }) ;
	UserInfo user = null ;
	if(ds != null) {
 	 	if(ds.next()) {
 	 		user = new UserInfo(ds) ;
		}
	}
	
	if(user == null) {
		out.println("Fail to access .") ;
		return ;
	}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>User List</title>
<%@ include file="./common/include/incHead.jspf" %>
<%@ include file="./common/include/incFileUpload.jspf" %>

<script type="text/javascript">
$(document).ready(function() {
    $('#fileupload').fileupload();
});
</script>
</head>
<body>
<div class="row-fluid">
	<div class='span10'><%@ include file="./menuGlobal.jsp" %>
		<div class="row-fluid">
			<div class='span2 vertNav'><%=getVertNav(req, oUserSession) %></div>
			<div class='span10 all'>
<%-- --%>
				<h6>User Info</h6>
				<form id='f1' method='post' action='userAction.jsp'>
				<input type='hidden' name='pUserIdx' value='<%=pUserIdx%>'/>
				<table>
					<tr>
						<td>이메일:</td>
						<td><%=user.getEmail()%></td>
					</tr>
					<tr>
						<td>이름:</td>
						<td><input type="text" name="pUserName" value="<%=user.getName()%>" /></td>
					</tr>
					<tr>
						<td>사진:</td>
						<td><%=getProfileImage(oUserSession.getDomainIdx(), Integer.parseInt(pUserIdx)) %></td>
					</tr>
					<tr><td>연락처:</td><td><input type="text" name="pTel" value="<%=user.getTel()%>"/></td></tr>
					<tr><td>알람 이메일:</td><td><input type="text" name="pNotiEmail" value="<%=user.getNotiEmail()%>" placeholder="예) dlstj3039@gmail.com"/><br/>
					안드로이드폰의 경우 구글 계정을 입력하시고,<br/>
					아이폰의 경우 Gmail앱 설치 후 Gmail 계정을 입력하시면 <br/>
					가장 빠르게 태스크투게더의 알람을 받을 수 있습니다.
					
					</td></tr>
					<tr><td>현재 비밀번호:</td><td><input type="password" name="pUserPasswdNow" /></td></tr>
					<tr><td>변경할 비밀번호 입력:</td><td><input type="password" name="pUserPasswd" /></td></tr>
					<tr><td>변경할 비밀번호 확인:</td><td><input type="password" name="pUserPasswd2" /></td></tr>
					<%if(oUserSession.getUserEmail().equals("sykim@2brain.com") || oUserSession.getUserEmail().equals("ishwang@2brain.com") || oUserSession.getUserEmail().equals("david@2brain.com")) { %>
						<tr><td>함께 일하는사람 : </td><td><input type="hidden" name="pPartnerControl" value="Y"/><%=getUserCombo(pUserIdx) %></td></tr>
					<%} %>
					<%--
					<tr>
						<td>이미지</td>
						<td><input type="file" name="profileImage"/></td>
					</tr>
					 --%>
					</table>
					<div>
						<button onclick="javascript:document.getElementById('f1').submit();">수정</button>
					</div>
				</form>

<%-- --%>			
			</div>
		</div>
	</div>
	<%=getNotification(oUserSession, "span2 noti") %>		
</div>
</body>
</html><%!

class UserInfo {	// -- TODO - IncInit의 User와 충돌 
	String n_idx ;
	String v_email ;
	String v_name ;
	String v_reg_datetime ;
	String v_edt_datetime ;
	String c_off_yn ;
	String n_profile_image_idx;
	String v_tel;
	String v_noti_email;
	
	public UserInfo (DataSet ds) {
		this.n_idx = ds.getString("N_IDX") ;
		this.v_email = ds.getString("V_EMAIL") ;
		this.v_name = ds.getString("V_NAME") ;
		this.c_off_yn = ds.getString("C_OFF_YN") ;
		this.v_reg_datetime = ds.getString("V_REG_DATETIME") ;
		this.v_edt_datetime = ds.getString("V_EDT_DATETIME") ;
		this.v_tel = ds.getString("V_TEL");
		this.v_noti_email = ds.getString("V_NOTI_EMAIL");
	}
	public boolean isOFF(){
		return "Y".equals(c_off_yn) ;
	}
	public String getEmail() {
		return v_email ;
	}
	public String getName() {
		return v_name ;
	}
	public String get() {
		// -- task_idx를 경로에 노출하지 않는 방법은?
		return "<a href='userInfo.jsp?user_idx="+n_idx+"'>"+v_email+"</a>" ;
	}
	
	public String getTel() {
		return v_tel;
	}
	
	public String getProfileImageIdx() {
		return n_profile_image_idx;
	}
	
	public String getProfileImage() {
		if(n_profile_image_idx == null || n_profile_image_idx.equals("")) {
			return "";
		} else {
			return String.format("<img src='/jsp/common/fileupload/fileAction.jsp?pAction=GetThumbNail&pFileIdx=%s'/>",n_profile_image_idx);
		}
	}
	
	public String getNotiEmail() {
		return v_noti_email;
	}
}

class ObserverUser {
	String n_idx ;
	String v_email ;
	String v_name ;
	
	public ObserverUser (DataSet ds) {
		this.n_idx = ds.getString("N_IDX") ;
		this.v_email = ds.getString("V_EMAIL") ;
		this.v_name = ds.getString("V_NAME") ;
	}

	public String get(boolean isChecked) {
		// -- task_idx를 경로에 노출하지 않는 방법은?
				
		String value = "<label class='checkbox inline'><input name='pObserver' type='checkbox' value='"+n_idx+"' id='inlineCheckbox1'/>"+ v_name+  " </label>";		
		
		if(isChecked) {
			value = "<label class='checkbox inline'><input name='pObserver' type='checkbox' checked value='"+n_idx+"' id='inlineCheckbox1'/>"+ v_name+  " </label>";
		}
				
		return  value;
		//return "<option value='"+n_idx+"'>"+v_name+"("+v_email+")</option>" ;
	}
	
}

public String getUserCombo(String usrIdx) {
	DataSet dsUsers = QueryHandler.executeQuery("SELECT_USER_LIST2", usrIdx) ;
	DataSet dsPartner = QueryHandler.executeQuery("SELECT_USER_LIST4", usrIdx) ;
	
	ArrayList<ObserverUser> partner = new ArrayList<ObserverUser>();
	
	if(dsPartner != null) {
		while(dsPartner.next()) {
			partner.add(new ObserverUser(dsPartner));	
		}
	}
	
	StringBuffer combo = new StringBuffer() ;
	combo.append("<div class='control-group'>")
			.append(	"<div class='controls'>");
			String userList = "";
			
			if(dsUsers != null) {
				ObserverUser user = null ;
		 	 	while (dsUsers.next()) {
		 	 		user = new ObserverUser(dsUsers) ;
		 	 		
		 	 		boolean isChecked = false;
		 	 		
		 	 		for(ObserverUser _user : partner) {
		 	 			if(user.n_idx.equals(_user.n_idx)) {
		 	 				isChecked = true; 
		 	 				break;
		 	 			}
		 	 		}
		 	 		
		 	 		userList += user.get(isChecked) ;
				}
		 	 	dsUsers = null ;
			}
			combo.append(userList)
			
			.append(	"</div>")
			.append("</div>") ;
	return combo.toString() ;
}
%>