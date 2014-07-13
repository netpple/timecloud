<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ include file="incCommon.jspf"%><%@ page import="java.util.*, java.text.DateFormat, java.text.SimpleDateFormat" %><%@ include file="incCommonUtil.jspf"%><%
	final String nowUrl = request.getRequestURI() ;
	String thisFilename = nowUrl.substring(nowUrl.lastIndexOf("/")+1) ;
	String thisFilenameNoExt = thisFilename.substring(0,thisFilename.lastIndexOf(".")) ;
	
	System.out.println( "URI : " + nowUrl ) ;
	System.out.println( "Filename : " + thisFilename ) ;
	System.out.println( "FilenameNoExt : " + thisFilenameNoExt ) ;

	// -- Chart Sample
	ChartUtil chartUtil = new ChartUtil() ;
	ChartXml chartXml = new ChartXml() ;
	// --	
	chartXml.appendSeriesName( "등록집계" ) ;
	chartXml.appendSeriesName( "조회집계" ) ;
	chartXml.appendSeriesName( "답글집계" ) ;
	// --
	chartXml.setLegendHorizontalAlign("left") ;
	chartXml.setLegendVerticalAlign("bottom") ;
	chartXml.setLegendColumnCnt(3) ; // -- per row
	// --
	chartXml.appendCategory("경기관리") ;
	chartXml.appendSeries("10") ;	// -- no.risk.regist
	chartXml.appendSeries("20") ;	// -- no.p.propa
	chartXml.appendSeries("15") ;	// -- no.action

	chartXml.appendCategory("상품관리") ;
	chartXml.appendSeries("14") ;	// -- no.risk.regist
	chartXml.appendSeries("20") ;	// -- no.p.propa
	chartXml.appendSeries("14") ;	// -- no.action

	chartXml.appendCategory("프로젝트관리") ;
	chartXml.appendSeries("11") ;	// -- no.risk.regist
	chartXml.appendSeries("23") ;	// -- no.p.propa
	chartXml.appendSeries("5") ;	// -- no.action

	int chartHeight = 127 ;
	Chart chart = chartUtil.columnChart( chartXml.createChartXml(), chartHeight ) ;	
%><input type='hidden' id='info_report' value='매뉴얼 활용 현황<%=__INFO_DELIM__ + thisFilename %>' />				
<div width="100%" style='padding:0;margin:0'><%=chart.getChart() %></div>