<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../../../../jsp/common/include/incInit.jspf" %>
<%
    String sRedirectUrl = request.getParameter("redirectUrl");

    if (sRedirectUrl == null)
        sRedirectUrl = "";

    String sCookieLoginId = Util.getCookieValue(request, Cs.TIMECLOUD_LOGIN_EMAIL);

    if ("".equals(sCookieLoginId) == false) {
        response.sendRedirect(CONTEXT_PATH + "/jsp/login/loginAction.jsp?redirectUrl=" + sRedirectUrl);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <script type="text/javascript">

if(getBrowserType() == 'Internet Explorer') {
	alert('Internet Explorer는 지원하지 않습니다.');
	location.replace('other_browser.jsp');
}


function getBrowserType() {
	var agt = navigator.userAgent.toLowerCase();
	if (agt.indexOf("chrome") != -1) return 'Chrome'; 
	if (agt.indexOf("opera") != -1) return 'Opera'; 
	if (agt.indexOf("staroffice") != -1) return 'Star Office'; 
	if (agt.indexOf("webtv") != -1) return 'WebTV'; 
	if (agt.indexOf("beonex") != -1) return 'Beonex'; 
	if (agt.indexOf("chimera") != -1) return 'Chimera'; 
	if (agt.indexOf("netpositive") != -1) return 'NetPositive'; 
	if (agt.indexOf("phoenix") != -1) return 'Phoenix'; 
	if (agt.indexOf("firefox") != -1) return 'Firefox'; 
	if (agt.indexOf("safari") != -1) return 'Safari'; 
	if (agt.indexOf("skipstone") != -1) return 'SkipStone'; 
	if (agt.indexOf("msie") != -1) return 'Internet Explorer'; 
	if (agt.indexOf("netscape") != -1) return 'Netscape'; 
	if (agt.indexOf("mozilla/5.0") != -1) return 'Mozilla'; 
}


    </script>


    <meta charset="utf-8">
    <!-- Always force latest IE rendering engine or request Chrome Frame -->
    <meta content="IE=edge,chrome=1" http-equiv="X-UA-Compatible">
    <title>Login to Together@<%=sHostName %>
    </title>
    <link href="../../stylesheets/application.css" media="screen" rel="stylesheet" type="text/css"/>
    <!--[if lt IE 9]>
    <script src="../../javascripts/html5shiv.js" type="text/javascript"></script>
    <script src="../../javascripts/excanvas.js" type="text/javascript"></script>
    <script src="../../javascripts/iefix.js" type="text/javascript"></script>
    <link href="../../stylesheets/iefix.css" media="screen" rel="stylesheet" type="text/css"/><![endif]-->
    <meta name="viewport" content="width=device-width, maximum-scale=1, initial-scale=1, user-scalable=0">
</head>
<body class="login">


<div class="container">
    <div class="login-wrapper" style="margin-top: 120px">
        <div style="text-align: center">
            <i class="icon-magic logo-icon"></i>
        </div>

        <div id="login-manager">
            <div id="login" class="login-wrapper animated">
                <form action="/jsp/login/loginAction.jsp" method="post">
                    <div class="input-group">
                        <input type="hidden" name="redirectUrl" value="<%=sRedirectUrl%>"/>
                        <input type="hidden" name="pUserDomain" value="4"/>
                        <%--<select name="pUserDomain" class="input-transparent">--%>
                            <%--<option value="1">2Brain</option>--%>
                            <%--<option value="2">Roac</option>--%>
                            <%--<option value="3">AxisJ</option>--%>
                        <%--</select>--%>
                        <%--<input type="text" name="pUserId" required placeholder="이메일을 입력하세요" class="input-transparent" id="email" />--%>
                        <input type="text" name="pUserEmail" required placeholder="이메일을 입력하세요" class="input-transparent"
                               id="email"/>
                        <input type="password" name="pUserPwd" required placeholder="패스워드를 입력하세요"
                               class="input-transparent"/>
                    </div>
                    <button id="login-submit" type="submit" class="login-button">로그인</button>
                </form>
            </div>
            <div id="register" class="login-wrapper animated" style="display: none;">
                <form action="/jsp/join/action.jsp" method="post">
                    <div class="input-group">
                        <input type="hidden" name="domain_idx" value="4"/>
                        <%--<select name="domain_idx" class="input-transparent">--%>
                            <%--<option value="1">2Brain</option>--%>
                            <%--<option value="2">Roac</option>--%>
                            <%--<option value="3">AxisJ</option>--%>
                        <%--</select>--%>
                        <input type="text" name="user_email" placeholder="이메일" class="input-transparent"/>
                        <input type="text" name="user_name" placeholder="이름" class="input-transparent"/>
                        <input type="password" name="user_passwd" placeholder="비밀번호" class="input-transparent"/>
                        <input type="password" name="user_passwd2" placeholder="비밀번호 확인" class="input-transparent"/>
                    </div>
                    <button id="register-submit" type="submit" class="login-button">양식제출</button>
                </form>
            </div>
            <div id="forgot" class="login-wrapper animated" style="display: none;">
                <form action="/jsp/findpassword/action.jsp" method="post">
                    <input type="hidden" name="domain_idx" value="4"/>
                    <%--<select name="domain_idx" class="input-transparent">--%>
                        <%--<option value="1">2Brain</option>--%>
                        <%--<option value="2">Roac</option>--%>
                        <%--<option value="3">AxisJ</option>--%>
                    <%--</select>--%>
                    <div class="input-group">
                        <input type="text" placeholder="이메일을 입력해주세요" name="user_email" class="input-transparent"/>
                    </div>
                    <button id="forgot-submit" type="submit" class="login-button">비밀번호 찾기</button>
                </form>
            </div>
            <div class="inner-well" style="text-align: center; margin: 20px 0;">
                <a href="#" id="login-link" class="button mini rounded gray"><i class="icon-signin"></i> 로그인</a>
                <a href="#" id="register-link" class="button mini rounded gray"><i class="icon-plus"></i> 회원가입</a>
                <a href="#" id="forgot-link" class="button mini rounded gray"><i class="icon-question-sign"></i> 비밀번호 찾기</a>
            </div>
        </div>
    </div>
</div>
<script type="text/html" id="template-notification">
    <div class="notification animated fadeInLeftMiddle fast{{ item.itemClass }}">
        <div class="left">
            <div style="background-image: url({{ item.imagePath }})" class="{{ item.imageClass }}"></div>
        </div>
        <div class="right">
            <div class="inner">{{ item.text }}</div>
            <div class="time">{{ item.time }}</div>
        </div>
        <i class="icon-remove-sign hide"></i>
    </div>
</script>
<script type="text/html" id="template-notifications">
    <div class="container">
        <div class="row" id="notifications-wrapper">
            <div id="notifications" class="{{ bootstrapPositionClass }} notifications animated">
                <div id="dismiss-all" class="dismiss-all button blue">Dismiss all</div>
                <div id="content">
                    <div id="notes"></div>
                </div>
            </div>
        </div>
    </div>
</script>
<script src="../../javascripts/application.js" type="text/javascript"></script>
<script src="../../javascripts/docs.js" type="text/javascript"></script>
<script src="../../javascripts/docs_charts.js" type="text/javascript"></script>
</body>
</html>