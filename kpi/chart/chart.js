/* --
	@Concept
	
	차트를 원하는 영역에 원하는 종류의 차트를 동적생성하는  라이브러리임.
	
	ChartPool - 차트를 추가할 영역 (Div 등)
	Chart - 차트 Object (Flash Component - Object Tag)
	ChartArea - 차트 출력 영역 ( Div Tag, 자동생성 - ${chartId + "Area"} )
	ChartXML - 차트 데이터 ( Naming Rule - ${chartId + "XML"} )
	
	
	@Variables
	chartPoolId - 차트를 출력할 영역 id
	chartId - 차트 id	* 차트XML hidden 컴포넌트 id는 반드시  ${chartId + "XML"} 로 작명
						예) chartId가 myPieChart라면, 차트XML용 HIDDEN Component는 다음과 같음.
							<input type='hidden' id='myPieChartXML' value=' ...
	width - 차트 너비
	height - 차트 높이
	
	@Examples
	// -- 차트 XML - <input type='hidden' id='pieChart1XML' ...
	// -- 차트 출력 Pool - <div id='chartPool1' ..
	// -- 차트 출력 Script - addChart("chartPool1","pieChart1","1","500","500") ;
	addChart("chartPool1","columnChart1","1","100%","100%") ; // -- <input type='hidden' id='columnChart1XML' ...
	addChart("chartPool2","pieChart2","2","500","500") ; // -- <input type='hidden' id='pieChart2XML' ...
	addChart("chartPool3","myPieChart","2","500","500") ; // -- <input type='hidden' id='myPieChartXML' ...
	addChart("chartPool4","columnChart2","1","500","500") ; // -- <input type='hidden' id='columnChart2XML' ...
	addChart("chartPool5","pieChart3","2","300","300") ; // -- <input type='hidden' id='pieChart3XML' ...
-- */
	var __CHART_CONTAINER_SWF__ = "ChartContainer" ;
	var __CHART_ROOT__ = "./" ;	// -- 배포용은 "chart/", DEBUG용은 "chart-debug/", FLEX BUILDER 테스트용은 "./"
	var __CHART_SWF_VER__ = "10.0.0";
	
	// -- 외부스크립트에서 셋팅하는 변수
	var def_flashvars = {} ;
	def_flashvars.xmlurl ;
	def_flashvars.chartid ;
	def_flashvars.chartbaseurl = __CHART_ROOT__ ;	// -- css language swf의 assets 경로임. 
	def_flashvars.lang = "" ;	// -- ko, zh, en * null 일 경우에는 대상 css lang swf를 사용하지 않는다.
	// -- 
	

	function drawChart() {
		var chartinfo = document.getElementsByName("info_chart") ;
		var chartcnt = chartinfo.length ;
		debug(chartcnt) ;
		
		if(chartinfo != null && chartinfo.length > 0) {
			for(i=0;i<chartcnt;i++) {
				chart( chartinfo[i].value ) ;
			}
		}
	}
	
	var __CHART_INFO_DELIM__  = "" ;
	function chart( chartinfo ) {
		cinfos = chartinfo.split( __CHART_INFO_DELIM__ ) ;	// -- __CHART_INFO_DELIM__
		if(cinfos == null || cinfos.length != 6) {	// -- width, height 정보 추가
			alert ("Check chart params - " + chartinfo ) ; 
			return ;
		}
		debug( cinfos[0] + "," + cinfos[1] + "," + cinfos[2] + "," + cinfos[3] + "," + cinfos[4] +"," + cinfos[5] ) ;
		// -- cinfos[0]	// -- chartPoolId
		// -- cinfos[1]	// -- chartId
		// -- cinfos[2] // -- chartType 1 - Column Chart, 2 - Pie Chart - defined chart component & incCommon.jspf
		// -- cinfos[3] // -- chartWidth
		// -- cinfos[4] // -- chartHeight
		// -- cinfos[5] // -- wmode "" - default, "transparent" - 메뉴 레이어 중첩 문제 등 발생 시 사용
		
		var w = cinfos[3] ;
		var h = cinfos[4] ;
		var wmode = cinfos[5] ;
		
		addChart( cinfos[0], cinfos[1], cinfos[2], w, h, wmode ) ;
	}
	
	/*
	 * Parameter
	 * chartPoolId - Chart Area Id (div element ... and so on ) 
	 * chartId - Chart SWF Object Id
	 * chartType - 1 : Column Chart, 2 : Pie Chart, ...  ~ defined NexgensChartFactory.as, Chart.java
	 * 	w - width( px or percent with '%' )
	 * 	h - height(px or percent with '%' )
	 * wmode - Default : Flash가 최상위, Opaque : Flash위에 Html (퍼포먼스문제발생), Transparent : Flash를 투명하게 하여 아래의 HTML을 보임, direct : ?, gpu : GPU 하드웨어 가속 기능 사용 
	* History
	* 20120307 - 'wmode' 파라메터 추가 
	* 20111114 - charttype 추가함. chartSwf는 불필요. 차트 컨테이너로 통일
	*/
	function addChart(chartPoolId, chartId, chartType, w, h, wmode) { 
		if(chartType < 0) return ;
		var chartSwf = __CHART_CONTAINER_SWF__ ;
		
		var chart = document.getElementById( chartId ) ;
		if( chart != null ) {
			alert ( "Chart가 이미 존재합니다." ) ;
			return ;
		}
		
		if(w == null || w == "" || w <= 0)w = "100%" ;
		if(w == null || w == "" || h <= 0)h = "100%" ;
		
		// -- get Chart Pool (DIV)
		var pool = document.getElementById( chartPoolId ) ;
		if ( pool == null ) {
			alert ( "ChartPool이 존재하지 않습니다 - " + chartPoolId ) ;
			return ;
		}
		
		// -- create DIV for chart
		chartAreaId = chartId + "Area" ;	// -- 동적생성..사용자는 몰라도됨
		
		var newChartDiv = document.createElement("div") ;
		newChartDiv.id = chartAreaId ;
		// --newChartDiv.innerText = 
		debug ( "NEW CHART DIV AREA ADDED.. ID is " + newChartDiv.id ) ;
		pool.appendChild( newChartDiv ) ;
		
		// -- debug ( document.getElementById( chartId ) ) ;
		
		// -- flashvars
		var flashvars = {};
		flashvars.chartid = chartId ;
		flashvars.charttype = chartType ;	// -- charttype : 1 - column, 2 - pie, ...
		flashvars.chartbaseurl = def_flashvars.chartbaseurl ;
		flashvars.lang = def_flashvars.lang ;

		if ( w.indexOf('%')>0 || h.indexOf('%')>0 ) {
			flashvars.resizablewindow = "true" ;			
		}
		else {
			flashvars.resizablewindow = "false" ;
		}

		debug( flashvars.charttype ) ; 
        // --

        var params = {};
        params.quality = "high";
        params.bgcolor = "#ffffff" ;
        params.allowscriptaccess = "sameDomain";
        params.allowfullscreen = "true";
        // -- 20120306 by Sam Kim - 메뉴 레이어 중첩 발생 시 사용
        if( wmode != "" ) {
        	params.wmode = wmode ;	// -- Default - Flash가 최상위, Opaque - Flash위에 Html (퍼포먼스문제발생), Transparent - Flash를 투명하게 하여 아래의 HTML을 보임, direct - ?, gpu - GPU 하드웨어 가속 기능 사용   	
        } 
        // --

        var attributes = {};
        attributes.id = chartId ;	// -- ex) DynamicColumnChart, DynamicPieChart
        attributes.name = chartId ;
        attributes.align = "middle";
		
        debug(def_flashvars.chartbaseurl + chartSwf) ;
        swfobject.embedSWF(
        		def_flashvars.chartbaseurl + chartSwf + ".swf"	// -- swf filename
            , chartAreaId		// -- div for chart
            , w, h				// -- size
            , __CHART_SWF_VER__, def_flashvars.chartbaseurl+"playerProductInstall.swf"
            , flashvars			// -- flashvars - flash 내에서 사용할 값들
            , params, attributes);

		swfobject.createCSS("#" + chartAreaId, "display:block;text-align:left;");
	}

// -- Chart Zoom In/Out 
	function chartZoomIn(poolId) {
		var obj = document.getElementById(poolId) ;
		if (obj == null)return ;
		chartZoomAction(obj, .1) ;
	}
	
	function chartZoomOut(poolId) {
		var obj = document.getElementById(poolId) ;
		if (obj == null)return ;
		chartZoomAction(obj, -.1) ;
	}
	
	function chartZoomAction(obj, rate) {
		var px = obj.style.height ;
		var pos = px.indexOf("px") ;
		var val = px.substr(0,pos) ;
		
		var px2 = obj.style.width ;
		var pos2 = px2.indexOf("px") ;
		var val2 = px2.substr(0,pos2) ;
		
		if(val > 0)obj.style.height = val * (1+rate) ;
		else obj.style.height="350" ;
		
		if(val2 > 0)obj.style.width = val2 * (1+rate) ;
		else obj.style.width = "100%" ;
	}
	
	var _nowFullChartId = "" ;
	var _nowFullChartType = -1 ;

	function chartFullScreen(chartId, chartType) {
		var w = document.body.scrollWidth ;  // -- document.documentElement.offsetWidth ; // -- NON-IE
		// -- var h = document.body.scrollHeight ; // -- document.documentElement.offsetHeight ; // -- NON-IE

		var sw = screen.width ;
		var sh = screen.height ;
		
		if(w<500)w=500 ;
		var h = w * (sh/sw) ; // -- 높이를 화면 비로 구한다.
		
		var x = (sw - w)/2 ;
		var y = (sh - h)/2 ;
		
		chartFullScreenAction(chartId, chartType, w, h, x, y) ;
	}
	
	function chartFullScreenAction(chartId, chartType, w, h, x, y) {
		_nowFullChartId = chartId ;
		_nowFullChartType = chartType ;
		
		var pop = window.open('kpi_chart_popup.html','chartPop','width='
					+w+',height='
					+h+',left='
					+x+',top='
					+y+',scrollbars=no,resizable=yes') ;
		pop.focus() ;
	}
	
// -- Command
	function command( chartId, sCommand, sParam ) {
		var fobj = document.getElementById ( chartId ) ;
		if(fobj == null) {
			alert ( "해당 차트 div가 없습니다 - " + chartId ) ; 
			return ;
		}
		fobj.command ( sCommand, sParam ) ;
	}
	
	// -- CHART에 CHART DATA(XML) URL을 넘겨주는 함수
	function commandURL( chartId, xmlUrl ) {
		if(chartId == "")return ;
		if(xmlUrl == null | xmlUrl == "")return ;
		command ( chartId, "URL", xmlUrl ) ;
	}
	
	// -- HIDDEN COMPONENT로 부터 CHART DATA(XML) 값을 넘겨주는 함수
	function commandXML( chartId ) {
		if(chartId == "")return ;
		
		var xml = getChartXML ( chartId ) ;
		if ( xml == null ) return ;
		
		debug(xml.value) ;
		
		command ( chartId, "XML", xml.value ) ;
	}

	function commandRESET ( chartId ) {
		if(chartId == "")return ;
		command ( chartId, "RESET", "" ) ;
	}
	
	// -- GET HIDDEN component for Chart Data (XML)
	function getChartXML ( chartId ) {
		var xml = document.getElementById( chartId + "XML") ; // -- document.getElementsByName( chartId + "XML" ) ;	// -- 규칙
		if(xml == null || xml.value == "")	{
			alert( chartId + "XML이 존재하지 않습니다." ) ;
			return null ;
		}
		// -- return xml[0] ; // -- getElementsByName 으로 할 경우
		return xml ;
	}
	
// -- chart callback function -- CHART 초기화 완료 후 호출되는 콜백 함수 임. 여기서는 Javascript 기반의 로컬XML로 CHART를 초기화
	function chartLoadComplete ( chartId ) {
		debug("chart 초기화 성공 : " + chartId ); 
		commandXML ( chartId ) ;
	}
	
// -- chart interactions -- CHART SeriesItem Click 시 다른 차트 제어
	function interactChart(targetId, value) {
		if(targetId == null || value == null) return ;
		if(value.indexOf("<item>")<0) interactChartURL(targetId, value) ;
		else interactChartXML(targetId, value) ;
	}
	
	function interactChartXML(targetId, itemNodeStr) {
		var xml = document.getElementById(targetId+'XML') ;
		if(xml == null) return ;
		
		src = xml.value ;
		pos = src.indexOf("<item>") ;
		poe = src.lastIndexOf("</item>") ;

		if(pos <=0 || poe <=0 || poe<pos) return ;
		
		poe += "</item>".length ;
		
		xml.value = src.substring(0,pos) + itemNodeStr + src.substring(poe) ;	
		
		commandXML(targetId) ;
	}
	
	function interactChartURL(targetId, urlStr) {
		commandURL(targetId, urlStr) ;
	}

// --
	function debug ( msg ) {
		 // -- alert ( msg ) ;
	} 