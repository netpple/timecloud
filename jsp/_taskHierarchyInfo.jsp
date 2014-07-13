<%@page import="com.twobrain.common.log.LogHandler"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ page import="java.util.*,java.io.*" %>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %>
<%@ include file="./common/include/incTaskView.jspf" %>
<script type="text/javascript">
var int_tskIdx = <%=TASK_IDX%>
var int_tskList = <%=TASK_LIST%>



var myTree = new AXTree();

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

					$("#verNav").find("li").removeClass("active");
					if(item.no=='r1') {
			 			window.history.pushState("r1", true, "/jsp/task.jsp?tsk_idx="+<%=Html.trueString(taskList>0,taskList+"+'&tsk_list="+taskList+"'")%>);
			 			int_tskList = <%=taskList%>;
			 			int_tskIdx = int_tskList;
						onTaskAllAction(item.iOwnerIdx) ;
					} else{
						int_tskIdx = item.no;
			 			window.history.pushState(int_tskIdx, true, "/jsp/task.jsp?tsk_idx="+item.no);
			 			int_tskList = -1; 
						onTaskAction(item.no, item.iOwnerIdx);
					}
				},
				addClass: function(){
					if(int_tskList > 0){
						<%out.println( "if(this.item.no=='r1') return 'taskHierarchySelected';" ) ;%>
					}
					else {
						<%out.println( "if(this.item.no==int_tskIdx) return 'taskHierarchySelected' ; " ) ;%>
					}
					
				}
			},
			contextMenu: {
				theme:"AXContextMenu", // 선택항목
				width:"140", // 선택항목
				menu:[
				    {isOpen:true, label:"액티비티/할당", className:"plus", onclick:function(){
				    	
				    	int_tskIdx = this.sendObj.no;
			 			$.ajax({	
			 				type:"POST",
			 				url:'taskHierarchyData.jsp?tsk_idx='+this.sendObj.no,
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
				    	$.ajax({
				    		type : 'post',
				    		async : true,
				    		url : "taskMenu.jsp?tsk_idx="+this.sendObj.no+"&owner_idx="+this.sendObj.iOwnerIdx+"&view=calendar&modal=Y",
				    		beforeSend : function() {
				    		},
				    		success : function(data) {
				    			$('#taskMenu *').remove();
				    			$('#taskMenu').append(data);	
				    		},
				    		complete : function() {
				    		}
				    	});
				    	
				    	<%--
			    		$(".active").removeClass("active");
			    		$("#menu_calendar").addClass("active");
			    		$.ajax({
			    			type : 'post',
			    			async : true,
			    			url : "_calendar.jsp?tsk_idx="+this.sendObj.no+"&owner_idx="+<%=oTaskHierarchy.getCurrentTask().getOwnerIdx()%>+"&modal=Y",
			    			beforeSend : function() {
			    			},
			    			success : function(data) {
			    				$('#taskContent *').remove();
			    				$('#taskContent').append(data);	
			    			},
			    			complete : function() {
			    			}
			    		});
						--%>
				    }},
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
					
					//alert(Object.toJSON(this));
					
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

 		function onTaskUrlAction(url,idx,repl) {
 			if(repl == undefined){
 				repl = '';
 			}
 			$.ajax({	
				type:"POST",
				url:url + '?tsk_idx='+idx + repl, 
				success:function(data){
		 			$.ajax({	
		 				type:"POST",
		 				url:'taskHierarchyData.jsp?tsk_idx='+idx,
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
				}, 
				error:function(e){
				},
			});
 		}

 		function onTaskAllAction(ownerIdx){
 			//location.href = '<%=actionUrl%>' + '?tsk_idx='+<%=Html.trueString(taskList>0,taskList+"+'&tsk_list="+taskList+"'")%> ;
 			int_tskList = <%=Html.trueString(taskList>0,taskList+"")%>;
 			$.ajax({	
 				type:"POST",
 				url:'taskMenu.jsp?tsk_idx='+<%=Html.trueString(taskList>0,taskList+"+'&tsk_list="+taskList+"'")%> + "&owner_idx="+ownerIdx ,
 				beforeSend: function() {  
 					$("#taskMenu *").remove();
		        },  
				success:function(data){	
 					$("#taskMenu").append(data);
 				}, 
 				error:function(e){
 				}
 			});

 			
 			$.ajax({	
 				type:"POST",
 				url:'taskHierarchyData.jsp?tsk_idx='+<%=taskList%>,
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

 		function onTaskAction(idx, ownerIdx) {

 			$.ajax({	
 				type:"POST",
 				url:'taskMenu.jsp?tsk_idx='+idx+"&owner_idx="+ownerIdx,
 				success:function(data){	
 					$("#taskMenu *").remove();
 					$("#taskMenu").append(data);
 				}, 
 				error:function(e){
 				}
 			});
 			$.ajax({	
 				type:"POST",
 				url:'taskHierarchyData.jsp?tsk_idx='+idx,
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
 						if( $('#taskIdx').val() == int_tskIdx ){
 							$('.tabhome').text( $('#taskDesc').val() ) ;
 						}
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

</script>

