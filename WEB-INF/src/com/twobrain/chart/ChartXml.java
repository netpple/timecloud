package com.twobrain.chart;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ChartXml{

	private ChartControlsNode  ccn;	// -- Controls Node 처리
	private ChartInteractionsNode cin ; // -- Interactions Node 처리
	private StringBuffer sbChartXml;
	private StringBuffer sbSeriesName;	// -- SERIES네임 셋팅
	private StringBuffer sbSeriesColors ;// -- SERIES별 컬러 셋팅용
	
	List<Map<String,String>> dataList;
	
	// 차트 만들기 생성
	public ChartXml(){
		ccn = new ChartControlsNode();
		cin = new ChartInteractionsNode() ;

		dataList = new ArrayList<Map<String,String>>();
		sbSeriesName = new StringBuffer();
		sbSeriesColors = new StringBuffer() ;
	}
	
	public void setMultipleSelection() { // -- Chart 내 시리즈를 여러 개 선택가능
		cin.setMultipleMode() ;
	}

	// 차트 만들기 컨트롤 method
	// 메세지를 HashMap으로 받는 이유는 haxis, vaxis의 title의 생성이 동적이기 때문임.
	public String createChartXml(){
		
		sbChartXml = new StringBuffer();
		
		sbChartXml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?><nexgens>");
		sbChartXml.append( ccn.getControlsNode() );
		sbChartXml.append( cin.getInteractionsNode() ) ;
		appendData();
		sbChartXml.append("</nexgens>");
		
		return sbChartXml.toString();
	}
	
	// -- append interaction
	public void appendInteractionXML(String target) {
		cin.appendInteractionXML(target) ;
	}
	
	public void appendInteractionURL(String target, String dataUrl) {
		cin.appendInteractionURL(target, dataUrl) ;
	}
	
	// 차트 만들기 data 태그 생성 method
	private void appendData(){

		sbChartXml.append("<data>"); 
		appendSeriesNames();
		appendSeriesColors() ;	
		appendItem();
		sbChartXml.append("</data>") ;
	}

	private void appendSeriesColors(){
		sbChartXml.append("<seriescolors>") ;
		if(sbSeriesColors.length() != 0){
			sbChartXml.append(sbSeriesColors.toString()) ;
		}
		sbChartXml.append("</seriescolors>") ;
	}

	// 차트 만들기 SeriesNames 태그 생성 method
	private void appendSeriesNames(){
		
		sbChartXml.append("<seriesnames>");
		if(sbSeriesName.length() != 0){
			sbChartXml.append(sbSeriesName.toString());		// -- 사용자명,열람율
		}
		sbChartXml.append("</seriesnames>");
	}

	// 차트 만들기 Item 태그 생성 method
	private void appendItem(){

		sbChartXml.append("<item>");
		
		Map<String,String> dataMap = null;
		for (int i = 0; i < dataList.size(); i++) {
			dataMap = dataList.get(i);
			
			if(dataMap != null){		
				if(dataMap.get("category") != null && !dataMap.get("category").equals("")){
					if(i != 0){
						sbChartXml.append("</item><item>");
					}

					sbChartXml.append("<category><![cdata[")
					.append(dataMap.get("category").toString())
					//.append(stringToHTMLString(dataMap.get("category").toString()))
					.append("]]></category>");
					
				} else if(dataMap.get("series") != null && !dataMap.get("series").equals("")){
					sbChartXml.append("<series>")
					.append(dataMap.get("series"))
					//.append(parseDouble(dataMap.get("series")))
					.append("</series>");
				}
			}
		}
		sbChartXml.append("</item>");
	}

	//horizontal tag title 속성값 setting
	public void setHorizontalAxisTitle(String strHorizontalAxisTitle){
		ccn.haxis.title = strHorizontalAxisTitle;
	}
	
	//vertical tag title 속성값 setting
	public void setVerticalAxisTitle(String strVerticalAxisTitle){
		ccn.vaxis.title = strVerticalAxisTitle;
	}
	
	//horizontal tag labelangle 속성값 setting
	public void setHorizontalAxisLabelangle(int iHorizontalAxisLabelangle){
		ccn.haxis.labelangle = iHorizontalAxisLabelangle;
	}
	
	//horizontal tag labelangle 속성값 setting
	public void setVerticalAxisLabelangle(int iVerticalAxisLabelangle){
		ccn.vaxis.labelangle = iVerticalAxisLabelangle;
	}
	
	//horizontal tag fontsize 속성값 setting
	public void setHorizontalAxisFontsize(int iHorizontalAxisFontsize){
		ccn.haxis.fontsize = iHorizontalAxisFontsize;
	}
	
	//vertical tag fontsize 속성값 setting
	public void setVerticalAxisFontsize(int iVerticalAxisFontsize){
		ccn.vaxis.fontsize = iVerticalAxisFontsize;
	}
	
	//horizontal tag fontsize 속성값 setting
	public void setHorizontalAxisInterval(double dHorizontalAxisInterval){
		ccn.haxis.interval = dHorizontalAxisInterval;
	}
	
	//vertical tag fontsize 속성값 setting
	public void setVerticalAxisInterval(double dVerticalAxisInterval){
		ccn.vaxis.interval = dVerticalAxisInterval;
	}

	public void setHorizontalAxisMinimum(int minimum){
		ccn.haxis.minimum = minimum;
	}

	public void setHorizontalAxisMaximum(int maximum){
		ccn.haxis.maximum = maximum;
	}

	public void setVerticalAxisMinimum(int minimum){
		ccn.vaxis.minimum = minimum;
	}

	public void setVerticalAxisMaximum(int maximum){
		ccn.vaxis.maximum = maximum;
	}
	
	//mouse tag wheel 속성값  setting
	public void setMouseWheelEnabled(boolean mouseWheelEnabled){
		if(!mouseWheelEnabled){
			ccn.mouse.wheel = "disabled";
		}else{
			ccn.mouse.wheel = "enabled";
		}
	}
	
	//mouse tag drag 속성값 setting
	public void setMouseDragEnabled(boolean mouseDragEnabled){
		if(!mouseDragEnabled){
			ccn.mouse.drag = "disabled";
		}else{
			ccn.mouse.drag = "enabled";
		}
	}
	
	//차트 로딩 시 기본 배율
	public void setZoomDefaultRate ( double defaultRate ) {
		ccn.mouse.zoomDefault = defaultRate ;
	}
	
	public void setZoomSliderEnabled( boolean enabled ) {
		ccn.zs.enabled = enabled ;
	}
	
	// minimum, minimum 속성값 settings - tickValues for zoomslider
	public void setZoomSliderRange(double minimum, double maximum){
		ccn.zs.minimum = minimum;
		ccn.zs.maximum = maximum;
	}
	
	public void setZoomSliderHorizontalAlign(String align) {
		ccn.zs.horizontalAlign = align ;
	}
	
	public void setZoomSliderVerticalAlign(String align) {
		ccn.zs.verticalAlign = align ;
	}
	
	//seriesname tag data setting
	public void appendSeriesName(String strSeriesName){ //seriesName은 여러개 등록이 가능, 구분자 ','
		if(sbSeriesName.length() == 0){
			sbSeriesName.append(strSeriesName);
		}else{
			sbSeriesName.append(","+strSeriesName);
		}
	}
	
	//seriescolor node data added
	public void appendSeriesColor(String strSeriesColor) {
		if(sbSeriesColors.length() == 0) {
			sbSeriesColors.append(strSeriesColor) ;
		}
		else {
			sbSeriesColors.append(","+strSeriesColor) ;
		}
	}
	
	// -- 
	public void setLabelTemplate(String strLabelStyleTemplate){
		this.ccn.label.template = strLabelStyleTemplate;
	}
	
	// -- For PieChart - callout위치 - { insideWithCallout, none, outside, inside, callout }
	public void setLabelPosition(String position) {
		this.ccn.label.position = position ;
	}
	
	//
	public void setLegendTemplate(String legendTemplate){
		this.ccn.legend.template = legendTemplate;
	}
	
	//
	public void setLegendColumnCnt(int count){
		this.ccn.legend.cols = count ;
	}
	
	public void setLegendHorizontalAlign(String align) {	// -- left, center, right
		this.ccn.legend.horizontalAlign = align ;
	}
	
	public void setLegendVerticalAlign(String align) {	// -- top, middle, bottom
		this.ccn.legend.verticalAlign = align ;
	}
	
	//category tag data 추가
	public void appendCategory(String categoryValue){
		Map<String,String> itemMap = new HashMap<String,String>();
		itemMap.put("category", categoryValue);
		dataList.add(itemMap);
	}
	
	//series tag data 추가
	public void appendSeries(String seriesValue){
		if(seriesValue==null || "".equals(seriesValue))seriesValue="0" ;
		Map<String,String> itemMap = new HashMap<String,String>();
		itemMap.put("series", seriesValue);
		dataList.add(itemMap);
	}
}