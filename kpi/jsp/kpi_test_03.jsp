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
	chartXml.appendSeriesName( "전체" ) ; chartXml.appendSeriesColor("0x2666af") ;
	chartXml.appendSeriesName( "부서" ) ; chartXml.appendSeriesColor("0xeb6100") ;
	chartXml.appendSeriesName( "개인" ) ; chartXml.appendSeriesColor("0x6c72d") ;
	// --
	chartXml.setLegendColumnCnt( 3 ) ;	chartXml.setLegendHorizontalAlign( "right" ) ; chartXml.setLegendVerticalAlign( "bottom" ) ;
	chartXml.setZoomDefaultRate( 1.5 ) ; // -- 차트 로딩 시 초기 배율 
	chartXml.setMouseWheelEnabled( true );  chartXml.setMouseDragEnabled( true ) ;
	// --
	chartXml.appendCategory("유지보수") ;
	chartXml.appendSeries("20") ;
	chartXml.appendSeries("15") ;
	chartXml.appendSeries("10") ;

	chartXml.appendCategory("하자보수") ;
	chartXml.appendSeries("20") ;
	chartXml.appendSeries("14") ;
	chartXml.appendSeries("14") ;

	chartXml.appendCategory("신규개발") ;
	chartXml.appendSeries("23") ;
	chartXml.appendSeries("11") ;
	chartXml.appendSeries("5") ;
	
	chartXml.appendCategory("사업관리") ;
	chartXml.appendSeries("22") ;
	chartXml.appendSeries("15") ;
	chartXml.appendSeries("14") ;
	
	chartXml.appendCategory("프로젝트") ;
	chartXml.appendSeries("25") ;
	chartXml.appendSeries("13") ;
	chartXml.appendSeries("5") ;

	
	int chartHeight = 127, chartWidth = 227 ;
	Chart chart = chartUtil.radarChart( chartXml.createChartXml(), chartWidth, chartHeight ) ;	
%><input type='hidden' id='info_report' value='영역별 등록 집계<%=__INFO_DELIM__ + thisFilename %>' />				
<div width="100%" style='padding:0;margin:0'><%=chart.getChart() %></div>