<%--
  Created by IntelliJ IDEA.
  User: netpple
  Date: 2014. 9. 27.
  Time: 오후 4:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="common/include/incInit.jspf" %>
<%@ include file="common/include/incSession.jspf" %>
<html>
<head>
    <title></title>
</head>
<body>
<div id="onlineUsers">
    <ul></ul>
</div>
<%--<%=getNotification(oUserSession, "span3 noti") %>--%>
<script src="<%=JS_PATH%>/jquery.js"></script>
<script type="text/javascript">
    $(function() {
        var WS = window['MozWebSocket'] ? MozWebSocket : WebSocket;

        var chatSocket = new WS("ws://<%=NOTIFICATION_SERVER_URL%>/noti.connect?notiSessionId=<%=notiSessionId%>");

        var receiveEvent = function(event) {
            console.log("received");
            var data = JSON.parse(event.data);
            if(data.error) {
                console.log(data.error);
                return;
            } else {
//                console.log(data);
//                return;
                if(data.userList){
                    list = data.userList;
                    console.log(data.userList);
                    $("#onlineUsers > ul li").remove();
                    for(i=0;i<list.length;i++){
                        idx = list[i];
//                        idxs = idx.split("|");
                        <%--if(idxs[1] != <%=TEAM_IDX%> || idxs[2] != <%=DOMAIN_IDX%>)continue;--%>
                        $("#onlineUsers > ul").append($("<li></li>").append($("<img />",{'src':'/repos/profile/'+idx,'class':'img-circle','width':'35px','height':'35px'})));
                    }
                    return;
                }
                //toast.push(data.ntfcMessage);
                console.log(data.ntfcMessage);

                var html = "<li class='media'>";
                html += "<a class='pull-left'>";
                html += "<img class='media-object' src='/repos/profile/"+data.ntfcSenderIdx+"'>";
                html += "</a>";
                html += "<div class='media-body messageBody'><div><a href='"+data.linkUrl+"'>"+data.ntfcMessage+"</a></div></div>";
                html += "</li>";

                $(".media-list").prepend(html);
            }
        }

        chatSocket.onmessage = receiveEvent;

        console.log(chatSocket);
    });
</script>
</body>
</html>
