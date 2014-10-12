<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../../jsp/common/include/incInit.jspf" %>
<%@ include file="../../jsp/common/include/incSession.jspf" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>AppCenter - Bit UP!</title>

    <!-- Bootstrap Core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- MetisMenu CSS -->
    <link href="css/plugins/metisMenu/metisMenu.min.css" rel="stylesheet">

    <!-- Timeline CSS -->
    <link href="css/plugins/timeline.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="css/sb-admin-2.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="font-awesome-4.1.0/css/font-awesome.min.css" rel="stylesheet" type="text/css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <%--<!--[if lt IE 9]>--%>
    <%--<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>--%>
    <%--<script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>--%>
    <%--<![endif]-->--%>
</head>

<body>

<div id="wrapper">

    <!-- Navigation -->
    <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0;height:50px;">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="index.jsp"><img src="/repos/<%=DOMAIN_IDX%>/ci/ci_1.png" style="height:25px"/></a>
        </div>
        <!-- /.navbar-header -->
        <ul class="nav navbar-top-links navbar-right">
            <li>
                <button type="button" class="btn btn-default navbar-btn create-task" onclick="openTaskForm()">태스크 만들기
                </button>
            </li>

            <!-- /.dropdown -->
            <li class="dropdown">
                <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                    <i class="fa fa-tasks fa-fw"></i> <i class="fa fa-caret-down"></i>
                </a>
                <ul class="dropdown-menu dropdown-tasks mytasks">
                </ul>
                <!-- /.dropdown-tasks -->
            </li>
            <!-- /.dropdown -->
            <li class="dropdown">
                <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                    <i class="fa fa-bell fa-fw"></i>  <i class="fa fa-caret-down"></i>
                </a>
                <ul class="dropdown-menu dropdown-alerts mynotis">
                </ul>
                <!-- /.dropdown-alerts -->
            </li>
            <li class="dropdown">
                <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                    <i class="fa fa-user fa-fw"></i> <i class="fa fa-caret-down"></i>
                </a>
                <ul class="dropdown-menu dropdown-user">
                    <li><a href="javascript:goProfile()"><i class="fa fa-user fa-fw"></i> User Profile</a>
                    </li>
                    <li><a href="javascript:goTeam()"><i class="fa fa-group fa-fw"></i> Team
                        Profile</a>
                    </li>
                    <li class="divider"></li>
                    <li><a href="/jsp/login/logout.jsp"><i class="fa fa-sign-out fa-fw"></i> Logout</a>
                    </li>
                </ul>
                <!-- /.dropdown-user -->
            </li>
            <!-- /.dropdown -->
            <li>
                <a href="javascript:goProfile()" class="visible-lg"
                   style="border:0;margin:0;padding:0;min-height:30px;"><%=oUserSession.getUserName()%>
                    님 <%=getProfileImage(oUserSession.getUserIdx(), 35, ImageShape.CIRCLE)%>
                </a>
            </li>
        </ul>
        <!-- /.navbar-top-links -->

        <div class="navbar-default sidebar" role="navigation">
            <div class="sidebar-nav navbar-collapse">
                <ul class="nav" id="side-menu">
                    <li class="sidebar-search">
                        <div class="input-group custom-search-form">
                            <input type="text" class="form-control search-input" placeholder="Search...">
                                <span class="input-group-btn">
                                <button class="btn btn-default search-button" type="button">
                                    <i class="fa fa-search"></i>
                                </button>
                            </span>
                        </div>
                        <!-- /input-group -->
                    </li>
                    <li>
                        <a href="javascript:goMain();"><i class="fa fa-dashboard fa-fw"></i> Dashboard</a>
                    </li>
                    <li>
                        <a href="javascript:goCalendar()"><i class="fa fa-calendar fa-fw"></i> Calendar</a>
                    </li>
                    <li>
                        <a href="javascript:goFeedback()"><i class="fa fa-comments fa-fw"></i> Feedback</a>
                    </li>
                    <li>
                        <a href="javascript:goFile()"><i class="fa fa-file-image-o fa-fw"></i> File</a>
                    </li>
                    <li>
                        <a href="#"><i class="fa fa-star fa-fw"></i> Favorites<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level left-favorite">
                        </ul>
                        <!-- /.nav-second-level -->
                    </li>
                    <%
                        if (IS_DOMAIN_ADMIN) {
                    %>
                    <li>
                        <a href="#"><i class="fa fa-dashboard fa-fw"></i> Administration<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level left-domain-admin">
                            <li>
                                <a href="javascript:setFrame('Users', '/jsp/admin/user/list.jsp');">Users</a>
                            </li>
                            <li>
                                <a href="javascript:setFrame('Teams', '/jsp/admin/team/list.jsp');">Teams</a>
                            </li>
                            <li>
                                <a href="javascript:setFrame('Tasks', '/jsp/admin/task/list.jsp');">Tasks</a>
                            </li>
                        </ul>
                    </li>
                    <%
                        }
                    %>

                    <li>
                        <img src="/repos/<%=DOMAIN_IDX%>/ci/ci_2.jpg" style="width:250px;"/>
                    </li>
                    <li><a href="#"><i class="fa fa-group fa-fw"></i> 참여 중<span class="fa arrow"> <button type="button" disabled class="btn btn-default btn-xs">0명</button></span></a>
                        <ul class="nav nav-second-level left-online-users">
                        </ul>
                    </li>
                </ul>
            </div>
            <!-- /.sidebar-collapse -->
        </div>
        <!-- /.navbar-static-side -->
    </nav>
    <%-- 본문 시작 --%>
    <div id="page-wrapper">
    </div>
    <!-- /#page-wrapper -->
    <%-- 본문 끝 --%>
</div>
<!-- /#wrapper -->

<!-- jQuery Version 1.11.0 -->
<script src="js/jquery-1.11.0.js"></script>

<!-- Bootstrap Core JavaScript -->
<script src="js/bootstrap.min.js"></script>

<!-- Metis Menu Plugin JavaScript -->
<script src="js/plugins/metisMenu/metisMenu.min.js"></script>

<!-- Custom Theme JavaScript -->
<script src="js/sb-admin-2.js"></script>

<script src="js/plugins/pklauzinski-jscroll-bc31cbb/jquery.jscroll.js"></script>
<style>
    .sidebar {
        margin-top: 53px;
    }

    /*상단 태스크만들기 버튼추가 이후 2px(safari 2px, chrome 1px) 정도 차이 나서 추가함 */
    .charactor-counter {
        color: #c0c0c0;
    }

    .custom-timeline-panel .panel-body {
        height: 371px;
        overflow-y: scroll;
    }

    /*태스크등록폼 글자카운터 스타일*/
</style>
<script>
$(document).ready(function () {
    goMain();
});
function goTask(taskidx) {
    setFrame("Task", "/jsp/task.jsp?tsk_idx=" + taskidx);
}
function goTaskAll() {
    setFrame("Task", "/jsp/taskList.jsp");
}
function goCalendar() {
    setFrame("Calendar", "/jsp/calendarAll.jsp");
    changeSidebarNav(2);
}
function goFeedback() {
    setFrame("Feedbacks", "/jsp/feedbackAll.jsp");
    changeSidebarNav(3);
}
function goFile() {
    setFrame("Files", "/jsp/fileAll.jsp");
    changeSidebarNav(4);
}
function goProfile() {
    setFrame("Profile", "/jsp/profile/view.jsp");
}
function goTeam() {
    setFrame("Team", "/jsp/team/view.jsp?team_idx=<%=TEAM_IDX%>");
}
function setFrame(title, url) {
    var page = $("#page-wrapper");
    var li = $("#t_layout li.iframe");

    $(".page-header", li).text(title);
    $("iframe", li).attr({"src": url});

    page.html(li.html());
}
function resize(ifrm) {
    var height = (ifrm).contentWindow.document.body.scrollHeight;
    if (height < 768) height = 748;
    (ifrm).height = height + 20;
}
//
function changeSidebarNav(idx) {
    $(".sidebar-nav li a").removeClass("active"); // nav 초기화
    $(".sidebar-nav li:eq(" + idx + ") a").addClass("active"); // set target nav active
}
function goMain() {
    var page = $("#page-wrapper");
    page.html($("#t_layout li.main").html());
    changeSidebarNav(1);

    setSearch()
    $.getJSON("/jsp/main/list.jsp", function (data) {
        if (data.result != <%=Cs.SUCCESS%>) {
            return false;
        }
        // 상단 dropdown - Task
        setTaskDropdown($(data.list), $(".dropdown-tasks.mytasks"));

        // 상단 dropdown - Alerts(Noti)
        setNotiDropdown($(data.notis), $(".dropdown-alerts.mynotis"));

        // 좌측메뉴 즐겨찾기
        setFavorite($(data.favorites), $(".left-favorite"));

        // 본문 집계 블럭
        $("div.huge:eq(0)").text(data.cnt[0]); // feedback
        $("div.huge:eq(1)").text(data.cnt[1]); // task
        $("div.huge:eq(2)").text(data.cnt[2]); // activities
        $("div.huge:eq(3)").text(data.cnt[3]); // files

        // 타임라인 - 최신업뎃된 도구들
        setTimeline($(data.recently), $(".timeline"));

        // 피드백
        setFeedback($(data.feedbacks), $(".chat"));
    });
}

function openTaskForm() {
    // 폼 가져오기
    var template = $("#t_form > li.basic");

    // 모달 초기화 (타이틀/본문)
    modalInit();

    var modal = $("#myModal");
    var title = $(".modal-title", modal);
    var body = $(".modal-body", modal);
    var btn_submit = $(".modal-footer .btn-primary", modal); // submit button

    // 모달 set
    title.text("태스크 만들기");
//    console.log(template.html());
    body.html(template.html());

    // 폼 조작
    btn_submit.bind("click", function () {
        var body = $("#myModal .modal-body");
        var input = $("input[type=text]", body);
        var label = $("label", body);
        if (input.val().trim().length == 0) {
            label.text("내용을 입력해주세요");
            input.focus();
            return false;
        }
        submitTaskPost($("form", body));
        return false;
    });

    body.bind("keydown", function (event) { // backspace는 keydown에서 잡히
        var input = $("input[type=text]", this);
        var len = input.val().length;
        var label = $("label", this);

        if (event.keyCode == 13) {
            event.preventDefault();
            $("#myModal .modal-footer .btn-primary").trigger('click');
            return false;
        }

        var span = $("span", this);

        if (event.keyCode == 8) { // backspace
            len -= 1; // 입력 반영이 이벤트 뒤에 계산되므로
            if (len < 0)return false;
        }
        else {
            len += 1; // 입력 반영이 이벤트 뒤에 계산되므로
        }

        var limit = 100; // 입력글자 수 제한
        if (len > limit) {
            label.text("입력제한을 초과하셨습니다.");
            return false;
        }
        label.text("");

        var span = $(".charactor-counter span", this);
        span.text(len);

    });

    // 모달 열기
    $("#myModal").modal('toggle');
}

function submitTaskPost(form) {
    $.post("/jsp/task/insert.jsp", form.serialize(), function (data) {
        prependDropdownTask(data.task);
        goTask(data.task.idx);
    }, "json").done(function () {
        var modal = $("#myModal");
        modal.modal('hide');
    }).fail().always();
}

function prependDropdownTask(data) {
    var dropdown = $(".dropdown-tasks.mytasks");
    var template = $("#t_mytasks");
    var author = "";
    console.log(data.domainyn);
    if(data.domainyn == 'Y'){
        author = "<i class='fa fa-bullhorn'></i> <font color=orange>Bit</font>UP Notification";
    }
    else {
        author = ""; //<%--=oUserSession.getUserName()--%>";
    }

    $("li:eq(0) > a", template).attr({"href": "javascript:goTask(" + data.idx + ")"});
    $("li:eq(0) strong", template).html(author)
    $("li:eq(0) em", template).text(data.timegap)
    $("li:eq(0) div:eq(1)", template).text(data.desc);
    dropdown.prepend($("li:eq(1)", template).clone());
    dropdown.prepend($("li:eq(0)", template).clone());
}

function prependDropdownNoti(data) {
    var dropdown = $(".dropdown-alerts.mynotis");
    var template = $("#t_mynotis");

//    $("li:eq(0) > a", template).attr({"href": "javascript:goTask(" + data.idx + ")"});
//    $("li:eq(0) strong", template).html(author)
//    $("li:eq(0) em", template).text(data.timegap)
//    $("li:eq(0) div:eq(1)", template).text(data.desc);
    dropdown.prepend($("li:eq(0)", template).clone());

    var li;
    if(data.ntfcType == "Feedback") li = $("li:eq(1)", template).clone();
    else if(data.ntfcType == "Task") li = $("li:eq(2)", template).clone();
    else if(data.ntfcType == "File") li = $("li:eq(3)", template).clone();
    else if(data.ntfcType == "Observer")  li = $("li:eq(4)", template).clone();
    else return false;

//    console.log(data);
    $("a",li).attr({"href": "javascript:goTask(" + data.taskIdx + ")"});
    $("div > i",li).after(data.ntfcMessage);
    if(data.timegap == null || data.timegap=="" || data.timegap=="undefined")data.timegap="방금";
    $("div span.pull-right",li).text(data.timegap);


    dropdown.prepend(li);
}

function modalInit() {
    $("#myModal .modal-title").text(""); // 제목
    $("#myModal .modal-body").text(""); // 본문(폼 영역)
    $("#myModal .modal-body").unbind("keydown"); // 이거 안해주면 bind도 누적됨. 누적된 만큼 콜백호출됨
    $("#myModal .modal-footer .btn-primary").unbind("click"); // submit button
}

function setSearch() {
    var button = $(".search-button");
    var input = $(".search-input");
    button.on("click", function () {
        search();
    });
    input.keypress(function (event) {
        if (event.which == 13) {
            event.preventDefault();
            search();
        }
    });
}

function search() {
    var input = $(".search-input");
    var q = input.val();
    if (q == "") {
        alert("검색어를 입력해주세요");
        input.focus();
        return false;
    }
    setFrame("Search", "/jsp/search.jsp?searchValue=" + q);
}


function setFavorite(list, favorite) {
    favorite.html("");
    list.each(function () {
        favorite.append($("<li></li>").append($("<a></a>", {"href": "javascript:goTask(" + this.taskidx + ")"}).text(this.desc)));
    });
}

function setTaskDropdown(list, dropdown) {
    dropdown.html("");
    var template = $("#t_mytasks");

    $(list.get().reverse()).each(function () { // my tasks
        prependDropdownTask(this);
    });
    dropdown.append($("li:eq(2)", template).clone());
}

// TODO - NOTI
function setNotiDropdown(list, dropdown) {
    dropdown.html("");
//    var template = $("#t_mynotis");

    $(list.get().reverse()).each(function(){
        prependDropdownNoti(this);
    });
//    dropdown.append($("li:eq(3)", template).clone());
}
//

function setTimeline(list, timeline) {
    var li_templ = $("#t_timeline > li");
    list.each(function (idx) {
        var li = li_templ.clone();
        if (idx % 2 == 1)li.addClass("timeline-inverted");
        else li.removeClass("timeline-inverted");

        var div = $(".timeline-badge", li);
        div.text("");
        div.removeClass(); // 초기화 - 템플릿의 아이콘 및 클래스 초기화 한다.
        div.addClass("timeline-badge");
        // tool 에 따른 아이콘 표시
        if (this.type == "ACTIVITY") {
            div.addClass("info");
            div.append($("<i></i>", {"class": "fa fa-check"}));
        }
        else if (this.type == "FILE") {
            div.addClass("danger");
            div.append($("<i></i>", {"class": "fa fa-file-image-o"}));
        }
        else if (this.type == "FEEDBACK") {
            div.addClass("success");
            div.append($("<i></i>", {"class": "fa fa-comment"}));
        }
        <%--$(".timeline-badge", li).append($("<img/>",{"src":"<%=getProfileImageUrl(3)%>","class":"img-circle"}));--%>
        // 체크박스
        // 사람이미지도 가능

        $(".timeline-title", li).text(this.type);   // title
        $(".text-muted", li).text("");// init
        $(".text-muted", li).append($("<i></i>", {"class": "fa fa-clock-o"}));
        $(".text-muted", li).append(" " + this.timegap);    // time
        $(".timeline-body > p", li).html($("<a></a>", {"href": "javascript:goTask(" + this.taskidx + ")"}).html(this.desc));    // desc
        timeline.append(li);
    });
    timeline.append($("<li></li>").append($("<a></a>", {'href': '/jsp/timeline/list.jsp?p=2', 'class': 'jscroll-next'})));

    $('.scroll_timeline').jscroll({
        loadingHtml: '<small><i class="fa fa-circle-o-notch fa-spin"></i> Loading...</small>',
        nextSelector: 'a.jscroll-next:last',
        jsonParser: function (json) {
            console.log(json);
            var list = $(json.recently);
            list.each(function (idx) {
                var li = li_templ.clone();
                if (idx % 2 == 1)li.addClass("timeline-inverted");
                else li.removeClass("timeline-inverted");

                var div = $(".timeline-badge", li);
                div.text("");
                div.removeClass(); // 초기화 - 템플릿의 아이콘 및 클래스 초기화 한다.
                div.addClass("timeline-badge");
                // tool 에 따른 아이콘 표시
                if (this.type == "ACTIVITY") {
                    div.addClass("info");
                    div.append($("<i></i>", {"class": "fa fa-check"}));
                }
                else if (this.type == "FILE") {
                    div.addClass("danger");
                    div.append($("<i></i>", {"class": "fa fa-file-image-o"}));
                }
                else if (this.type == "FEEDBACK") {
                    div.addClass("success");
                    div.append($("<i></i>", {"class": "fa fa-comment"}));
                }
                <%--$(".timeline-badge", li).append($("<img/>",{"src":"<%=getProfileImageUrl(3)%>","class":"img-circle"}));--%>
                // 체크박스
                // 사람이미지도 가능

                $(".timeline-title", li).text(this.type);   // title
                $(".text-muted", li).text("");// init
                $(".text-muted", li).append($("<i></i>", {"class": "fa fa-clock-o"}));
                $(".text-muted", li).append(" " + this.timegap);    // time
                $(".timeline-body > p", li).html($("<a></a>", {"href": "javascript:goTask(" + this.taskidx + ")"}).html(this.desc));    // desc
                timeline.append(li);
            });
        }
    });
}

function setFeedback(list, chat) {
    var li_left = $("#t_feedback > li.left");
    var li_right = $("#t_feedback > li.right");
    var li;
    list.each(function (idx) { // my tasks
        if (idx % 2 == 1) li = li_right.clone();
        else li = li_left.clone();

        var domain_feed = "";
        console.log(this.domainyn);
        if(this.domainyn == 'Y'){
            domain_feed = "<i class='fa fa-bullhorn'></i> ";
        }

        $(".chat-img > img", li).attr({"src": this.photourl, "width": "50px", "onerror": "javascript:this.src='/html/images/avatar.png'"});

        $(".chat-body .primary-font", li).html(domain_feed+this.v_feedback_owner);

        $(".text-muted", li).html("");// init
        $(".text-muted", li).append($("<i></i>", {"class": "fa fa-clock-o fa-fw"}));
        $(".text-muted", li).append(" " + this.timegap);
        $(".chat-body p", li).append($("<a></a>", {"href": "javascript:goTask(" + this.taskidx + ")"}).text(this.desc));
        chat.append(li);
    });
    chat.append($("<li></li>").append($("<a></a>", {'href': '/jsp/feedback/list.jsp?p=2', 'class': 'jscroll-next'})));

    $('.scroll').jscroll({
        loadingHtml: '<small><i class="fa fa-circle-o-notch fa-spin"></i> Loading...</small>',
        nextSelector: 'a.jscroll-next:last',
        jsonParser: function (json) {
            var list = $(json.feedbacks);
            list.each(function (idx) { // my tasks
                if (idx % 2 == 1) li = li_right.clone();
                else li = li_left.clone();
                $(".chat-img > img", li).attr({"src": this.photourl, "width": "50px", "onerror": "javascript:this.src='/html/images/avatar.png'"});
                $(".chat-body .primary-font", li).text(this.v_feedback_owner);
                $(".text-muted", li).text("");// init
                $(".text-muted", li).append($("<i></i>", {"class": "fa fa-clock-o fa-fw"}));
                $(".text-muted", li).append(" " + this.timegap);
                $(".chat-body p", li).append($("<a></a>", {"href": "javascript:goTask(" + this.taskidx + ")"}).text(this.desc));
                chat.append(li);
            });
        }
    });
}

</script>
<%--Modal--%>
<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span
                        class="sr-only">Close</span></button>
                <h4 class="modal-title" id="myModalLabel"><%--{title}--%></h4>
            </div>
            <div class="modal-body"><%--{content}--%></div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary">Save changes</button>
            </div>
        </div>
    </div>
</div>
<%--Templates--%>
<div style="display:none">
<%--Templates : Layout--%>
<ul id="t_layout">
    <li class="iframe">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header">Task</h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
        <div class="row">
            <div class="col-lg-12">
                <iframe width="100%" scrolling="no" frameborder="0" onload="javascript:resize(this)"></iframe>
            </div>
        </div>
    </li>
    <li class="main">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header">Dashboard</h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
        <div class="row">
            <div class="col-lg-3 col-md-6">
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <div class="row">
                            <div class="col-xs-3">
                                <i class="fa fa-comments fa-5x"></i>
                            </div>
                            <div class="col-xs-9 text-right">
                                <div class="huge">0</div>
                                <div>Feedback!</div>
                            </div>
                        </div>
                    </div>
                    <a href="javascript:goFeedback();">
                        <div class="panel-footer">
                            <span class="pull-left">View Details</span>
                            <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>

                            <div class="clearfix"></div>
                        </div>
                    </a>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="panel panel-green">
                    <div class="panel-heading">
                        <div class="row">
                            <div class="col-xs-3">
                                <i class="fa fa-tasks fa-5x"></i>
                            </div>
                            <div class="col-xs-9 text-right">
                                <div class="huge">0</div>
                                <div>Tasks!</div>
                            </div>
                        </div>
                    </div>
                    <a href="javascript:goTaskAll()">
                        <div class="panel-footer">
                            <span class="pull-left">View Details</span>
                            <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>

                            <div class="clearfix"></div>
                        </div>
                    </a>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="panel panel-yellow">
                    <div class="panel-heading">
                        <div class="row">
                            <div class="col-xs-3">
                                <i class="fa fa-calendar fa-5x"></i>
                            </div>
                            <div class="col-xs-9 text-right">
                                <div class="huge">0</div>
                                <div>Activity Calendar</div>
                            </div>
                        </div>
                    </div>
                    <a href="javascript:goCalendar();">
                        <div class="panel-footer">
                            <span class="pull-left">View Details</span>
                            <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>

                            <div class="clearfix"></div>
                        </div>
                    </a>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="panel panel-red">
                    <div class="panel-heading">
                        <div class="row">
                            <div class="col-xs-3">
                                <i class="fa fa-file-image-o fa-5x"></i>
                            </div>
                            <div class="col-xs-9 text-right">
                                <div class="huge">0</div>
                                <div>Files</div>
                            </div>
                        </div>
                    </div>
                    <a href="javascript:goFile();">
                        <div class="panel-footer">
                            <span class="pull-left">View Details</span>
                            <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>

                            <div class="clearfix"></div>
                        </div>
                    </a>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-8">
                <div class="custom-timeline-panel panel panel-default">
                    <div class="panel-heading">
                        <i class="fa fa-clock-o fa-fw"></i> My Timeline
                    </div>
                    <div class="panel-body scroll_timeline">
                        <ul class="timeline">
                        </ul>
                    </div>
                </div>
            </div>
            <!-- /.col-lg-8 -->
            <div class="col-lg-4">
                <div class="chat-panel panel panel-default">
                    <div class="panel-heading">
                        <i class="fa fa-comments fa-fw"></i>
                        Feedback
                    </div>
                    <div class="panel-body scroll">
                        <ul class="chat"></ul>
                    </div>
                    <div class="panel-footer">
                    </div>
                </div>
            </div>
            <!-- /.col-lg-4 -->
        </div>
    </li>
</ul>
<%--Templates : Component--%>
<ul id="t_form">
    <li class="basic">
        <form role="form">
            <div class="form-group">
                <label><i class="fa fa-info"></i> 태스크를 만들어보세요. 모든 일은 태스크에서 시작됩니다.</label>
                <input type="text" name="desc" value="" class="form-control"
                       placeholder="계획 혹은 수행할 태스크 내용을 100자 이내로 작성해 주세요">
                <% if(IS_DOMAIN_ADMIN){%><span><input type="checkbox" name="domain_yn" value="Y" /> 도메인전체공유</span><%}%>
                <span class="pull-right charactor-counter"><span>0</span>/100자</span>
            </div>
        </form>
    </li>
</ul>
<ul id="t_feedback">
    <li class="left clearfix">
            <span class="chat-img pull-left">
                <img src="" alt="User Avatar" class="img-circle"/>
            </span>

        <div class="chat-body clearfix">
            <div class="header">
                <strong class="primary-font"><%--{name}--%></strong>
                <small class="pull-right text-muted">
                    <i class="fa fa-clock-o fa-fw"></i> <%--{timegap}--%>
                </small>
            </div>
            <p><%--{desc}--%></p>
        </div>
    </li>
    <li class="right clearfix">
            <span class="chat-img pull-right">
                <img src="" alt="User Avatar" class="img-circle"/>
            </span>

        <div class="chat-body clearfix">
            <div class="header">
                <small class=" text-muted">
                    <i class="fa fa-clock-o fa-fw"></i> 13 mins ago
                </small>
                <strong class="pull-right primary-font">Bhaumik Patel</strong>
            </div>
            <p></p>
        </div>
    </li>
</ul>
<ul id="t_timeline">
    <li>
        <div class="timeline-badge"><%--nothing:gray, success:green, danger:red, info: skyblue, warning: orange--%>
        </div>
        <div class="timeline-panel">
            <div class="timeline-heading">
                <h4 class="timeline-title"></h4>

                <p>
                    <small class="text-muted"></small>
                </p>
            </div>
            <div class="timeline-body">
                <p></p>
            </div>
        </div>
    </li>
</ul>
<ul id="t_mytasks">
    <li>
        <a href="#">
            <div>
                <strong><%--{NAME}--%></strong>
                    <span class="pull-right text-muted">
                        <em><%--{TIMEGAP}--%></em>
                    </span>
            </div>
            <div><%--{DESC}--%></div>
        </a>
    </li>
    <li class="divider"></li>
    <li>
        <a class="text-center" href="javascript:goTaskAll()">
            <strong>See All Tasks</strong>
            <i class="fa fa-angle-right"></i>
        </a>
    </li>
</ul>
<ul id="t_mynotis">
    <li class="divider"></li>
    <li>
        <a href="#">
            <div>
                <i class="fa fa-comment fa-fw"></i> <%--msg--%>
                <span class="pull-right text-muted small"><%--gap--%></span>
            </div>
        </a>
    </li>
    <li>
        <a href="#">
            <div>
                <i class="fa fa-tasks fa-fw"></i> <%--msg--%>
                <span class="pull-right text-muted small"></span>
            </div>
        </a>
    </li>
    <li>
        <a href="#">
            <div>
                <i class="fa fa-file fa-fw"></i> <%--msg--%>
                <span class="pull-right text-muted small"></span>
            </div>
        </a>
    </li>
    <li>
        <a href="#">
            <div>
                <i class="fa fa-eye fa-fw"></i> <%--msg--%>
                <span class="pull-right text-muted small"></span>
            </div>
        </a>
    </li>
</ul>
</div>
<footer class="footer">
    <div class="pull-right" style="margin-right:15px;color:silver;"><i class="fa fa-cog fa-spin"></i> Powered by
        TaskTogether
    </div>
</footer>
<%-- Notification Client --%>
<script>
    $(function() {
        var WS = window['MozWebSocket'] ? MozWebSocket : WebSocket;
        //부가 정보를 보내고 싶다.
        var url = "ws://<%=NOTIFICATION_SERVER_URL%>/noti.connect?notiSessionId=<%=notiSessionId%>&userName=<%=oUserSession.getUserName()%>&teamIdx=<%=TEAM_IDX%>&domainIdx=<%=DOMAIN_IDX%>";
        url = encodeURI(url);
        var webSocket = new WS(url);
        var receiveEvent = function(event) {
            var data = JSON.parse(event.data);
            console.log(data);
            if(data.error) {
                console.log(data.error);
                return;
            } else {
                if(data.userList){
                    list = data.userList;
                    console.log(data.userList);
                    var online = $(".left-online-users");
                    console.log(online);
                    $("li",online).remove();
                    var cnt = list.length;
                    $("button",online.parent()).text(cnt+'명');
                    for(i=0;i<cnt;i++){
                        obj = list[i];
                        userIdx = obj.userIdx;
                        teamIdx = obj.teamIdx;
                        domainIdx = obj.domainIdx;
                        userName = obj.userName;
                        online.append(
                            $("<li></li>").append(
                                $("<a></a>",{href:"#"})
                                        .append($("<img />",{'src':'/repos/profile/'+userIdx,'class':'img-circle','width':'30px','height':'30px'}))
                                        .append($("<span></span>").text(" "+userName))
                            )
                        );
                    }
                    return;
                }
                toast.push(data.ntfcMessage);
                prependDropdownNoti(data);
            }
        }

        webSocket.onmessage = receiveEvent;

        console.log(webSocket);
    });
</script>
<script src="<%=AXISJ_PATH %>/lib/AXJ.js"></script>
<script src="<%=AXISJ_PATH %>/lib/AXTree.js"></script>
<script src="<%=AXISJ_PATH %>/lib/AXTab.js"></script>
<link href="<%=AXISJ_PATH %>/ui/default/AXJ.css" rel="stylesheet">
<link href="<%=AXISJ_PATH %>/ui/default/AXTree.css" rel="stylesheet">
<link href="<%=AXISJ_PATH %>/ui/default/AXTabs.css" rel="stylesheet">
</body>
</html>