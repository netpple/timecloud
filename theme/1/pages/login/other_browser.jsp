<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../../../jsp/common/include/incInit.jspf" %>
<%
	String sRedirectUrl = request.getParameter("redirectUrl");

	if(sRedirectUrl == null)
		sRedirectUrl = "";
	
	String sCookieLoginId = Util.getCookieValue(request, Cs.TIMECLOUD_LOGIN_EMAIL);
	
	if("".equals(sCookieLoginId) == false) {
		response.sendRedirect(CONTEXT_PATH + "/jsp/login/loginAction.jsp?redirectUrl="+sRedirectUrl);
	}
%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript">
</script>


  <meta charset="utf-8">
  <!-- Always force latest IE rendering engine or request Chrome Frame -->
  <meta content="IE=edge,chrome=1" http-equiv="X-UA-Compatible">
  <title>Find Other Browser</title>
  <link href="../../stylesheets/application.css" media="screen" rel="stylesheet" type="text/css" />
  <!--[if lt IE 9]>
<script src="../../javascripts/html5shiv.js" type="text/javascript"></script><script src="../../javascripts/excanvas.js" type="text/javascript"></script><script src="../../javascripts/iefix.js" type="text/javascript"></script><link href="../../stylesheets/iefix.css" media="screen" rel="stylesheet" type="text/css" /><![endif]-->
  <meta name="viewport" content="width=device-width, maximum-scale=1, initial-scale=1, user-scalable=0">
</head>
<body class="login">

<div class="container">
  <div class="login-wrapper" style="margin-top: 120px">
    <div style="text-align: center">
      <i class="icon-magic logo-icon"></i>
    </div>

      	<div style="line-height:25px; font-size:25px; color:white;">
			Google Chrome : <a href="http://www.google.co.kr/intl/ko/chrome/">http://www.google.co.kr/intl/ko/chrome/</a><br/><br/>
			Apple Safari : <a href="http://www.apple.com/kr/safari/">http://www.apple.com/kr/safari/</a><br/><br/>
			Mozilla Firefox : <a href="http://www.mozilla.org/ko/firefox/new/">http://www.mozilla.org/ko/firefox/new/</a><br/><br/>
		</div>
  </div>
</div>

</body>
</html>