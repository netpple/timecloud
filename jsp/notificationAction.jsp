<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %><%


	final int listCnt = req.getIntParam("listCount",-1);	
	int notiCnt = 10; // 이벤트 당 늘어나는 갯수 

	// -- notification
	DataSet ds = QueryHandler.executeQuery("TEST_SELECT_MYNOTIFICATION", oUserSession.getUserIdx()) ;
	
	StringBuffer result = new StringBuffer() ;
	String task_idx, desc, creator_idx, timegap ;	

	if(ds.numOfRow <= listCnt){
		out.print(-1);
		return ;
	}else if(ds.numOfRow < (listCnt + notiCnt)){
		notiCnt = notiCnt - ((listCnt + notiCnt) - ds.numOfRow);
	}

	ds.currentRowCount = listCnt;
	
	int i = 0;
	while(i++ < notiCnt) {
		ds.next();
		task_idx = ds.getString(1) ;
		desc = ds.getString(2) ;
		creator_idx = ds.getString(3) ;
		timegap = ds.getString(4) ;
		
		String sUserInfo = String.format(Config.getProperty("init", Cs.USER_PROFILE_IMAGE_URN), oUserSession.getDomainIdx(), creator_idx, oUserSessigetDomainIdx()n()) ;
		result.append(
			Html.li(
			    Html.a( 
			    	Html.img_("class='media-object' src='"+sUserInfo+"' width='40px'")
			    ,"class='pull-left'" )+
			    Html.div(
			      // Html.h4(creator_idx,"class='media-heading'")+
			      Html.div( Html.a( Html.small(desc),"href='/jsp/task.jsp?tsk_idx="+task_idx+"'") )
				,"class='media-body'") 
			,"class='media' ")
		);
	}
	out.print(result.toString());


%>