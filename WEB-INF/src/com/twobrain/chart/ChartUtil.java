package com.twobrain.chart;

public class ChartUtil{
	// -- Chart Constants 
	private static final int __CHART_COLUMN__ = 1 ;
	private static final int __CHART_PIE__ = 2 ;
	private static final int __CHART_LINE__ = 3 ;
	private static final int __CHART_PLOT__ = 4 ;
	private static final int __CHART_AREA__ = 5 ;
	private static final int __CHART_BAR__ = 6 ;
	private static final int __CHART_BUBBLE__ = 7 ;
	private static final int __CHART_RADAR__ = 8 ;
	
	// -- Basic Delim.
	private static final char __DELIM__ = 7 ;
	private static final String __CHART_INFO_DELIM__ = ""+__DELIM__ ;	// -- chart.js 에도 선언돼 있음
	
	private static final int __DEFAULT_CHART_WIDTH__ = -1 ;	// -- 0보다 작으면 100%
	private static final int __DEFAULT_CHART_HEIGHT__ = 350 ;	// -- 상동
	
	// -- function for chart
	private int CHART_SEQ = 0 ;	// -- FOR DYNAMIC CHART NAMING - 차트 Naming 을 자동화하기 위한 시퀀스임.
	

	/**
	 * 	flash & html 중첩 문제 등을 해결 하기 위해 wmode 설정
	 *  [Value] 
	 *  Default - Flash가 최상위, Opaque - 
	 *  Flash위에 Html (퍼포먼스문제발생), 
	 *  Transparent - Flash를 투명하게 하여 아래의 HTML을 보임. 단, 마우스 스크롤 등의 이벤트가 swf에서 동작 안함 
	 *  direct - ?, 
	 *  gpu - GPU 하드웨어 가속 기능 사용
	 **/
	private String wmode = "default" ;
	public void setWmode (String wmode) {	this.wmode = wmode ; }
	public String getWmode () {	return this.wmode ;	}
		
	private String getChartId() {
		return "chart" + CHART_SEQ++ ;
	}
	// -- columnChart
	public Chart columnChart(String xml, int h) {	// -- 높이만 고정, width=100%
		return columnChart(xml, -1, h) ;
	}
	
	public Chart columnChart(String xml, int w, int h) {
		return getChart(getChartId(), xml, null,  __CHART_COLUMN__, w, h) ;
	}
	
	public Chart columnChart(String xml)	{
		return columnChart(getChartId(), xml) ;
	}
	
	public Chart columnChart(String chartId, String xml) {
		return columnChart(chartId, xml, null) ;
	}
	
	public Chart columnChart(String chartId, String xml, String chartPoolId) {
		return getChart(chartId, xml, chartPoolId,  __CHART_COLUMN__) ;
	}
	// -- pieChart
	public Chart pieChart(String xml, int h) {	// -- 높이만 고정, width=100%
		return pieChart(xml, -1, h) ;
	}
	
	public Chart pieChart(String xml, int w, int h) {
		return getChart(getChartId(), xml, null,  __CHART_PIE__, w, h) ;
	}
	
	public Chart pieChart(String xml)	{
		return pieChart(getChartId(), xml) ;
	}

	public Chart pieChart(String chartId, String xml) {
		return pieChart(chartId, xml, null) ;
	}
	
	public Chart pieChart(String chartId, String xml, String chartPoolId) {
		return getChart(chartId, xml, chartPoolId,  __CHART_PIE__) ;
	}
	// -- lineChart
	public Chart lineChart(String xml, int h) {	// -- 높이만 고정, width=100%
		return lineChart(xml, -1, h) ;
	}
	
	public Chart lineChart(String xml, int w, int h) {
		return getChart(getChartId(), xml, null,  __CHART_LINE__, w, h) ;
	}

	public Chart lineChart(String xml)	{
		return lineChart(getChartId(), xml) ;
	}

	public Chart lineChart(String chartId, String xml) {
		return lineChart(chartId, xml, null) ;
	}
	
	public Chart lineChart(String chartId, String xml, String chartPoolId) {
		return getChart(chartId, xml, chartPoolId,  __CHART_LINE__) ;
	}
	// -- plotChart
	public Chart plotChart(String xml, int h) {	// -- 높이만 고정, width=100%
		return plotChart(xml, -1, h) ;
	}
	
	public Chart plotChart(String xml, int w, int h) {
		return getChart(getChartId(), xml, null,  __CHART_PLOT__, w, h) ;
	}

	public Chart plotChart(String xml)	{
		return plotChart(getChartId(), xml) ;
	}

	public Chart plotChart(String chartId, String xml) {
		return plotChart(chartId, xml, null) ;
	}
	
	public Chart plotChart(String chartId, String xml, String chartPoolId) {
		return getChart(chartId, xml, chartPoolId,  __CHART_PLOT__) ;
	}
	// -- areaChart
	public Chart areaChart(String xml, int h) {	// -- 높이만 고정, width=100%
		return areaChart(xml, -1, h) ;
	}	

	public Chart areaChart(String xml, int w, int h) {
		return getChart(getChartId(), xml, null,  __CHART_AREA__, w, h) ;
	}

	public Chart areaChart(String xml)	{
		return areaChart(getChartId(), xml) ;
	}

	public Chart areaChart(String chartId, String xml) {
		return areaChart(chartId, xml, null) ;
	}
	
	public Chart areaChart(String chartId, String xml, String chartPoolId) {
		return getChart(chartId, xml, chartPoolId,  __CHART_AREA__) ;
	}
	// -- barChart
	public Chart barChart(String xml, int h) {	// -- 높이만 고정, width=100%
		return barChart(xml, -1, h) ;
	}	

	public Chart barChart(String xml, int w, int h) {
		return getChart(getChartId(), xml, null,  __CHART_BAR__, w, h) ;
	}

	public Chart barChart(String xml)	{
		return barChart(getChartId(), xml) ;
	}

	public Chart barChart(String chartId, String xml) {
		return barChart(chartId, xml, null) ;
	}
	
	public Chart barChart(String chartId, String xml, String chartPoolId) {
		return getChart(chartId, xml, chartPoolId,  __CHART_BAR__) ;
	}
	// -- bubbleChart
	public Chart bubbleChart(String xml, int h) {	// -- 높이만 고정, width=100%
		return bubbleChart(xml, -1, h) ;
	}
	
	public Chart bubbleChart(String xml, int w, int h) {
		return getChart(getChartId(), xml, null,  __CHART_BUBBLE__, w, h) ;
	}

	public Chart bubbleChart(String xml)	{
		return bubbleChart(getChartId(), xml) ;
	}

	public Chart bubbleChart(String chartId, String xml) {
		return bubbleChart(chartId, xml, null) ;
	}
	
	public Chart bubbleChart(String chartId, String xml, String chartPoolId) {
		return getChart(chartId, xml, chartPoolId,  __CHART_BUBBLE__) ;
	}
	// -- radarChart
	public Chart radarChart(String xml, int h) {	// -- 높이만 고정, width=100%
		return radarChart(xml, -1, h) ;
	}
	
	public Chart radarChart(String xml, int w, int h) {
		return getChart(getChartId(), xml, null,  __CHART_RADAR__, w, h) ;
	}

	public Chart radarChart(String xml)	{
		return radarChart(getChartId(), xml) ;
	}

	public Chart radarChart(String chartId, String xml) {
		return radarChart(chartId, xml, null) ;
	}
	
	public Chart radarChart(String chartId, String xml, String chartPoolId) {
		return getChart(chartId, xml, chartPoolId,  __CHART_RADAR__) ;
	}
	/* -- -- */
	private Chart getChart( String chartId, String xml, String chartPoolId, int chartType ) {
		return getChart(chartId, xml, chartPoolId,  chartType, __DEFAULT_CHART_WIDTH__, __DEFAULT_CHART_HEIGHT__) ;
	}
		
	private Chart getChart( String chartId, String xml, String chartPoolId, int chartType, int chartWidth, int chartHeight ) {
		Chart chart = null ;
		StringBuffer sb = new StringBuffer() ;
		String poolId = ( chartPoolId == null || "".equals(chartPoolId) )?chartId+"POOL":chartPoolId ;
		String w = "100%", h = "100%" ;
		if(chartWidth > 0) w = "" + chartWidth ;
		if(chartHeight > 0) h = "" + chartHeight ;
		
		chart = new Chart() ;
		
		chart.setControls("<div class='chartZoom'>"
				/*
				+"<a href=\"javascript:chartZoomIn('"
				+poolId+"');\"><img src='images/main/btn_zoomin.gif' align='absmiddle' alt='zoom in'></a> <a href=\"javascript:chartZoomOut('"
				+poolId+"');\"><img src='images/main/btn_zoomout.gif' align='absmiddle' alt='zoom out'></a>"
				*/
				+"<a href=\"javascript:chartFullScreen('"
				+chartId+"','"+chartType+"');\"><img src='images/main/btn_zoomnormal.gif' align='absmiddle' alt='full screen'></a></div>") ;
		
		sb.append("<div id='")
			.append(poolId) 
			.append("' style='width:"+w+";height:"+h+";' class='chartPool'></div><input type='hidden' id='info_chart' name='info_chart' value='")
			.append(poolId) 
			.append(__CHART_INFO_DELIM__) 
			.append(chartId)
			.append(__CHART_INFO_DELIM__) 
			.append(chartType) 
			.append(__CHART_INFO_DELIM__) 
			.append(w)
			.append(__CHART_INFO_DELIM__)
			.append(h)
			.append(__CHART_INFO_DELIM__)
			.append( getWmode() )			
			.append( "' />");
			
		if ( xml != null ) {
			sb.append("<input type='hidden' id='")
				.append(chartId)
				.append("XML' name='") 
				.append(chartId) 
				.append("XML' value='") 
				.append(xml) 
				.append("'/>" ) ;
		}
		
		chart.setChart(sb.toString()) ;
		return chart ;
	}
}