<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<%
	String params = request.getParameter("params") ;
	String reportUrl = request.getParameter("report") ; // "jsp/kpi_process_01.jsp" ; //	"jsp/kpi_process_06_01.jsp" ; // "jsp/kpi_process_01_01.jsp" ; //
	if(reportUrl == null)return ;
	
	reportUrl = "jsp/"+reportUrl+".jsp" ;
	
	// -- 기본 날짜 설정
	String sDate = "";
	String eDate = "";	
	
	String[] arrDate = calDateFromToday ( -30 ) ;
	
	String startDate = arrDate[0] ;	// -- default 날짜 셋팅
	String endDate = arrDate[1] ;	// -- default 날짜 셋팅

	if(startDate.indexOf("/") > -1) { sDate = startDate.replaceAll("/", ""); } else { sDate = startDate; }
	if(endDate.indexOf("/") > -1) { eDate = endDate.replaceAll("/", ""); } else { eDate = endDate; }
	
%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/main_cello.css" rel="stylesheet" type="text/css">
<link href="css/calendar.css" rel="stylesheet" type="text/css">
<style type="text/css" media="screen"> 
	#flashContent { display:none; }
	#flashContent2 { display:none; }
	.readOnlyText { border:0px;background:none;font-size:9pt; font-family:dotum; text-align:right ;}
	.numText {text-align:right; }
	#reportTable1 {
		position:relative; z-index: -999; width:100%; height:300px; overflow-y:scroll; border:1p solid; border:#CCCCCC ;
	}
</style>
<script type='text/javascript' src='javascript/ajax_post.js'></script>
<script type="text/javascript" src="javascript/jquery/jquery-1.3.2.js"></script>
<script type="text/javascript" src="javascript/cal.js"></script>
<script type="text/javascript" src="javascript/date.js"></script>
<script type="text/javascript">/*<![[cdata*/
	// ### jQuery 달력
	jQuery(document).ready(function () {
		$('#pStartDate').simpleDatepicker({df:'yyyy/MM/dd'});
		$('#pStartDateImg').simpleDatepicker({df:'yyyy/MM/dd'});
		$('#pEndDate').simpleDatepicker({df:'yyyy/MM/dd'});
		$('#pEndDateImg').simpleDatepicker({df:'yyyy/MM/dd'});			
	});

	// ### 검색
	function fn_onSearch() {
		var sdate = document.getElementById("pStartDate") ;
		var edate = document.getElementById("pEndDate") ;
		
		var f = document.getElementById("reqF") ;
		f.sdate.value = sdate.value ;
		f.edate.value = edate.value ;

		reqTest () ;
	}
/*]]>*/</script>
<script type="text/javascript" src="chart/swfobject.js"></script>
<script type="text/javascript">/*<![cdata[*/
	var swfVersionStr = "10.0.0";

	var xiSwfUrlStr = "chart/playerProductInstall.swf";
	var params = {};
	params.quality = "high";
	params.bgcolor = "#ffffff";
	params.allowscriptaccess = "sameDomain";
	params.allowfullscreen = "true";
	
	var flashvars = {};
	flashvars.chartid = "DynamicColumnChart" ;
	var attributes = {};
	attributes.id = "DynamicColumnChart";
	attributes.name = "DynamicColumnChart";
	attributes.align = "middle";
	
	var flashvars2 = {};
	flashvars2.chartid = "DynamicPieChart" ;
	var attributes2 = {};
	attributes2.id = "DynamicPieChart";
	attributes2.name = "DynamicPieChart";
	attributes2.align = "middle";
/*]]>*/</script>
<script type='text/javascript'>/*<![cdata[*/
	function _request( formObj, funcName) {
		ajaxSubmit( formObj, funcName ) ;
	}

	// -- ajax request 및 ajax response 가 서로 pair를 이룸
	function reqTest () {
		var f = document.getElementById("reqF") ;
		
		// -- alert(f.sdate.value +" ~ "+f.edate.value) ;
		
		_request( f, "respTest" ) ;

		reset() ;
	}
	
           
	function respTest( responseText ) {
		var dobj = document.getElementById("dtable") ;
		dobj.innerHTML = responseText ;

		var reportinfo = document.getElementById("info_report") ;		
		if(reportinfo) {
			txt = reportinfo.value ;
			txts = txt.split(",") ;
			
			obj1 = document.getElementById("dtitle") ;
			obj2 = document.getElementById("dlink") ;
						
			obj1.innerHTML = "<img src='images/main/tit_bullet01.gif' align='absmiddle'>" + txts[0] ;
			obj2.innerHTML = "<a href='"+txts[1]+"'>"+txts[0]+"</a>" ;
			
			document.title = txts[0] ;
		}
/* -- chart를 URL로 초기화할 경우 필요		
		var url;
		var urls;
		var chartinfo = document.getElementById("info_chart") ;
		if(chartinfo) {
			url = chartinfo.value ;
			urls = url.split(",") ;
			if(urls != null) {
				flashvars.xmlurl = urls[0] ; //"./test_column.xml" ;	// -- CHART를 URL 초기화 시 필요
				if(urls.length == 2) flashvars2.xmlurl = urls[1] ; //"./test_pie.xml" ;	// -- CHART를 URL 초기화 시 필요
			}
		}
*/

		var columnchart = document.getElementById("flashContent") ;
		var piechart = document.getElementById("flashContent2") ;
		
		if(columnchart) {
			swfobject.embedSWF("chart/DynamicColumnChart.swf", "flashContent", "100%", "500", swfVersionStr, xiSwfUrlStr, flashvars, params, attributes);
			swfobject.createCSS("#flashContent", "display:block;text-align:left;");
		}
		
		if(piechart) {
			swfobject.embedSWF("chart/DynamicPieChart.swf", "flashContent2", "100%", "500", swfVersionStr, xiSwfUrlStr, flashvars2, params, attributes2);
			swfobject.createCSS("#flashContent2", "display:block;text-align:left;");
		}
	}

	function reset() {
		var dobj = document.getElementById("dtable") ;
		var obj1 = document.getElementById("dtitle") ;
		var obj2 = document.getElementById("dlink") ;
		
		dobj.innerHTML = "" ;
		obj1.innerHTML = "" ;
		obj2.innerHTML = "" ;
		
		document.title = "" ;		
	}

	// -- draw chart dynamically (aync)
	function command( chartId, sCommand, sParam ) {
		var fobj = document.getElementById ( chartId ) ;
		if(fobj == null) return ;
		fobj.command ( sCommand, sParam ) ;
	}
	
	function commandURL( chartId, xmlUrl ) {
		if(chartId == "")return ;
		if(xmlUrl == null | xmlUrl == "")return ;
		command ( chartId, "URL", xmlUrl ) ;
	}
	
	function commandXML( chartId ) {
		if(chartId == "")return ;
		var xml = document.getElementById( chartId + "XML") ;
		if(xml == null || xml.value == "")	return ;
		
		debug(xml.value) ;
		
		command ( chartId, "XML", xml.value ) ;
	}
	
	// -- 임시 
	function debug(str) {
		// -- alert(str) ;
	}
	
	// --
	
	function commandRESET ( chartId ) {
		if(chartId == "")return ;
		command ( chartId, "RESET", "" ) ;
	}
	
	// -- chart callback function -- CHART 초기화 완료 후 호출되는 콜백 함수 임. 여기서는 Javascript 기반의 로컬XML로 CHART를 초기화
	function chartLoadComplete ( chartId ) {
		// -- alert("chart 초기화 성공 : " + chartId ); 
		commandXML ( chartId ) ;
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
	
	function numberFormat ( num ) {
		var out = 0 ;
		out = Math.round( num * 10 ) / 10 ;
		return out ;
	}
	
	// -- Popup
	function getReport(report, params) { // -- 예) kpi_process_01 의 경우 'kpi_process_01','P_1.1.2'
		var url = 'test_ui2.jsp?report=' + report ;
		var f = document.getElementById("popF") ;
		f.action = url ;
		
		f.params.value = params ;
		
		var sdate = document.getElementById("pStartDate") ;
		var edate = document.getElementById("pEndDate") ;
		
		
		f.sdate.value = sdate.value ;
		f.edate.value = edate.value ;
		
		f.submit() ;
	}
/*]]>*/</script>
</head>
<body class="contents_body" onLoad="javascript:fn_onSearch();">
<form id='popF' method='post' target='_blank'>
	<input type="hidden" name="sdate" />
	<input type="hidden" name="edate" />
	<input type="hidden" name="params" />
</form>
<form id='reqF' method='post' action='<%=reportUrl%>'>
	<input type="hidden" name="sdate" />
	<input type="hidden" name="edate" />
	<input type="hidden" name="params" value="<%=params %>" />
</form>
<DIV>
	<input type='button' value='draw ui' onClick="reqTest()" />
	<input type='button' value='draw pie chart' onClick="commandURL('DynamicPieChart','test_pie.xml')" />
	<input type='button' value='draw column chart' onClick="commandURL('DynamicColumnChart','test_column.xml')" />
	<input type='button' value='draw xml column chart' onClick="commandXML('DynamicColumnChart')" />
	<input type='button' value='draw xml pie chart' onClick="commandXML('DynamicPieChart')" />
	<input type='button' value='reset column chart' onClick="commandRESET('DynamicColumnChart'); " />
	<input type='button' value='reset pie chart' onClick="commandRESET('DynamicPieChart'); " />
</DIV>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td><table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="cello_tit01" id="dtitle"></td>
					<td align="right" class="cello_location"><img src="images/main/icon_home.gif" align="absmiddle"><a href="#"> &gt; KPI</a> &gt; <span id="dlink"/></td>
				</tr>
			</table></td>
	</tr>
	<tr>
		<td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="t_search">
				<tr>
					<td><table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td  valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td width="30" class="cello_tit_search">기간</td>
											<td>
												<input type="text" id="pStartDate" name="pStartDate" class="readonly w70" readonly value="<%=startDate%>"/>
												<a href="#"><img src="images/main/btn_calendar.gif" id="pStartDateImg" target="pStartDate" align="absmiddle" alt="달력"></a> ~
												<input type="text" id="pEndDate" name="pEndDate" class="readonly w70" readonly value="<%=endDate%>"/>
												<a href="#"><img src="images/main/btn_calendar.gif" id="pEndDateImg" target="pEndDate" align="absmiddle" alt="달력"></a>
											</td>
										</tr>
									</table></td>
								<td valign="top" class="w7"></td>
								<td width="65"><table border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td class="cello_bu04_l"></td>
											<td nowrap class="cello_bu04"><a href="javascript:fn_onSearch();">Search</a></td>
											<td class="cello_bu04_r"></td>
										</tr>
									</table></td>
							</tr>
						</table></td>
				</tr>
			</table></td>
	</tr>
	<tr>
		<td class="h10"></td>
	</tr>
	<tr>
		<td><div id='dtable'></div></td>
	</tr>
</table>
<DIV>
	<input type='button' value='draw ui' onClick="reqTest()" />
	<input type='button' value='draw pie chart' onClick="commandURL('DynamicPieChart','test_pie.xml')" />
	<input type='button' value='draw column chart' onClick="commandURL('DynamicColumnChart','test_column.xml')" />
	<input type='button' value='draw xml column chart' onClick="commandXML('DynamicColumnChart')" />
	<input type='button' value='draw xml pie chart' onClick="commandXML('DynamicPieChart')" />
	<input type='button' value='reset column chart' onClick="commandRESET('DynamicColumnChart'); " />
	<input type='button' value='reset pie chart' onClick="commandRESET('DynamicPieChart'); " />
</DIV>
</body>
</html>
<%!
private String[] calDateFromToday( int gapDays ) {	// -- 오늘 날짜로 부터 30일 전
	Calendar cal = Calendar.getInstance() ;
	cal.setTime( new Date( System.currentTimeMillis() ) ) ;
	
	SimpleDateFormat sdf = new SimpleDateFormat( "yyyy/MM/dd" ) ; 
	String today = sdf.format( cal.getTime() ) ;
	
	cal.add( Calendar.DAY_OF_MONTH, gapDays ) ;
	String caldate = sdf.format(cal.getTime()) ;
	
	String sdate = "" ;
	String edate = "" ;	
	if(gapDays > 0) {
		sdate = today ;
		edate = caldate ;
	}
	else {
		sdate = caldate ;
		edate = today ;
	}
	
	// -- System.out.println( sdate + " ~ " + edate ) ;
	String[] arrDate = new String[] { sdate, today } ;
	
	return arrDate ;
}
%>