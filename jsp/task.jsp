<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common/include/incInit.jspf" %><%@ include file="common/include/incSession.jspf" %><%@ include file="common/include/incTaskView.jspf" %><%!

// -- 해당 태스크에 필요한 내용을 다들고 와서 시간 순으로 다 뿌려야 돼
// -- Activity , Feedback, File, Observer

%><%
	_toolTabNo = 0 ;

	DataSet dsTool = null ;
	String qkey = "TEST_SELECT_TASK_TOOL" ;
	int param = TASK_IDX ;
	if( isAll ){
		qkey = "TEST_SELECT_TASK_TOOL_ALL" ;
		param = TASK_LIST ;
	}

	dsTool = QueryHandler.executeQuery(qkey, param ) ;
	DataSet dsTaskInfo = QueryHandler.executeQuery("SELECT_TASK_INFO2", TASK_IDX);
	String isTaskOff = "";

	int taskOwner = -1;
	if(dsTaskInfo != null && dsTaskInfo.next()) {
		taskOwner = dsTaskInfo.getInt("N_OWNER_IDX");
		isTaskOff = dsTaskInfo.getString("C_OFF_YN");
	}

	StringBuffer sb = new StringBuffer();
	if(dsTool != null) {
		while(dsTool.next()) {
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
		clear:both;
		padding-bottom:2px;
	}

	.tool dt {
		float:left;
		width:50px;
		height:50px;
		margin-bottom:3px;
	}
	.tool dd {
		margin-left:70px;
	}

	.animated {
		-webkit-transition: height 0.2s;
		-moz-transition: height 0.2s;
		transition: height 0.2s;
	}
</style>
<script type="text/javascript">
var taskIdx = "<%=TASK_IDX%>";
$(document).ready(function(){
    // Initialize the jQuery File Upload widget:
    $('#fileupload').fileupload({
        // Uncomment the following to send cross-domain cookies:
        //xhrFields: {withCredentials: true},
        url: '/jsp/common/fileupload/fileAction.jsp'
    });

    // Enable iframe cross-domain access via redirect option:
    $('#fileupload').fileupload(
        'option',
        'redirect',
        window.location.href.replace(
            /\/[^\/]*$/,
            '/cors/result.html?%s'
        )
    );

    $('#pFeedback').autosize();

    if(getBrowserType() == 'Safari') {
    	$(".nav-tabs img").css("top","29px");		// -- for safari rendering
    }

    $(".nav-tabs > li" ).click(function() {
    	if($(this).find("a").attr("href") == '#activityTab') {
    		var tskIdx = $(this).find("a").attr("task_idx");
    		location.href="/jsp/calendar.jsp?tsk_idx="+ tskIdx +"&modal=Y"
    	}

    	$('.nav-tabs > li').find('img').attr('src','/html/images/arrow_blank.png');
    	$(this).find('img').attr('src','/html/images/arrow_top_type2.png');
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
	if(confirm("삭제하시겠습니까?")) {
		location.href = "taskHomeAction.jsp?task_idx="+taskIdx+"&tool_idx="+toolIdx+"&tool_type="+toolType;
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
			<div class="span7"><%@ include file="./menuTool.jsp"%>
				<%-- Contents Editor Starter--%>
				<% if(!isAll) { %>
				<div class="tabbable editorArea"> <!-- Only required for left/right tabs -->
					<ul class="nav nav-tabs">
						<%if(taskOwner == oUserSession.getUserIdx() && "N".equals(isTaskOff)) { %>
							<li><img class="arrow" src="/html/images/arrow_blank.png"/><a href="#activityTab" task_idx="<%=TASK_IDX%>" data-toggle="tab"><%=Html.Icon.TASK+Html.small("일정 등록") %></a></li>
							<li class="active" ><img class="arrow" src="/html/images/arrow_top_type2.png"><a href="#tab1" data-toggle="tab"><%=Html.Icon.FEEDBACK+Html.small("피드백 남기기") %> </a></li>
							<li><img class="arrow" src="/html/images/arrow_blank.png"><a href="#tab2" data-toggle="tab"><%=Html.Icon.FILE+Html.small("자료 올리기") %> </a></li>
						<%} else { %>
							<li class="active" ><img class="arrow" src="/html/images/arrow_top_type2.png"><a href="#tab1" data-toggle="tab"><%=Html.Icon.FEEDBACK+Html.small("피드백 남기기") %> </a></li>
							<li><img class="arrow" src="/html/images/arrow_blank.png"><a href="#tab2" data-toggle="tab"><%=Html.Icon.FILE+Html.small("자료 올리기") %> </a></li>
						<%} %>
					</ul>
					<div class="tab-content">
						<div class="tab-pane active inputContainer" id="tab1">
							<form method='post' action='feedbackAction.jsp' class='form-inline' onSubmit='javascript:onSubmitFeedback(this) ; return false;'>
								<input type='hidden' name='tsk_idx' value='<%=TASK_IDX%>'/>
								<input type="hidden" name="redirect_url" value="task.jsp"/>
								<div class='row-fluid show-grid'>
									<textarea class='textInput animated' name='pFeedback' id="pFeedback" placeholder='피드백을 남겨주세요 ..' rows=2></textarea>
								</div>
								<div align=right style='background:#f3f3f3'><button style="align:right" type='submit' class='btn btn-primary'>등록</button></div>
							</form>
						</div>
					    <div class="tab-pane inputContainer" id="tab2">
							<form id="fileupload" action="/jsp/common/fileupload/fileAction.jsp" method="POST" enctype="multipart/form-data">
						    	<input type="hidden" name="tsk_idx" value="<%=TASK_IDX %>"/>
						        <!-- Redirect browsers with JavaScript disabled to the origin page -->
						        <!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->
						        <table role="presentation" class="table table-striped" border="0" style="padding:0;margin:0"><tbody class="files"></tbody></table>
						        <div class="row fileupload-buttonbar" style="margin-left:5px;">
						            <!-- The global progress information -->
						            <div class="col-lg-5 fileupload-progress fade">
						                <!-- The global progress bar -->
						                <div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100">
						                    <div class="progress-bar progress-bar-success" style="width:0%;"></div>
						                </div>
						                <!-- The extended global progress information -->
						                <div class="progress-extended">&nbsp;</div>
						            </div>
						            <div class="col-lg-7" align=right>
						                <!-- The fileinput-button span is used to style the file input field as button -->
						                <span class="btn btn-primary fileinput-button">
						                    <input type="file" name="files[]" multiple>
						                    <i class="icon-white icon-plus"></i> add
						                </span>
						                <button type="submit" class="btn start">
						                    <i class="icon-upload"></i> upload
						                </button>
						                <button type="reset" class="btn cancel">
						                    <i class="icon-ban-circle"></i> cancel
						                </button>
						                <button type="button" class="btn delete">
						                    <i class="icon-trash"></i> delete
						                </button>
						                <input type="checkbox" class="toggle">
						                <!-- The loading indicator is shown during file processing -->
						                <span class="fileupload-loading"></span>
						            </div>
						        </div>
						    </form>
						</div>
					</div>
				</div>
				<% } %>
				<%-- Contents Editor End --%>
				<div class='contentArea'><%=sb.toString()%></div>
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
       <td width="200px">
            <p class="size">{%=o.formatFileSize(file.size)%}</p>
            {% if (!o.files.error) { %}
                <div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0"><div class="progress-bar progress-bar-success" style="width:0%;"></div></div>
            {% } %}
        </td>
       <td width="200px" style="text-align:right;">
            {% if (!o.files.error && !i && !o.options.autoUpload) { %}
                <button class="btn btn-primary start">
                    <i class="glyphicon glyphicon-upload"></i>
                    <span>Start</span>
                </button>
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
				<a href="{%=file.url%}" title="{%=file.name%}" data-gallery ><img src="{%=file.thumbnailUrl%}" /></a>
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
<!--
		<td>
            <p class="size">{%=o.formatFileSize(file.size)%}</p>
        </td>
-->
        <td width="200px" style="text-align:right;">
            {% if (file.deleteUrl) { %}
                <button class="btn btn-danger delete" data-type="{%=file.deleteType%}" data-url="{%=file.deleteUrl%}"{% if (file.deleteWithCredentials) { %} data-xhr-fields='{"withCredentials":true}'{% } %}>
                    <i class="glyphicon glyphicon-trash"></i>
                    <span>Delete</span>
                </button>
                <input type="checkbox" name="delete" value="1" class="toggle">
            {% } %}
        </td>
<!--
		<td width="200px" style="text-align:right;"> 
		{% if(file.thumbnailUrl) { %}
			<a href="{%=file.url%}" title="{%=file.name%}" data-gallery class="btn btn-primary">Preview</a>
		{% } %}</td>
-->
    </tr>
{% } %}
</script>
<%!
class Tool {
	int n_idx = -1 ;
	int n_task_idx = -1 ;
	int n_owner_idx = -1 ;

	String v_desc ;
	String v_timegap ;
	String v_recent ;
	String v_type ; // -- FEEDBACK, FILE, ACTIVITY

	String v_owner ;

	UserSession sess ;

	public Tool (DataSet ds, UserSession sess) {
		this.n_idx = ds.getInt(1) ;
		this.n_task_idx = ds.getInt(2) ;
		this.n_owner_idx = ds.getInt(3) ;
		this.v_desc = ds.getString(4) ;
		this.v_timegap = ds.getString(5) ;
		this.v_recent = ds.getString(6) ;
		this.v_type = ds.getString(7) ;
		this.v_owner = ds.getString(9) ;

		this.sess = sess ;
	}

	private boolean isMe() {
		return (n_owner_idx == sess.getUserIdx()) ;
	}

	private String getActionMessage() {
		String msg = "" ;
		if("ACTIVITY".equals(v_type)) {
			msg = "등록한 일정입니다."+Html.Icon.ACTIVITY ;
		}
		else if("FEEDBACK".equals(v_type)) {
			msg = "남긴 피드백입니다."+Html.Icon.FEEDBACK ;
		}
		else if("FILE".equals(v_type)) {
			msg = "파일을 업로드하였습니다."+Html.Icon.FILE ;
		}
		else {
			msg = "" ;
		}

		return msg ;
	}

	public String get() {
		StringBuffer sbOut = new StringBuffer() ;

		try {

			// -- TODO - 사용자 사진은 사용자 인식값(PK등)으로 가져올 수 있으면, DB부하 없이도 쓸 수 있어.. 그게 아니면, 썸네일 정도는 경로정보를 N_OWNER_IDX와 매핑하여 서버 메모리에 로딩 시켜 놓고 쓰는게 유리함.

			// -- String sUserInfo = new User(n_owner_idx).get();

			String component = "" ;
			String message = null ;
			if(isMe()) {	// -- my feedback
//				component = " <input type='button' class='btn btn-mini btn-danger' value='Delete' onClick=\"javascript:tool_delete("+n_task_idx+","+n_idx+",'"+v_type+"');\" />";
                component = "<a href=\"javascript:tool_delete(\"+n_task_idx+\",\"+n_idx+\",'\"+v_type+\"');\"><i class=icon-trash></i> 삭제</a>";
				message = "내가 " + getActionMessage() ;
			}
			else {
				message = "<strong>"+v_owner + "</strong>님이 " + getActionMessage() ;
			}
			message += " " + v_timegap ;


			sbOut.append("<div id='"+v_type+"_"+n_idx+"' class='tool'><dl>");
			sbOut.append(	"<dt class='img'>");
			sbOut.append(		getProfileImage(n_owner_idx));
			sbOut.append(	"</dt>");
			sbOut.append(	"<dd><small>");
			sbOut.append(		message );
			sbOut.append(	"</small></dd>");
			sbOut.append(	"<dd class=messageBody>");
			if("FILE".equals(v_type)) {
				sbOut.append(
					Html.a(
						Html.img_(String.format( "onerror=\"this.src='/repos/"+sess.getDomainIdx()+"/thumbnail/file_icon.png'\" src='/jsp/common/fileupload/fileAction.jsp?pAction=DownloadFile&pFileIdx=%d&pThumbnail=true'",n_idx ) )
						+ Html.br_("") + v_desc
					, String.format("href='/jsp/common/fileupload/fileAction.jsp?pAction=DownloadFile&pFileIdx=%d'",n_idx) )
				) ;
			}
			else {
				sbOut.append( addLink( stringToHTMLString(v_desc) ) );
			}
			sbOut.append(	"</dd>");
			sbOut.append(	"<dd>");
			sbOut.append( component );
			sbOut.append(	"</dd>");
			sbOut.append("</dl></div>");

		} catch (Exception e) {}
		return sbOut.toString() ;
	}
}
%>