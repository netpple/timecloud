<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ page import="java.util.*,java.io.*" %><%@ include file="./common/include/incInit.jspf" %><%@ include file="./common/include/incSession.jspf" %><%@ include file="./common/include/incTaskView.jspf" %><%!

// -- 해당 태스크에 필요한 내용을 다들고 와서 시간 순으로 다 뿌려야 돼
// -- Activity , Feedback, File, Observer

%> 

<!DOCTYPE html>
<html lang="en">
<head>
<title>태스크 홈</title>
<%@ include file="./common/include/incHead.jspf" %>
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
	
	.resizableItem{
		border:1px solid #D3D3D3;
		border-radius:5px;
		box-shadow:0px 0px 5px #888;
		padding:2px 0px 17px 0px;	
		background:#ffffff;
		margin-bottom: 10px;
	}
	.resizableItem.beSelected{background:#68adcf;color:#fff;}
	.AX_selecting{background:#CFE4EF;}
	</style>
	<!-- css block -->
	
<script type="text/javascript">

function callTaskMenu() {
	window.history.pushState(<%=TASK_IDX%>, true, location.pathname+location.search);
	$.ajax({
		type:"POST",
		url:'taskHierarchyInfo.jsp?tsk_idx='+<%=TASK_IDX%>+'&tsk_list='+<%=TASK_LIST%>,
		success:function(data){
			$("#hierarchy *").remove();
			$("#hierarchy").append(data);
		}, 
		error:function(e){
		}
	});
	$.ajax({
		type : 'post',
		async : true,
		url : "taskMenu.jsp?tsk_idx="+<%=TASK_IDX%>+"&owner_idx="+<%=oTaskHierarchy.getCurrentTask().getOwnerIdx()%>+'&tsk_list='+<%=TASK_LIST%>,
		beforeSend : function() {
		},
		success : function(data) {
			$('#taskMenu *').remove();
			$('#taskMenu').append(data);	
		},
		complete : function() {
		}
	});
}

$(document).ready(function(){ 
	$("#hierarchyResizable").bindAXResizable({
		animate: {easing:"bounceOut", duration:500},
		onChange: function(){
 			$.ajax({	
 				type:"POST",
 				url:'taskHierarchyData.jsp?tsk_idx='+int_tskIdx,
 				success:function(data){	
					if(data.trim() != -1){
						myTree.setList(JSON.parse(data.trim()));
						myTree.reloadList();
					}else{
						alert('태스크 구조 정보를 가져오는데 실패했습니다.');
					}
 				}, 
 				error:function(e){
 				}
 			});
		}
	});
	callTaskMenu();
});

$(window).bind("popstate", function(event) {
	var data = event.originalEvent.state;
    if (data=="r1"){
    	onTaskAllAction();
    }else if(data){
    	int_tskIdx = data;
    	int_tskList = -1;
    	onTaskAction(event.originalEvent.state);
    }
});

</script>
</head>
<body>
<div class="row-fluid">
	<div class='span10'><%@ include file="./menuGlobal.jsp" %>
		<div class="row-fluid">
			<div class='span2 vertNav' id='verNav'><%=getVertNav(req, oUserSession) %></div>	
				
			<div class="span4 resizableItem" id = "hierarchyResizable">
				<div style="overflow: auto;height: 100%;">
					<div id="hierarchy" >
					</div>
				</div>
			</div>
			<div class="span6">
			
				<div id="taskMenu"></div>
				<div id="taskContent"></div>
			</div>
		</div>	
	</div>
	<%=getNotification(oUserSession, "span2 noti") %>
</div>
</body>
</html>
<div id="taskModify" class="modal hide fade" tabindex="-1" role="dialog" 
	aria-labelledby="registerLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h3 id="registerLabel">태스크 수정</h3>
	</div>
	<div class="modal-body">
		<form id="frmTaskModify" class="form-horizontal" onSubmit="return false;">
			<input type="hidden" id="taskIdx" name="pTaskIdx" value=""/>
			<div class="control-group">
				<input type="text" id="taskDesc" name="pTaskDesc" class="input-xlarge" value="" placeholder="태스크를 적어주세요 .." autofocus onKeyup="if (event.keyCode == 13) onSubmit(document.forms[0]);"/>
				 수정 후 아래 "Save changes" 버튼을 눌러주세요
			</div>
		</form>		
	</div>
	<div class="modal-footer">
		<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
		<button class="btn btn-primary" onClick="javascript:onSaveChange();">Save changes</button>
	</div>
</div>
<%@ include file="./common/include/incFooter.jspf" %>