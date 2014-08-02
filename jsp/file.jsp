<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ page import="java.util.*,java.io.*" %><%@ include file="./common/include/incInit.jspf" %><%@ include file="./common/include/incSession.jspf" %><%@ include file="./common/include/incTaskView.jspf" %><%
	_toolTabNo = 2 ;
%>
<!DOCTYPE html>
<html lang="en"> 
<head>
<title>태스크 자료</title>
<%@ include file="./common/include/incHead.jspf" %>
<%@ include file="./common/include/incFileUpload.jspf" %>
<%@ include file="taskHierarchyInfo.jsp" %>
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
    
    loadFileList();	
});

function loadFileList() {
	var formId = "#fileupload";
    
    // Load existing files:
    $('#fileupload').addClass('fileupload-processing');
    $.ajax({
        // Uncomment the following to send cross-domain cookies:
        //xhrFields: {withCredentials: true},
        url: $('#fileupload').fileupload('option', 'url'),
        dataType: 'json',
        context: $('#fileupload')[0]
    }).always(function () {
        $(this).removeClass('fileupload-processing');
    }).done(function (result) {
        $(this).fileupload('option', 'done')
            .call(this, $.Event('done'), {result: result});
    });
    
    $('#fileupload').addClass('fileupload-processing');
    $.ajax({
        // Uncomment the following to send cross-domain cookies:
        //xhrFields: {withCredentials: true},
        url: '/jsp/common/fileupload/fileAction.jsp?pAction=GetFileList&tsk_idx='+taskIdx<%=Html.trueString(isAll,"+'&tsk_list="+TASK_IDX+"'")%>, 
        dataType: 'json',
        context: $('#fileupload')[0]
    }).always(function () {
        $(this).removeClass('fileupload-processing');
    }).done(function (result) {
        $(this).fileupload('option', 'done')
            .call(this, $.Event('done'), {result: result});
    });
}
	
</script>
</head>
<body>
<div class='row-fluid'>
	<div class='span8'>
        <%@ include file="./menuGlobal.jsp" %>
		<div class="row-fluid">
			<%--<div class='span2 vertNav'><%=getVertNav(req, oUserSession) %></div>--%>
			<div class='span5' id="hierarchy" style="height:100%;"></div>
			<div class='span7'><%@ include file="./menuTool.jsp" %>
				<div class='contentArea'>
			    <form id="fileupload" action="/jsp/common/fileupload/fileAction.jsp" method="POST" enctype="multipart/form-data">
			    	<input type="hidden" name="tsk_idx" value="<%=TASK_IDX %>"/>
			        <!-- Redirect browsers with JavaScript disabled to the origin page -->
			        <!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->
			        
			        <table role="presentation" class="table table-striped" border="0"><tbody class="files"></tbody></table>
			        <% if(!isAll){ %>
			        <div class="row fileupload-buttonbar" style="margin-left:5px;">
			            <div class="col-lg-7">
			                <!-- The fileinput-button span is used to style the file input field as button -->
			                <span class="btn btn-success fileinput-button">
			                    <i class="glyphicon glyphicon-plus"></i>
			                    <span class="file">Add Files</span>
			                    <input type="file" name="files[]" multiple>
			                </span>
			                <button type="submit" class="btn btn-primary start">
			                    <i class="glyphicon glyphicon-upload"></i>
			                    <span class="file">Upload All</span>
			                </button>
			                <button type="reset" class="btn btn-warning cancel">
			                    <i class="glyphicon glyphicon-ban-circle"></i>
			                    <span class="file">Cancel All</span>
			                </button>
			                <button type="button" class="btn btn-danger delete">
			                    <i class="glyphicon glyphicon-trash"></i>
			                    <span class="file">Delete All</span>
			                </button>
			                <input type="checkbox" class="toggle">
			                <!-- The loading indicator is shown during file processing -->
			                <span class="fileupload-loading"></span>
			            </div>
			            <!-- The global progress information -->
			            <div class="col-lg-5 fileupload-progress fade">
			                <!-- The global progress bar -->
			                <div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100">
			                    <div class="progress-bar progress-bar-success" style="width:0%;"></div>
			                </div>
			                <!-- The extended global progress information -->
			                <div class="progress-extended">&nbsp;</div>
			            </div>
			        </div>
			        <% } %>
			    </form>
			    </div>
				<!-- The blueimp Gallery widget -->
				<div id="blueimp-gallery" class="blueimp-gallery blueimp-gallery-controls">
				    <div class="slides"></div>
				    <h3 class="title"></h3>
				    <a class="prev">‹</a>
				    <a class="next">›</a>
				    <a class="close">×</a>
				    <a class="play-pause"></a>
				    <ol class="indicator"></ol>
				</div>
			</div>
		</div>	
	</div>
    <div class="span1"></div>
	<%=getNotification(oUserSession, "span3 noti") %>
</div>
</body>
</html>
<%@ include file="./common/include/incFooter.jspf" %>
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
</html>
<%!
class FileObject {
	private int idx;
	private int ownerIdx;
	private int taskIdx;
	private String originName;
	private String regDateTime;
	
	public FileObject(DataSet ds) {
		idx = ds.getInt(1);
		ownerIdx = ds.getInt(2);
		taskIdx = ds.getInt(3);
		originName = ds.getString(4);
		regDateTime = ds.getString(5);
	}
	
	public int getIdx() {
		return idx;
	}
	
	public int getOnwerIdx() {
		return ownerIdx;
	}
	
	public int getTaskIdx() {
		return taskIdx;
	}
	
	public String getOriginName() {
		return originName;
	}
	
	public String getRegDateTime() {
		return regDateTime;
	}
}
%>
