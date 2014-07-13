<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %><%@ page import="java.util.HashMap"%><%@ page import="java.io.*" %>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%
	String host = oUserSession.getHost();
	_globalTabNo = 9 ;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>라이브 채팅~!!</title>
<%@ include file="./common/include/incHead.jspf" %>
<style type="text/css">
.chat_container {
	width: 700px;
	overflow-y:scroll;
	overflow-x:hidden;
	height:500px;
}

.text_input {
	width:690px;
	margin-top:20px;
}

.member {
	float:right;
	margin-right:100px;
}

/* .bubble */

.bubble {
	background-image: linear-gradient(bottom, rgb(210,244,254) 25%, rgb(149,194,253) 100%);
background-image: -o-linear-gradient(bottom, rgb(210,244,254) 25%, rgb(149,194,253) 100%);
background-image: -moz-linear-gradient(bottom, rgb(210,244,254) 25%, rgb(149,194,253) 100%);
background-image: -webkit-linear-gradient(bottom, rgb(210,244,254) 25%, rgb(149,194,253) 100%);
background-image: -ms-linear-gradient(bottom, rgb(210,244,254) 25%, rgb(149,194,253) 100%);
background-image: -webkit-gradient(
	linear,
	left bottom,
	left top,
	color-stop(0.25, rgb(210,244,254)),
	color-stop(1, rgb(149,194,253))
);
	border: solid 1px rgba(0, 0, 0, 0.5);
	/* vendor rules */
	border-radius: 20px;
	/* vendor rules */
	box-shadow: inset 0 5px 5px rgba(255, 255, 255, 0.4), 0 1px 3px rgba(0, 0, 0, 0.2);
	/* vendor rules */
	box-sizing: border-box;
	clear: both;
	float: left;
	margin-bottom: 15px;
	padding: 8px 30px 10px 15px;
	position: relative;
	text-shadow: 0 1px 1px rgba(255, 255, 255, 0.7);
	width: auto;
	max-width: 100%;
	word-wrap: break-word;
	margin-left:5px;
	
}

.bubble:before, .bubble:after {
	border-radius: 20px / 10px;
	content: '';
	display: block;
	position: absolute;
}

.bubble:before {
	border: 10px solid transparent;
	border-bottom-color: rgba(0, 0, 0, 0.5);
	bottom: 0;
	left: -7px;
	z-index: -2;
}

.bubble:after {
	border: 8px solid transparent;
	border-bottom-color: #d2f4fe;
	bottom: 1px;
	left: -5px;
}

.bubble--alt {
	background-image: linear-gradient(bottom, rgb(172,228,75) 25%, rgb(122,205,71) 100%);
background-image: -o-linear-gradient(bottom, rgb(172,228,75) 25%, rgb(122,205,71) 100%);
background-image: -moz-linear-gradient(bottom, rgb(172,228,75) 25%, rgb(122,205,71) 100%);
background-image: -webkit-linear-gradient(bottom, rgb(172,228,75) 25%, rgb(122,205,71) 100%);
background-image: -ms-linear-gradient(bottom, rgb(172,228,75) 25%, rgb(122,205,71) 100%);
background-image: -webkit-gradient(
	linear,
	left bottom,
	left top,
	color-stop(0.25, rgb(172,228,75)),
	color-stop(1, rgb(122,205,71))
);
	float: right;
	margin-right:15px;
	padding: 8px 30px;
}

.bubble--alt:before {
	border-bottom-color: rgba(0, 0, 0, 0.5);
	border-radius: 20px / 10px;
	left: auto;
	right: -7px;
}

.bubble--alt:after {
	border-bottom-color: #ace44b;
	border-radius: 20px / 10px;
	left: auto;
	right: -5px;
}
</style>
</head>
<body>
	<%@ include file="./menuGlobal.jsp" %>

<br/><br/>

<div class="member">
    <h2>Online</h2>
    <ul id="members">
    </ul>
</div>
<div id="chat_container" class="chat_container">
</div>


<textarea class="text_input" id="talk"></textarea>

<script type="text/javascript" charset="utf-8">

   $(function() {
		var WS = window['MozWebSocket'] ? MozWebSocket : WebSocket;
		
		var chatSocket = new WS("ws://cs.2brain.com:8000/connect?userid=<%=oUserSession.getUserName()%>&groupid=<%=host%>");
		var sendMessage = function() {
			chatSocket.send(JSON.stringify(
				{text: $("#talk").val()}
			));
           $("#talk").val('')
		}
		var receiveEvent = function(event) {
			var data = JSON.parse(event.data);
			if(data.error) {
				alert('Error 발생');
				return;
			} else {
				
				var message = data.message;
				var user = data.user;
				console.log(data);
				
				var container = $(".chat_container");
				
				if(user == '<%=oUserSession.getUserName()%>') {
					container.append("<div class='bubble bubble--alt'>" + message + "</div>");
				} else {
					container.append("<div class='bubble'>" + user + " : " + message + "</div>");
				}
				
				var d = document.getElementById("chat_container");
				
				console.log(d.scrollHeight);
				d.scrollTop = d.scrollHeight;
				
				$("#members").html('');
	            $(data.members).each(function() {
	                $("#members").append('<li>' + this + '</li>')
	            })
			}
		}
		var handleReturnKey = function(e) {
			if(e.charCode == 13 || e.keyCode == 13) {
				e.preventDefault();
				sendMessage();
			} 
		}
		$("#talk").keypress(handleReturnKey);  
		chatSocket.onmessage = receiveEvent;
   });
</script>
	
</body>
</html>