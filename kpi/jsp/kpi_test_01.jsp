<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="incCommon.jspf"%>
<%@ page import="java.util.*, java.text.DateFormat, java.text.SimpleDateFormat" %>
<%@ include file="incCommonUtil.jspf"%>
<%
final String nowUrl = request.getRequestURI() ;
String thisFilename = nowUrl.substring(nowUrl.lastIndexOf("/")+1) ;
String thisFilenameNoExt = thisFilename.substring(0,thisFilename.lastIndexOf(".")) ;

System.out.println( "URI : " + nowUrl ) ;
System.out.println( "Filename : " + thisFilename ) ;
System.out.println( "FilenameNoExt : " + thisFilenameNoExt ) ;

String excelUrl = null ;
%>
<input type='hidden' id='info_report' value='<%=msg.getString("title.pns.01") %><%=__INFO_DELIM__ + thisFilename %>' />
<input type='hidden' id='info_search' value="" />
<input type='hidden' id='info_search_ext' value="" />
<%
// -- Tab 처리
String tab = (param_ext != null) ? param_ext[0] : "0" ;
int tabSeq = Integer.parseInt( tab ) ;
String tabClassOn = "cello_tab_on" ;
String tabClassOff = "cello_tab_off" ;
String[] tabs = new String[]{tabClassOff,tabClassOff,tabClassOff} ;
tabs[ tabSeq ] = tabClassOn ;
%>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td class="cello_tab_bg">
			<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<table border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td class="<%=tabs[0] %>_l"></td>
								<td class="<%=tabs[0] %>"><a href="javascript:recall('0');"><%=msg.getString("label.pns.finished")%></a></td>
								<td class="<%=tabs[0] %>_r"></td>
							</tr>
						</table>
					</td>
					<td>
						<table border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td class="<%=tabs[1] %>_l"></td>
								<td class="<%=tabs[1] %>"><a href="javascript:recall('1');"><%=msg.getString("label.pns.onprogress")%></a></td>
								<td class="<%=tabs[1] %>_r"></td>
							</tr>
						</table>
					</td>				
				</tr>
			</table>
		</td>		
	</tr>
</table>
<% 
List resultList = execChartTestQuery(param, tabSeq);

if (null != resultList && !resultList.isEmpty()) {	
%>
<!-- ========================= title & excel button area start.............! =========================  -->
<% if(excelUrl != null) { %>
<table width='100%' border='0' cellspacing='0' cellpadding='0' >
	<tr>
		<td width="70%">
			<b></b>
		</td>		
		<td width="30%" class="th right" valign="middle">
			<!-- ========================= excel button start.............! =========================  -->
			<jsp:include page="incCommonExcelPage.jsp">				
				<jsp:param name="excelUrl" value="<%=excelUrl%>" />
			</jsp:include>
			<!-- ========================= excel button end.............! =========================  -->
		</td>
	</tr>
</table>
<% } %>
<!-- ========================= title & excel button area end.............! =========================  -->
<table width='100%' border='0' cellspacing='0' cellpadding='0'>
	<tr>
		<td class='h10'></td>
	</tr>
	<tr>
		<td>
			<table border='0' cellpadding='0' cellspacing='0' class='table_data' style="table-layout:fixed">
				<colgroup>			        
					<col width="*" />
					<col width="*" />
					<col width="*" />
				</colgroup>			
				<tr style="<%=param[2].equals("ko") ? "height:40" : "height:65" %>">		
					<td class="th"><%=msg.getString("label.pns.id")%></td>
					<td class="th"><%=msg.getString("label.pns.appid")%></td>
					<td class="th"><%=msg.getString("label.pns.msgtype")%></td>
				</tr>
<%
	Map result = null ;
	String trs = "" ;
	// -- Table Sample
	for (int i=0; i<resultList.size();i++) {
		result = (HashMap<String,String>)resultList.get(i) ;
		trs += "<tr>"+
					"<td class='td'>"+result.get("ASP_G_CODE")+"</td>"+
					"<td class='td'>"+result.get("ASP_CODE")+"</td>"+
					"<td class='td'>"+result.get("ASP_IDX")+"</td>"+
				"</tr>" ;
	}
	out.println( trs );
	
	// -- Chart Sample
	ChartUtil chartUtil = new ChartUtil() ;
	ChartXml chartXml = new ChartXml() ;
	// --	
	chartXml.appendSeriesName( msg.getString("chart.label.no.risk.regist") ) ;
	chartXml.appendSeriesName( msg.getString("chart.label.no.p.propa") ) ;
	chartXml.appendSeriesName( msg.getString("chart.label.no.action") ) ;
	// --
	chartXml.setLegendHorizontalAlign("left") ;
	chartXml.setLegendVerticalAlign("bottom") ;
	chartXml.setLegendColumnCnt(3) ; // -- per row
	// --
	chartXml.appendCategory("한국") ;
	chartXml.appendSeries("10") ;	// -- no.risk.regist
	chartXml.appendSeries("20") ;	// -- no.p.propa
	chartXml.appendSeries("15") ;	// -- no.action

	chartXml.appendCategory("미국") ;
	chartXml.appendSeries("14") ;	// -- no.risk.regist
	chartXml.appendSeries("20") ;	// -- no.p.propa
	chartXml.appendSeries("14") ;	// -- no.action

	chartXml.appendCategory("영국") ;
	chartXml.appendSeries("11") ;	// -- no.risk.regist
	chartXml.appendSeries("23") ;	// -- no.p.propa
	chartXml.appendSeries("5") ;	// -- no.action

	Chart chart = chartUtil.columnChart( chartXml.createChartXml() ) ;
	
%>				
		</table></td>
	</tr>
	<tr>
		<td><%=chart.getChart() %></td>
	</tr>
</table>
<%
} else {
	out.println( getNoData(msg) );
}
%>
<%!
	private List execChartTestQuery(String[] param, int tabSeq) throws Exception {
		String queryName = "selectChartTest" ;

		// Parameter Map
		Map paramMap = new HashMap<String,String>();
		
		System.out.println("startDateSch="+param[0]) ;
		System.out.println("endDateSch="+param[1]) ;
		
		// Search Period - param[0] == sDate, param[1] == eDate
		paramMap.put("startDateSch", param[0] );
		paramMap.put("endDateSch", param[1] );
		paramMap.put("useTimestamp", "1") ;	// -- 날짜 검색 조건을 타임스탬프로 조회 - value는 단순히 NULL체크용임.
		paramMap.put("localeCode", param[2]);
		// -- 
		paramMap.put("AspGroupCd", "004") ;
		paramMap.put("AspIdx","202") ;
		// -- 
		IChartQueryHandler chartQueryHandler = ChartQueryFactory.getChartQueryHandler() ;

		return chartQueryHandler.getKpiResultList(queryName, paramMap);
	}

	public String getMark(String val) {
		String mark = null ;
		if("1".equals(val)){
			mark = "<font color='green'>●</font>" ;
		}
		else {
			mark = "<font color='#cccccc'>●</font>" ;
		}
		
		return mark ;
	}

	/*
	 * Timestamp 를 날짜형식으로 바꿔 주는 함수
	 * TODO - 로케일 적용
	 * format은  yyyy -연도, MM - 월, dd - 일, HH - 시, mm - 분, ss - 초
	*/
	public static String timestampToDateTime(String timestamp, String format) {
		if(timestamp == null || "".equals(timestamp)) return "" ;
		String ret = "" ;
		
		try {
			DateFormat formatter = new SimpleDateFormat(format);
			long temp = Long.valueOf(timestamp) * 1000;
			
			Calendar calendar = Calendar.getInstance();
			calendar.setTimeInMillis(temp);
			
			ret = formatter.format(calendar.getTime());
		}
		catch (NumberFormatException e){
			System.out.println("NumberFormatException : "+timestamp) ;
		}
		
		return ret ;
	}
	
	public static String timestampToDateTime(String timestamp) {
		return timestampToDateTime(timestamp, "yyyy/MM/dd HH:mm:ss");
	}
%>