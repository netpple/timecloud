<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="common/include/incInit.jspf" %>
<%@ include file="common/include/incSession.jspf" %>
<%@ include file="common/include/incTaskView.jspf" %>
<%!

    // -- 해당 태스크에 필요한 내용을 다들고 와서 시간 순으로 다 뿌려야 돼
// -- Activity , Feedback, File, Observer

%><%
    _toolTabNo = 0;

    DataSet dsTool = null;
    String qkey = "TEST_SELECT_TASK_TOOL";
    int param = TASK_IDX;
    if (isAll) {
        qkey = "TEST_SELECT_TASK_TOOL_ALL";
        param = TASK_LIST;
    }

    dsTool = QueryHandler.executeQuery(qkey, param);
    DataSet dsTaskInfo = QueryHandler.executeQuery("SELECT_TASK_INFO2", TASK_IDX);
    String isTaskOff = "";

    int taskOwner = -1;
    if (dsTaskInfo != null && dsTaskInfo.next()) {
        taskOwner = dsTaskInfo.getInt("N_OWNER_IDX");
        isTaskOff = dsTaskInfo.getString("C_OFF_YN");
    }

    StringBuffer sb = new StringBuffer();
    if (dsTool != null) {
        while (dsTool.next()) {
            Tool tool = new Tool(dsTool, oUserSession);
            sb.append(tool.get());
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>태스크 홈</title>
<%@ include file="common/include/incHead.jspf" %>
<%@ include file="common/include/incFileUpload.jspf" %>

<%@ include file="taskHierarchyInfo.jsp" %>
<style type="text/css">
    .tool {
        clear: both;
        padding-bottom: 2px;
    }

    .tool dt {
        float: left;
        width: 50px;
        height: 50px;
        margin-bottom: 3px;
    }

    .tool dd {
        margin-left: 70px;
    }

    .animated {
        -webkit-transition: height 0.2s;
        -moz-transition: height 0.2s;
        transition: height 0.2s;
    }

    /*dropzone*/
    #dropzone {
        background: #f5f5f5;
        height: 50px;
        line-height: 50px;
        text-align: center;
        font-size: 18px;
        color: #bbb;
        border-style: dotted;
        border: 1px solid inherit;
        border-color: #ddd;
        margin: 0 0 5px 0;
        padding: 0;
    }

    #dropzone.in {
        height: 200px;
        line-height: 200px;
        font-size: larger;
    }

    #dropzone.hover {
        background: #f5f5f5;
    }

    #dropzone.fade {
        -webkit-transition: all 0.3s ease-out;
        -moz-transition: all 0.3s ease-out;
        -ms-transition: all 0.3s ease-out;
        -o-transition: all 0.3s ease-out;
        transition: all 0.3s ease-out;
        opacity: 1;
    }
</style>
<%--jquery validator--%>
<script src="/html/assets/jquery.validate.min.js"></script>
<script src="/html/assets/additional-methods.min.js"></script>
<script type="text/javascript">
    var FILECNT = 0;    // global
    function feedbackSubmit() {
        FILECNT = $('tr.template-upload').length;
        $('#frmFeedback').submit();
    }

    var FILEMETA = [];
    function appendFilemeta(meta) {
        FILEMETA[FILEMETA.length] = meta;
//            $(FILEMETA).each(function(key,val){console.log(val);});
    }

    var taskIdx = "<%=TASK_IDX%>";
    $(document).ready(function () {
        // validator
        $("#frmFeedback").validate({
            messages: {
                pFeedback: "내용을 등록해주세요."
            },
            submitHandler: function (form) {
                console.log("feedback submit");
                if (FILECNT > 0) {
                    $("#fileupload button.start").click();
                    return false;
                }

                if (FILEMETA.length > 0) {
                    var metas = "";
                    $(FILEMETA).each(function (key, val) {
                        metas = metas + " \n " + val; // 공백이 없으면 안됨
                    });
                    var feedback_val = $("#pFeedback").val();
                    feedback_val = feedback_val + " \n " + metas;
                    $("#pFeedback").val(feedback_val);
                }

                form.submit();
            }
        });

        // fileupload
        $('#fileupload').fileupload({
            dropZone: $('#dropzone'), sequentialUploads: true, url: '/jsp/common/fileupload/fileAction.jsp'
//                ,limitMultiFileUploads:3
//                ,limitMultiFileUploadSize:10
            // callbacks
//                ,add: function(e,data){console.log("add");} // 업로드 처리를 직접. change 동작안함
//                ,submit: function(e,data){
//                    console.log($("tr.template-upload").length);
//                }
            , drop: function (e, data) {
                console.log("drop");
            }, change: function (e, data) {  // add를 catch하면 동작 안함
//                    console.log("change");
//                    console.log(e);
//                    console.log(data);
                console.log($("tr.template-upload").length + data.files.length);
//                    console.log(FILECNT);
            }, done: function (e, data) { // 파일단위로 동작하며, 해당파일업로드가 끝나면 콜됨
//                    console.log(e);console.log(data);
//                    console.log(data.files); // 원본정보
//                    console.log(data.result);
                $(data.result.files).each(function (key, val) {
//                        console.log(key);console.log(val);
//                        console.log(val.idx);
//                        console.log(val.name);
                    var filemeta = val.name + " file://" + val.idx;
                    appendFilemeta(filemeta);
//                        console.log(val.url);   // 대상파일 저장 URL
                });

//                    $(data.files).each(function(key,val){ // 원본정보
//                       console.log(key);console.log(val);
//                       console.log(val.name); // 원본명
//                    });
                // todo - 첨부파일 경로 뽑기

                FILECNT = FILECNT - 1;
                if (FILECNT == 0) { // 여기서 feedback submit해주면 끝 !, 문제는 validation 사전에 feedback validation을 해주려면?
                    $("#frmFeedback").submit();   // todo 임시로 막음
                }
            }
        });

        // fileupload dropzone
        $(document).bind('dragover', function (e) {
            var dropZone = $('#dropzone'),
                    timeout = window.dropZoneTimeout;
            if (!timeout) {
                dropZone.addClass('in');
            } else {
                clearTimeout(timeout);
            }
            var found = false,
                    node = e.target;
            do {
                if (node === dropZone[0]) {
                    found = true;
                    break;
                }
                node = node.parentNode;
            } while (node != null);
            if (found) {
                dropZone.addClass('hover');
            } else {
                dropZone.removeClass('hover');
            }
            window.dropZoneTimeout = setTimeout(function () {
                window.dropZoneTimeout = null;
                dropZone.removeClass('in hover');
            }, 100);
        });

        // feedback input
        $('#pFeedback').autosize();
        if (getBrowserType() == 'Safari') {
            $(".nav-tabs img").css("top", "29px");		// -- for safari rendering
        }

        $(".nav-tabs > li").click(function () {
            if ($(this).find("a").attr("href") == '#activityTab') {
                var tskIdx = $(this).find("a").attr("task_idx");
                location.href = "/jsp/calendar.jsp?tsk_idx=" + tskIdx + "&modal=Y"
            }

            $('.nav-tabs > li').find('img').attr('src', '/html/images/arrow_blank.png');
            $(this).find('img').attr('src', '/html/images/arrow_top_type2.png');
        });
    });

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

    function tool_delete(taskIdx, toolIdx, toolType) {
        if (confirm("삭제하시겠습니까?")) {
            location.href = "taskHomeAction.jsp?task_idx=" + taskIdx + "&tool_idx=" + toolIdx + "&tool_type=" + toolType;
        }
    }
</script>
</head>
<body>
<div class="row-fluid">
    <div class='span12'>
        <%@ include file="./menuGlobal.jsp" %>
        <div class="row-fluid">
            <%--<div class='span2 vertNav'><%=getVertNav(req, oUserSession) %></div>--%>
            <div class="span5" id="hierarchy" style="height:100%;"></div>
            <div class="span7">
                <%@ include file="./menuTool.jsp" %>
                <div class='contentArea'>
                    <% if (!isAll) { %>
                    <div class='row-fluid show-grid'>
                        <form id='frmFeedback' method='post' action='feedbackAction.jsp' style="margin:0;padding:0">
                            <input type='hidden' name='tsk_idx' value='<%=TASK_IDX%>'/>
                            <input type="hidden" name="redirect_url" value="task.jsp"/>
                            <textarea class='textInput animated' name='pFeedback' id="pFeedback"
                                      placeholder='피드백을 남겨주세요 ..' rows=2 required></textarea>
                        </form>
                        <div id="dropzone">Drop files here</div>
                        <form id="fileupload" action="/jsp/common/fileupload/fileAction.jsp" method="POST"
                              enctype="multipart/form-data">
                            <input type="hidden" name="tsk_idx" value="<%=TASK_IDX %>"/>
                            <table role="presentation" class="table table-striped" border="0"
                                   style="padding:0;margin:0">
                                <tbody class="files"></tbody>
                            </table>
                            <div class="fileupload-progress fade"><div class="progress-extended"></div></div>
                            <div class="form-actions fileupload-buttonbar" style="margin:0">
                                <div class="col-lg-7" align=right>
						                <span class="btn fileinput-button">
						                    <input type="file" name="files[]" multiple>
						                    <i class="icon-plus"></i> 파일첨부
						                </span>
                                    <button type="button" class="start" style="display:none"></button>
                                    <button type="button" class="btn btn-primary"
                                            onclick="javascript:feedbackSubmit();">
                                        저장하기
                                    </button>
                                    <span class="fileupload-loading"></span>
                                </div>
                            </div>
                        </form>
                    </div>
                    <% } %>
                    <%=sb.toString()%>
                </div>
            </div>
        </div>
    </div>
    <%--<div class='span1'></div>--%>
    <%--<%=getNotification(oUserSession, "span3 noti") %>--%>
</div>
</body>
</html>
<%@ include file="common/include/incFooter.jspf" %>
<script id="template-upload" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-upload fade">
        <td width="*">
            <span class="preview"></span>
        </td>
        <td>
            <p class="name">{%=file.name%}</p>
            {% if (file.error) { %}
                <div><span class="label label-danger">Error</span> {%=file.error%}</div>
            {% } %}
        </td>
       <td>
            <p class="size">{%=o.formatFileSize(file.size)%}</p>
            {% if (!o.files.error) { %}
            {% } %}
        </td>
       <td style="text-align:right;">
            {% if (!o.files.error && !i && !o.options.autoUpload) { %}
                <button class="btn btn-primary start" style='display:none'><i class="glyphicon glyphicon-upload"></i><span>Start</span></button>
            {% } %}
            {% if (!i) { %}
                <button class="btn btn-warning cancel">
                    <i class="glyphicon glyphicon-ban-circle"></i>
                    <span>Cancel</span>
                </button>
            {% } %}
        </td>
    </tr>
{% } %}




</script>

<script id="template-download" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-download fade">
		<td style="text-align:center;width:{%=file.thumbnailWidth%}px;height:{%=file.thumbnailHeight%}px">
		{% if(file.thumbnailUrl) { %}
				<a href="{%=file.url%}" title="{%=file.name%}" data-gallery ><img src="{%=file.thumbnailUrl%}" onerror="this.src='/html/images/file_icon.png'" /></a>
		{% } %}
		</td>
        <td width="*" >
            <p class="name">
                {% if (file.url) { %}
                    <a href="{%=file.url%}" title="{%=file.name%}" download="{%=file.name%}">{%=file.name%}</a>
                {% } else { %}
                    <span>{%=file.name%}</span>
                {% } %}
            </p>
            {% if (file.error) { %}
                <div><span class="label label-danger">Error</span> {%=file.error%}</div>
            {% } %}
        </td>
        <td width="200px" style="text-align:right;">
            {% if (file.deleteUrl) { %}
                <i class="icon-check"></i>
            {% } %}
        </td>
    </tr>
{% } %}




</script>
<%!
    class Tool {
        int n_idx = -1;
        int n_task_idx = -1;
        int n_owner_idx = -1;

        String v_desc;
        String v_timegap;
        String v_recent;
        String v_type; // -- FEEDBACK, FILE, ACTIVITY

        String v_owner;

        UserSession sess;

        public Tool(DataSet ds, UserSession sess) {
            this.n_idx = ds.getInt(1);
            this.n_task_idx = ds.getInt(2);
            this.n_owner_idx = ds.getInt(3);
            this.v_desc = ds.getString(4);
            this.v_timegap = ds.getString(5);
            this.v_recent = ds.getString(6);
            this.v_type = ds.getString(7);
            this.v_owner = ds.getString(9);

            this.sess = sess;
        }

        private boolean isMe() {
            return (n_owner_idx == sess.getUserIdx());
        }

        private String getActionMessage() {
            String msg = "";
            if ("ACTIVITY".equals(v_type)) {
                msg = "등록한 일정입니다." + Html.Icon.ACTIVITY;
            } else if ("FEEDBACK".equals(v_type)) {
                msg = "남긴 피드백입니다." + Html.Icon.FEEDBACK;
            } else if ("FILE".equals(v_type)) {
                msg = "파일을 업로드하였습니다." + Html.Icon.FILE;
            } else {
                msg = "";
            }

            return msg;
        }

        public String get() {
            StringBuffer sbOut = new StringBuffer();

            try {

                // -- TODO - 사용자 사진은 사용자 인식값(PK등)으로 가져올 수 있으면, DB부하 없이도 쓸 수 있어.. 그게 아니면, 썸네일 정도는 경로정보를 N_OWNER_IDX와 매핑하여 서버 메모리에 로딩 시켜 놓고 쓰는게 유리함.

                // -- String sUserInfo = new User(n_owner_idx).get();

                String component = "";
                String message = null;
                if (isMe()) {    // -- my feedback
//				component = " <input type='button' class='btn btn-mini btn-danger' value='Delete' onClick=\"javascript:tool_delete("+n_task_idx+","+n_idx+",'"+v_type+"');\" />";
                    component = "<a href=\"javascript:tool_delete(" + n_task_idx + "," + n_idx + ",'" + v_type + "');\"><i class=icon-trash></i> 삭제</a>";
                    message = "내가 " + getActionMessage();
                } else {
                    message = "<strong>" + v_owner + "</strong>님이 " + getActionMessage();
                }
                message += " " + v_timegap;


                sbOut.append("<div id='" + v_type + "_" + n_idx + "' class='tool'><dl>");
                sbOut.append("<dt class='img'>");
                sbOut.append(getProfileImage(n_owner_idx));
                sbOut.append("</dt>");
                sbOut.append("<dd><small>");
                sbOut.append(message);
                sbOut.append("</small></dd>");
                sbOut.append("<dd class=messageBody>");
                if ("FILE".equals(v_type)) {
                    sbOut.append(
                            Html.a(
                                    Html.img_(String.format("onerror=\"this.src='/repos/" + sess.getDomainIdx() + "/thumbnail/file_icon.png'\" src='/jsp/common/fileupload/fileAction.jsp?pAction=DownloadFile&pFileIdx=%d&pThumbnail=true'", n_idx))
                                            + Html.br_("") + v_desc
                                    , String.format("href='/jsp/common/fileupload/fileAction.jsp?pAction=DownloadFile&pFileIdx=%d'", n_idx))
                    );
                } else {
                    sbOut.append(addLink(stringToHTMLString(v_desc)));
                }
                sbOut.append("</dd>");
                sbOut.append("<dd>");
                sbOut.append(component);
                sbOut.append("</dd>");
                sbOut.append("</dl><hr/></div>");

            } catch (Exception e) {
            }
            return sbOut.toString();
        }
    }
%>