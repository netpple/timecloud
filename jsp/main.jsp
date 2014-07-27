<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Task List</title>
    <%@ include file="./common/include/incHead.jspf" %>
</head>
<script>
    $(document).ready(function () {
        setMyTask();
    });

    function setMyTask() {
        $.getJSON("/jsp/main/list.jsp", function (data) {
            if (data.result != <%=Cs.SUCCESS%>) {

                return false;
            }

            console.log("list=" + data.list.length);
            $(data.list).each(function () {
                console.log(this.offyn);
                if (this.offyn == "Y")desc = "<strike style='color:silver'>" + this.desc + "</strike>"
                else desc = this.desc;

                timegap = "<span style='color:gray;margin:0 0 0 10px'>" + this.timegap + "</span>"
                $("#todo").append("<li><a class='ellipsis' href='/jsp/task.jsp?tsk_idx=" + this.idx + "'>" + desc + "</a>" + timegap + "</li>");
            });

            console.log("list2=" + data.list2.length);
            if (data.list2.length > 0) {
                $(data.list2).each(function () {
                    console.log(this.offyn);
                    if (this.offyn == "Y")desc = "<strike style='color:silver'>" + this.desc + "</strike>"
                    else desc = this.desc;

                    timegap = "<span style='color:gray;margin:0 0 0 10px'>" + this.timegap + "</span>"
                    $("#command").append("<li><a class='ellipsis' href='/jsp/task.jsp?tsk_idx=" + this.idx + "'>" + desc + "</a>" + timegap + "</li>");
                });
            }
            else{
                $("#command").append("<li>등록된 데이터가 없습니다. </li>");
            }
            console.log("list3=" + data.list3.length);

            if (data.list3.length > 0) {
                $(data.list3).each(function () {
                    console.log(this.offyn);
                    if (this.offyn == "Y")desc = "<strike style='color:silver'>" + this.desc + "</strike>"
                    else desc = this.desc;

                    timegap = "<span style='color:gray;margin:0 0 0 10px'>" + this.timegap + "</span>"
                    $("#observer").append("<li><a class='ellipsis' href='/jsp/task.jsp?tsk_idx=" + this.idx + "'>" + desc + "</a>" + timegap + "</li>");
                });
            }
            else{
                $("#observer").append("<li>등록된 데이터가 없습니다. </li>");
            }
        });
    }
</script>
<body>
<div class='row-fluid'>
    <div class='span10'>
        <%@ include file="./menuGlobal.jsp" %>
        <div class='row-fluid'>
            <div class='span2 vertNav'><%=getVertNav(req, oUserSession) %>
            </div>
            <div class='span5'>
                <form id='f1' method='post' action='taskAction.jsp' class="form-inline"
                      onSubmit="onSubmit(this); return false;">
                    <input type='hidden' name='redirect' value='main.jsp'/>
                    <input type="text" id="taskRegister" name="pTaskDesc" class="input-xlarge"
                           placeholder="태스크를 적어주세요 .." autofocus
                           onKeyup="if (event.keyCode == 13) onSubmit(document.forms[0]);"/>
                    <button type="submit" class='btn btn-primary'>등록</button>
                </form>
                <%--
                 --%>
                <div>
                    <h6>할 일
                        <small><a href="javascript:onViewTaskList();">더보기</a></small>
                    </h6>
                    <ul id="todo"></ul>
                </div>
            </div>
            <div class='span5'>
                <div>
                    <h6>시킨 일
                        <small><a href="javascript:onViewChildTask();">더보기</a></small>
                    </h6>
                    <ul id="command"></ul>
                </div>
                <div>
                    <h6>CC
                        <small><a href="javascript:onViewObserverTask();">더보기</a></small>
                    </h6>
                    <ul id="observer"></ul>
                </div>
            </div>
        </div>
    </div>
    <%=getNotification(oUserSession, "span2 noti") %>
</div>
</body>
</html>
<%@ include file="./common/include/incFooter.jspf" %>