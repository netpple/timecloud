<%@page import="com.twobrain.chart.factory.ChartSessionFactory"%>
<%@page import="com.twobrain.chart.api.IChartSessionHandler"%>
<%@page import="org.apache.log4j.Logger"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" 
	import="java.text.SimpleDateFormat
			,java.util.Calendar
			,java.util.Date
			,java.util.TimeZone,
			com.twobrain.chart.locale.*"
%><%@ include file="jsp/incConstants.jspf"%>
<%
	IChartSessionHandler chartSessionHandler = ChartSessionFactory.getChartSessionHandler(request) ;
	if(!chartSessionHandler.checkSession())return ;
			
	String timeZone = chartSessionHandler.getTimeZone() ;
	out.println("timeZone="+timeZone) ;
	
	String localeCode = chartSessionHandler.getLocaleCode() ;
	
	out.println("localeCode="+localeCode) ;
	
	String params = request.getParameter("params") ;
	String reportUrl = request.getParameter("report") ;
	String excelUrl = "";
	
	out.print("params="+params) ;
	
	out.print("report="+reportUrl) ;
	
	//if(1==1)return ;
	if(reportUrl == null)return ;
	
	boolean noTopTitle = false ;
	boolean isPopup = false ;
	String popup = request.getParameter("popup") ;
	if( popup != null && popup.equals("1") ) {
		isPopup = true ;
	}
	else popup = "0" ;
	
	String topTitle = request.getParameter("topTitle") ;
	
	if( topTitle != null && topTitle.equals("1") ) {
		noTopTitle = true ;
	}
	
	excelUrl = "jsp/"+reportUrl+"_excel.jsp" ;
	reportUrl = "jsp/"+reportUrl+".jsp" ;
	
	// -- 기본 날짜 설정
	String sDate = request.getParameter("sdate");
	String eDate = request.getParameter("edate");
	sDate = (sDate == null)?"" : sDate ;
	eDate = (eDate == null)?"" : eDate ;
	
	String startDate = "" ;	// -- default 날짜 셋팅
	String endDate   = "" ;	// -- default 날짜 셋팅
	String todayTime = "" ;   // -- 현재 시분초
	
	if( "".equals(sDate) || "".equals(eDate) ) { 
		String[] arrDate = calDateFromToday(-30, timeZone);
	
		startDate = arrDate[0];	// -- default 날짜 셋팅
		endDate   = arrDate[1];	// -- default 날짜 셋팅
		todayTime = arrDate[2];	// -- 현재 시분초
	}
	else {	// -- 팝업 수신 등 
		startDate = sDate.substring(0,10) ;
		endDate = eDate.substring(0,10) ;
		todayTime = request.getParameter("todayTime");
	}

	if(startDate.indexOf("/") > -1) { sDate = startDate.replaceAll("/", ""); } else { sDate = startDate; }
	if(endDate.indexOf("/") > -1) { eDate = endDate.replaceAll("/", ""); } else { eDate = endDate; }
	
	String resourceCode = "kpi";   
	// -- MessageBundle msg = KpiLocale.getMessageBundle(localeCode, resourceCode);
%><html><!-- reportUrl: <%=reportUrl%> -->
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/main_cello.css" rel="stylesheet" type="text/css">
<link href="css/calendar.css" rel="stylesheet" type="text/css">
<link href="chart/chart.css" rel="stylesheet" type="text/css">
<style type="text/css" media="screen"> 
	.readOnlyText { border:0px;background:none;font-size:9pt; font-family:dotum; text-align:right ;}
	.numText {text-align:right; }
	#reportTable1 {
		position:relative; z-index: -999; width:100%; height:300px; overflow-y:scroll; border:1p solid; border:#CCCCCC ;
	}
</style>
<script type='text/javascript' src='javascript/ajax_post.js'></script>
<script type="text/javascript" src="javascript/forms.js"></script>
<script type="text/javascript" src="javascript/jquery/jquery-1.3.2.js"></script>
<script type="text/javascript" src="javascript/cal.js"></script>
<script type="text/javascript" src="javascript/date.js"></script>
<script type="text/javascript">/*<![[cdata*/
	// ### jQuery 달력
	jQuery(document).ready(function () {
		$('#pStartDate').simpleDatepicker({df:'yyyy/MM/dd',compareFromTo:'to.pEndDate'});
		$('#pStartDateImg').simpleDatepicker({df:'yyyy/MM/dd',compareFromTo:'to.pEndDate'});
		$('#pEndDate').simpleDatepicker({df:'yyyy/MM/dd', compareFromTo:'from.pStartDate'});
		$('#pEndDateImg').simpleDatepicker({df:'yyyy/MM/dd', compareFromTo:'from.pStartDate'});	

			
	});

	function fn_calCloseCallBack(datevalue) {
		alert('call function fn_calCloseCallBack : ' + datevalue);
	}
	
	// ### 검색
	function fn_onSearch() {
		var f = document.getElementById("reqF") ;
		if(!fn_onCheckDateField(f.pStartDate, f.pEndDate)) return; 
		
		var sdate = document.getElementById("pStartDate") ;
		var edate = document.getElementById("pEndDate") ;
		
		f.sdate.value = sdate.value ;
		f.edate.value = edate.value ;
		
		// --
		f.popup.value = "0" ;	// -- 현재 창의 팝업 여부 - 0:팝업아님 1:팝업
		f.action = "<%=reportUrl%>" ;
		f.target = "" ;
		// -- 

		/* kpi_issue_01 에서 사용 하느 onSearch() 추가 제어 script*/
		if(!fn_onExtSearch()) {
			return;
		}
		/**/
		/*사용자 브라우저 크기 by Rinoa 2012.02.04 */
		f.clientWidth.value = document.body.clientWidth;

		reqSubmit () ;
	}

	function fn_onExtSearch(){
		var reportinfo = document.getElementById("info_report") ;
		var filename ="";		
		if(reportinfo) {
			txt = reportinfo.value ;
			filename = txt.split("<%=__INFO_DELIM__%>")[1];
		}
		return true;		
	}

	function onlyNumDecimalInput(){
	 var code = window.event.keyCode;

	  if ( (code >= 48 && code <= 57) || (code >= 96 && code <= 105) || code == 110 || code == 190 || code == 8 || code == 9 || code == 13 || code == 46 ){
	  window.event.returnValue = true;
	   return;
	  }
	  window.event.returnValue = false;
	}
/*]]>*/</script>
<%
	String chartRoot = "chart/" ;	// -- "chart/" ;
%>
<script type="text/javascript" src="<%=chartRoot %>swfobject.js"></script>
<script type="text/javascript" src="<%=chartRoot %>chart.js"></script>
<script type='text/javascript'>/*<![cdata[*/
	def_flashvars.lang = "<%=localeCode%>" ;
	def_flashvars.chartbaseurl = "<%=chartRoot %>" ; // -- 
/*]]>*/</script>
<script type='text/javascript'>/*<![cdata[*/
	function _request( formObj, funcName) {
		ajaxSubmit( formObj, funcName ) ;
	}

	// -- ajax request 및 ajax response 가 서로 pair를 이룸
	function reqSubmit () {
		var f = document.getElementById("reqF") ;
		
		// -- alert(f.sdate.value +" ~ "+f.edate.value) ;
		
		_request( f, "respSubmit" ) ;

		reset() ;
	}
	
	function respCheck ( responseText ) {
		if ("session-time-out" == responseText.trim())
		{
			// alert("You are disconnected to the server.\nPlease login again.");
			if (opener != null)  {
				if(!window.opener.closed) {
					opener.top.location.replace("/");
				} else {
					var pop = window.open("/");
					pop.focus() ;
				}
				window.close();
			} else {
				top.location.replace("/");	
			}	
			return;
		}
	}
	
	function respSubmit( responseText ) {
		
		respCheck ( responseText ) ;
		
		var dobj = document.getElementById("dtable") ;
		dobj.innerHTML = responseText ;

		var reportinfo = document.getElementById("info_report") ;		
		if(reportinfo) {
			txt = reportinfo.value ;
			txts = txt.split("<%=__INFO_DELIM__%>") ;	// -- __INFO_DELIM__
			
			obj1 = document.getElementById("dtitle") ;

			var pgtitle = <% if(!isPopup){%> "<img src='images/main/tit_bullet01.gif' align='absmiddle'>" + <%}%> txts[0] ;
			if(obj1 != null && obj1.innerHTML != pgtitle)obj1.innerHTML = pgtitle ;
			
			document.title = txts[0] ; 
		}
		
		var searchinfo = document.getElementById("info_search") ;
		var searchComponent = document.getElementById('searchComponent') ;
		if(searchinfo) {
			document.getElementById('searchBar').style.display = "" ;
			if( searchinfo.value != "" ) {
				searchComponent.innerHTML = searchinfo.value ;
			}
			else searchComponent.innerHTML = "" ; // -- 초기화
		}
		else {
			document.getElementById('searchBar').style.display = "none" ;
		}
		
		var searchinfoExt = document.getElementById("info_search_ext") ;
		if(searchinfoExt != null && searchinfoExt != ""){
			var searchComponentExt = document.getElementById('searchComponentExt') ;
			document.getElementById('searchborder').style.background = "#d5d5d5" ;
			
			searchComponentExt.innerHTML = searchinfoExt.value ;
			document.getElementById('ctrlSearchOption').style.display = "" ;
			document.getElementById('extTr').style.display="block" ;
		}
		else {
			document.getElementById('searchborder').style.background = "" ;
			document.getElementById('ctrlSearchOption').style.display = "none" ;
			document.getElementById('extTr').style.display="none" ;
		}		
		
		unsetProgressBar() ;
		
		drawChart() ;
	}
	
	function reset() {
		var dobj = document.getElementById("dtable") ;
		
		// -- loading bar 처리
		setProgressBar( dobj ) ;
		
		document.title = "" ;		
	}
	
	// -- ProgressBar
	function setProgressBar(obj) {
		var w = document.body.scrollWidth ;  // -- document.documentElement.offsetWidth ; // -- NON-IE
		var h = document.body.scrollHeight ; // -- document.documentElement.offsetHeight ; // -- NON-IE
		
		var barname="big.gif" ; // -- loading_l.gif
		obj.innerHTML =  "<div align='center' style='width:100%;padding-top:"+(h-80)/2+"px;'><img src='images/"+barname+"'></div>" ;
		
		var scr = document.getElementById("divLoading") ;
		scr.style.width= w ;	
		scr.style.height= h ;

		scr.style.display="" ;
	}
	
	function unsetProgressBar() {
		document.getElementById("divLoading").style.display="none" ;
	}
	
	// -- Table Change 
	function changeRate() {
		var rate1s = document.getElementsByName("rate1") ;
		var cnt = rate1s.length ;
		if(cnt <= 0) return ;
		
		var rate2s = document.getElementsByName("rate2") ;
		if( cnt != rate2s.length) return ;
		
		var val1s = document.getElementsByName("val1") ;
		var val2s = document.getElementsByName("val2") ;
		var results = document.getElementsByName("result") ;
		
		if(val1s.length != cnt) {
			// -- alert("val1s의 길이가 다름.") ;
			return ;
		}
		if(val2s.length != cnt) {
			// -- alert("val2s의 길이가 다름.") ;
			return ;
		}
		if(results.length != cnt) {
			// -- alert("results의 길이가 다름.") ;
			return ;
		}
		
		var rate1 = 0 ;
		var rate2 = 0 ;
		var result = 0 ;
		
		var result_sum = 0;
		var rate1_sum = 0;
		var rate2_sum = 0 ;
		
		for (i=0;i<cnt;i++) {
			rate1 = eval( rate1s[i].value ) ;
			rate2 = 100 - rate1 ;
			rate2s[i].value = rate2 ;
			
			result = eval(val1s[i].value) * rate1 + eval(val2s[i].value) * rate2 ;
			results[i].value = numberFormat( result / 100 ) ;
			
			rate1_sum += rate1 ;
			rate2_sum += rate2 ;
			result_sum += result ;
		}
		
		var rate1_avg = document.getElementsByName("rate1_avg") ;
		var rate2_avg = document.getElementsByName("rate2_avg") ;
		var result_avg = document.getElementsByName("result_avg") ;
		
		rate1_avg[0].value = numberFormat ( rate1_sum / cnt ) ;
		rate2_avg[0].value = numberFormat ( rate2_sum / cnt ) ;
		result_avg[0].value = numberFormat( result_sum / (100 * cnt) ) ;
	}
	
	function changeRates() {
		var rate1s = document.getElementsByName("rate1") ;
		var cnt = rate1s.length ;
		if(cnt <= 0) return ;
		
		var rate2s = document.getElementsByName("rate2") ;
		var cnt2 = rate1s.length ;
		if(cnt2 <= 0) return ;
		
		var rate1 = 0;
		var rate2 = 0;
	
		rate1 = rate1s[0].value.trim();
		if(rate1 > 100){ 
			rate1s[0].value = 100;
			rate2s[0].value = 0;
			return;
		}
		rate1s[0].value = rate1;
		rate2s[0].value = (100 - rate1);
	}
	
	function numberFormat ( num ) {
		var out = 0 ;
		out = Math.round( num * 10 ) / 10 ;
		return out ;
	}
	
	// -- Popup
	function getReport(report, params) { // -- 예) kpi_process_01 의 경우 'kpi_process_01','P_1.1.2'
		var url = 'kpi_main.jsp?report=' + report ;
		// --
		var f = document.getElementById("reqF") ;//document.getElementById("popF") ;
		if(!fn_onCheckDateField(f.pStartDate, f.pEndDate)) return;

		f.params.value = params ;
		
		var sdate = document.getElementById("pStartDate") ;
		var edate = document.getElementById("pEndDate") ;
		
		f.sdate.value = sdate.value ;
		f.edate.value = edate.value ;
		
		var pop = window.open('','reportPop',"width=900,height=600,scrollbars=yes,resizable=yes") ;
		f.popup.value = "1" ;
		f.action = url ;
		f.target = 'reportPop' ;		
		f.submit() ;

		pop.focus() ;
	}
	
	// -- Self request
	function recall ( params ) {
		var f = document.getElementById("reqF") ;
		f.params.value = params ;
		
		fn_onSearch() ;
	}
	
	// -- Extend Search Option
	function clickSearchOption () {
		var extTr = document.getElementById('extTr') ;
		var icoExt = document.getElementById('icoExt') ;
		var icoCol = document.getElementById('icoCol') ;
		if ( extTr.style.display == 'none' ) {
			extTr.style.display = 'block' ;
			icoCol.style.display = 'inline' ;
			icoExt.style.display = 'none' ;
		}
		else {
			extTr.style.display = 'none' ;
			icoCol.style.display = 'none' ;
			icoExt.style.display = 'inline' ;
		}
	}
	
	function getExcelPage(){
		var frm = document.getElementById("excelFrm");
		alert(frm);
		frm.target = "ifrExcel"; 
		frm.submit(); 
	}

	function searchKeywordTxt() {
		var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
	    if (keyCode == 13) {
	    	fn_onSearch();
	    }
	    else{
	    	return ;
		}
	}
/*]]>*/</script>
</head>
<body <% if(!isPopup){%> class="contents_body"<%}%> onLoad="javascript:fn_onSearch();">
<form id='reqF' method='post' action='<%=reportUrl%>'>
	<input type="hidden" name="sdate" />
	<input type="hidden" name="edate" />
	<input type="hidden" name="clientWidth" />
	<input type="hidden" name="currentPage" value="1"  />
	<input type="hidden" name="currentPageGroup" value="1"  />
	<input type="hidden" name="params" value="<%=params %>" />
	<input type="hidden" name="todayTime" value="<%=todayTime %>" />
	<input type="hidden" name="popup" value="<%=popup%>" />
	<input type="hidden" name=L1Name value="" />
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<% if(!noTopTitle){ // -- TopTitle을 사용할 경우 %>	
	<tr>
		<td>
<% if( !isPopup ) { %>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="cello_tit01" id="dtitle"></td>
					<%-- td align="right" class="cello_location"><img src="images/main/icon_home.gif" align="absmiddle"><a href="#"> &gt; KPI</a> &gt; <span id="dlink"/></td /* -- 제거 요청 - 20111128 - requested by intaek.choi -- */ --%>
				</tr>
			</table>
			<div width='100%' align=right style='padding-top:10px;padding-right:15px;<%= "jsp/kpi_issue_01.jsp".equals(reportUrl) ? "" : "display:none"%>'>
				<table width='100%' height='30' border='0' cellspacing='0' cellpadding='0' >
					<tr>		
						<td class="th right" valign="middle" height='30'>
							<table border="0" cellpadding="0" cellspacing="0">			
								<tr>
									<td class="cello_bu01_l"></td>
									<td class="cello_bu01"><img src="images/main/bullet_excel.gif"></td>
									<%-- 
									<td class="cello_bu01" title="<%=msg.getString("label.tooltip.issue.excel2")%>"><a href="javascript:getExcelUrl('jsp/kpi_issue_01_excel2.jsp');"><%=msg.getString("label.issue.excel2")%></a></td>
									--%>
									<td class="cello_bu01_r"></td>
									<td class="w3"></td>					
								</tr>				
							</table>
						</td>
					</tr>
				</table>
			</div>
		
<% } else { %>
			<table width='100%' border='0' cellpadding='0' cellspacing='0'>
				<tr>
					<td class='cello_pop_bg' id="dtitle"></td>
			    	<td class='cello_pop_right'></td>
				</tr>
			</table>
			<div width='100%' align=right style='padding-top:10px;padding-right:15px;'>
				<table border='0' cellspacing='0' cellpadding='0'>
					<tr>
						<td class='cello_bu01_l'></td>
						<td class='cello_bu01'><a href="#" onClick="window.close();" title='Close'>Close</a></nobr></td>
						<td class='cello_bu01_r'></td>
					</tr>
				</table>
			</div>			
<% } %>			
		</td>
	</tr>
<% } //-- !noTopTitle %>	
	<tr id='searchBar' style='display:none; padding-bottom:10px'>
		<td <% if(isPopup){ %>class="pop_body"<%} %>>
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="t_search">
				<tr>
					<td><table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td><table class="detail_v1 margin">
										<tr>
											<td style="width:255px;">
											<table style='padding:0;margin:0;'>
												<th style="width:40px;text-align:left;">Period</th>
												<td style="width:200px;">
													<input type="text" id="pStartDate" name="pStartDate" class="readonly w70" readonly value="<%=startDate%>"/>
													<a href="#"><img src="images/main/btn_calendar.gif" id="pStartDateImg" target="pStartDate" align="absmiddle" alt="Calendar"></a> ~
													<input type="text" id="pEndDate" name="pEndDate" class="readonly w70" readonly value="<%=endDate%>"/>
													<a href="#"><img src="images/main/btn_calendar.gif" id="pEndDateImg" target="pEndDate" align="absmiddle" alt="Calendar"></a>
												</td>
											</table>
											</td>
											<td id="searchComponent"></td>
										</tr>
<%-- extend 부분: 동적으로 제공돼야 하는 컴포넌트 --%>										
										<tr id="extTr" style="display:none"><td style='padding-left:0px;' colspan=2  id="searchComponentExt" ></td></tr>
<%-- --%>
									</table></td>
<%-- Optionable 하게 제어 돼야 하는 부분 --%>								
						        <td width="80" align="right" valign="top"><table class="detail_v2 margin0" style="display:none" id="ctrlSearchOption">
						          <tr>
						            <td><span class="cello_tit_search option" style="padding-right:3px"><a href="javascript:clickSearchOption();"><strong>Option</strong> <img src="images/main/btn_arrow_extend.gif" id="icoExt" style="display:none"><img src="images/main/btn_arrow_collapse.gif" id="icoCol"></a></span></td>
						          </tr>
						        </table></td>						        
<%-- --%>						        

								 <td id="searchBorder" width="1" style="background:"></td>
						        <td width="70" align="right" valign="top" style="padding-top:3px"><table border="0" cellpadding="0" cellspacing="0">
						          <tr>
						            <td class="cello_bu04_l"></td>
						            <td nowrap class="cello_bu04"><a href="javascript:fn_onSearch();">Search</a></td>
						            <td class="cello_bu04_r"></td>
						          </tr>
						        </table></td>
							</tr>
						</table></td>
				</tr>
			</table>
		</td>
	</tr><!-- search bar tr end -->
	<tr>
		<td <% if(isPopup){ %>class="pop_body"<%} %> ><div id='dtable'></div></td>
	</tr>
</table>
</form>

<!-- 추가적으로 사용되는 스크립트 및 FORM 사용을 지정한 파일 -->
<%@ include file="jsp/incCommonForm.jspf"%>

<%-- Progress용 창 전체를 덮는 DIV --%>
<div id="divLoading" style="position:absolute; left:0px; top:0px; width:100%; height:100%; z-index:100; filter:alpha(opacity=30);">
	<iframe style="display:none ; width:100%; height:100%; position:absolute; left:0; top:0"></iframe>
</div>
<iframe id="ifrExcel" name="ifrExcel" src="" width="100%" height="0" frameborder="0" scrolling="yes"></iframe>
</body>
</html>
<%!
private String[] calDateFromToday(int gapDays, String timeZone) {	// -- 오늘 날짜로 부터 30일 전
	Calendar cal = Calendar.getInstance() ;
	cal.setTime(new Date(System.currentTimeMillis())) ;
	
	SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd");
	SimpleDateFormat sdf2 = new SimpleDateFormat("HHmmss");
	
	sdf1.setTimeZone(TimeZone.getTimeZone(timeZone));
	sdf2.setTimeZone(TimeZone.getTimeZone(timeZone));
	
	String today = sdf1.format(cal.getTime());   // yyyy/MM/dd
	String todayTime = sdf2.format(cal.getTime());   // HHmmss
	
	cal.add( Calendar.DAY_OF_MONTH, gapDays );
	String caldate = sdf1.format(cal.getTime());
	
	String sdate = "";
	String edate = "";	
	if(gapDays > 0) {
		sdate = today; 
		edate = caldate;
	}
	else {
		sdate = caldate;
		edate = today;
	}
	
	String[] arrDate = new String[] {sdate, edate, todayTime};
	
	return arrDate ;
}
%>