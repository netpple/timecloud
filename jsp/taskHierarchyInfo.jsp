<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
function onTaskHideControl(idx, control) {
	$.ajax({	
		type:"GET",
		url:"/jsp/taskHideAction.jsp?tsk_idx="+idx+"&control="+control,	
		data:null,	
		success:function(args){	
			location.reload(true);
		}, 
		error:function(e){
		}
	});
}

var myTree = new AXTree();
var fnObj = {
	pageStart: function(){
		fnObj.tree1();
	},
	tree1: function(){

		myTree.setConfig({
			targetID : "hierarchy",
			theme: "AXTree_none",
			iconWidth:1,
			height:"auto",
			indentRatio:1,
			showConnectionLine:true,
			xscroll:false,
			reserveKeys:{
				parentHashKey:"pHash", // 부모 트리 포지션
				hashKey:"hash", // 트리 포지션
				openKey:"open", // 확장여부
				subTree:"subTree", // 자식개체키
				displayKey:"display" // 표시여부
			},
			relation:{
				parentKey:"pno",
				childKey:"no"
			},				
			colGroup: [
				{key:"no", label:"번호", width:"100", align:"center", display:false},
				{key:"nodeName", label:"제목", width:"100%", align:"left", indent:true,
					getIconClass: function(){
						var iconName = "file";
						if(this.item.type) iconName = this.item.type;
						return iconName;
					},
					formsatter:function(){
						return this.item.nodeName;
					}
				},
				{key:"writer", label:"작성자", width:"100", align:"center", display:false}
			],
			body : {
				onclick:function(idx, item) {
					if(item.no=='r1') {
						onTaskAllAction() ;
					}
					else onTaskAction(item.no);
				},
				addClass: function(){
					<%
					if(TASK_LIST>0){
						out.println( "if(this.item.no=='r1') return 'taskHierarchySelected';" ) ;
					}
					else {
						out.println( String.format("if(this.item.no=='%d') return 'taskHierarchySelected' ; ",TASK_IDX) ) ;
					}
					%>
				}
			},
			contextMenu: {
				theme:"AXContextMenu", // 선택항목
				width:"140", // 선택항목
				menu:[
				    {isOpen:true, label:"액티비티/할당", className:"plus", onclick:function(){location.href="/jsp/calendar.jsp?tsk_idx="+ this.sendObj.no +"&modal=Y"}},
				    <%--
					--%>
				    {isOpen:true, label:"태스크 수정", className:"minus", onclick:function(){
				    	if(this.sendObj.no =="r1") return ;
				    	
						var targetid = '#TASK_'+this.sendObj.no ;
						$('#taskIdx').val( this.sendObj.no ) ;
						$('#taskDesc').val( $(targetid).text() ) ;
				    	$("#taskModify").modal('show') ; 
				    }},
				    {isOpen:true, label:"태스크 종료", className:"minus", onclick:function(){onTaskUrlAction("taskCloseAction.jsp",this.sendObj.no)}},
					{isOpen:false, label:"태스크 재시작", className:"plus", onclick:function(){onTaskUrlAction("taskReOpenAction.jsp",this.sendObj.no)}},
					{isFavorite:true, label:"즐겨찾기 삭제", className:"unlink", onclick:function(){onTaskUrlAction("favoriteDeleteAction.jsp",this.sendObj.no,"&tbl_name=TASK")}},
					{isFavorite:false, label:"즐겨찾기 추가", className:"link", onclick:function(){onTaskUrlAction("favoriteAddAction.jsp",this.sendObj.no,"&tbl_name=TASK")}},
				],
				filter:function(id){
					if(this.sendObj.no =="r1") return ;
					
					if(this.sendObj.iOwnerIdx == <%= oUserSession.getUserIdx() %>){
						return (this.menu.isOpen == this.sendObj.open || this.menu.isFavorite == this.sendObj.favorite)
					}else{ 
						return (this.menu.isFavorite == this.sendObj.favorite)
					}
				}
			}
		});
		
		var treeJson = <%=hierarchyJson%>;
		// -- console.debug(treeJson) ;
 		myTree.setList(treeJson);
	}
};

$(document.body).ready(function(){
	fnObj.pageStart();
});

function onTaskUrlAction(url,idx,repl) {
	if(repl == undefined){
		repl = '';
	}
	
	location.href = url + '?tsk_idx='+idx+'&actionUrl='+'<%=actionUrl%>' + repl;
}

function onTaskAllAction(){
	location.href = '<%=actionUrl%>' + '?tsk_idx='+<%=Html.trueString(taskList>0,taskList+"+'&tsk_list="+taskList+"'")%> ;
}
function onTaskAction(idx) {
	location.href = '<%=actionUrl%>' + '?tsk_idx='+idx ;
}

// --
function onSaveChange() {
	if( lock() ) {
		alert("처리 중입니다..") ;
		return false ;
	}	
	
	$.ajax({
		type: 'post', 
		async: true, 
		url: 'taskUpdateAction.jsp', 
		data: $("#frmTaskModify").serialize() , 
		beforeSend: function() {
		}, 
		success: function(data) {
			if(data > 0) {	// -- TODO - 방금 등록한 액티비티 시퀀스를 받아서 저장해야 함
				alert('수정 되었습니다.') ;
				var targetid = '#TASK_' + $('#taskIdx').val() ;	// -- favorite 은 자체 타이틀임.
				$(targetid).text( $('#taskDesc').val() ) ;
				$('.tabhome').text( $('#taskDesc').val() ) ;
			} else {
				alert('수정 실패');
			}
		}, 
		error: function(data, status, err) {
			alert("수정 실패");
		}, 
		complete: function() { 
			unlock() ; // -- TODO - 예외상황 발생시에도 타는가?
			$('#taskIdx').val("")  ; 
			$('#taskDesc').val("") ;
			$("#taskModify").modal('hide') ;
		}
	});	
}
</script>
<%-- modal for editing task 
--%>
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