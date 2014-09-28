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
<%=getNotification(oUserSession, "span3 noti") %>
<script src="<%=JS_PATH%>/jquery.js"></script>
<script type="text/javascript">
    $( document ).ready(function() {
        var height = window.document.height;
        $(".noti").css("height",height);

        $( window ).resize(function() {
            var height = window.document.height;
            $(".noti").css("height",height);
        });
    });
</script>
<script type="text/javascript">
    $(function() {
        var WS = window['MozWebSocket'] ? MozWebSocket : WebSocket;

        var chatSocket = new WS("ws://<%=NOTIFICATION_SERVER_URL%>/noti.connect?sessionId=<%=sessionId%>");


        var receiveEvent = function(event) {
            console.log("received");
            var data = JSON.parse(event.data);
            if(data.error) {
                console.log(data.error);
                return;
            } else {
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

<script>
    var noti = $(".noti");
    noti.scroll(function() {
        var sc = parseInt(noti.outerHeight()) + parseInt(150);
        if ( noti[0].scrollHeight - noti.scrollTop() <= sc){
            var listCount = noti.attr('listCount');
            $.ajax({
                type : 'post',
                async : true,
                url : "notificationAction.jsp?listCount="+listCount,
                beforeSend : function() {
                    $('#notificationLoading').show().fadeIn('fast');
                },
                success : function(data) {
                    if(data != -1){
                        $('.media-list').append(data);
                        noti.attr("listCount",parseInt(listCount) + parseInt(10));
                    }
                },
                complete : function() {
                    $('#notificationLoading').fadeOut();
                }
            });
        }
    });
</script>
</body>
</html>
