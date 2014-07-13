package com.twobrain.chart;

class ChartControlsNode {
	
	Axis haxis ;
	Axis vaxis ;
	ZoomSlider zs ;
	Mouse mouse ;
	Legend legend ;
	Label label ;
	
	protected ChartControlsNode () {
		haxis = new Axis () ;
		vaxis  = new Axis () ;
		zs = new ZoomSlider() ;
		mouse = new Mouse () ;
		legend = new Legend() ;
		label = new Label() ;
		
		// -- Default
		reset() ;	
	}
	
	class Axis {
		String title = "" ;
		int labelangle = 0 ;
		int fontsize = 0 ;
		double interval = 0 ;	// -- DEFAULT 는 차트에서 자동으로 설정하도록 0임. 1로 할 경우, AIXS MAX수치가 클 경우 AXIS RENDERING 시 엄청난 부하 초래
		double minimum = 0 ;	// -- 0 - NO USE
		double maximum = 0 ;	// -- 0 - NO USE
		
		void reset() {
			title = "" ;
			labelangle = 0 ;
			fontsize = 0 ;
			interval = 0 ;
			minimum = 0 ;
			maximum = 0 ;
		}
	}
	
	class ZoomSlider {
		boolean enabled = false ;
		double minimum = -1 ;	// -- enabled = true 일때만 유효, DEFAULT 0.5 
		double maximum = -1 ;	// -- enabled = true 일때만 유효, DEFAULT 2
		String horizontalAlign = "left" ;	// -- 차트 영역 상의 수평 위치 - left, center, right
		String verticalAlign = "top" ;	// --  차트 영역 상의 수직 위치 - top, middle, bottom
		
		void reset() {
			enabled = false ;
			minimum = -1 ;	// -- enabled = true 일때만 유효, DEFAULT 0.5 
			maximum = -1 ;	// -- enabled = true 일때만 유효, DEFAULT 2
			horizontalAlign = "left" ;
			verticalAlign = "top" ;
		}
	}
	
	class Mouse {
		String wheel = "disabled" ;
		String drag = "disabled" ;
		double zoomDefault = 1 ;	// -- Chart 최초 로딩 시 기본으로 보여지는 배율
		
		void reset() {
			wheel = "disabled" ;
			drag = "disabled" ;
			zoomDefault = 1 ;
		}
	}
	
	class Legend {
		int cols = 1 ;
		String horizontalAlign = "right" ;
		String verticalAlign = "bottom" ;
		String template = "" ;	// -- PieChart에서 사용하는 Legend template. 변수는 title, value, rate가  있음. 예) title (value, rate%) --> 제조 (23pts, 50%)
		
		void reset() {
			cols = 1 ;
			horizontalAlign = "right" ;
			verticalAlign = "bottom" ;
			template = "" ;
		}
	}
	
	class Label {
		String position = "" ;	// -- PieChart의 callout 위치임 - { insideWithCallout, none, outside, inside, callout }
		String template = "" ;

		void reset() {
			position = "" ;
			template = "" ;
		}
	}
	
	public String getControlsNode() {
		String hAxisFontSize = (haxis.fontsize > 0)?" fontsize=\""+haxis.fontsize+"\" " : "" ;
		String vAxisFontSize = (vaxis.fontsize > 0)?" fontsize=\""+vaxis.fontsize+"\" " : "" ;
		String hAxisInterval = (haxis.interval > 0)?" interval=\""+haxis.interval+"\" " : "" ;
		String vAxisInterval = (vaxis.interval > 0)?" interval=\""+vaxis.interval+"\" " : "" ;
		String hAxisMinimum  = (haxis.minimum != 0)?" minimum=\""+haxis.minimum+"\" " : "" ;
		String hAxisMaximum  = (haxis.maximum != 0)?" maximum=\""+haxis.maximum+"\" " : "" ;
		String vAxisMinimum  = (vaxis.minimum != 0)?" minimum=\""+vaxis.minimum+"\" " : "" ;
		String vAxisMaximum  = (vaxis.maximum != 0)?" maximum=\""+vaxis.maximum+"\" " : "" ;
		
		StringBuffer controlsNode = new StringBuffer() ; 
			controlsNode
				.append("<controls><axis><horizontal title=\"")
					.append(haxis.title)
					.append("\" labelangle=\"").append(haxis.labelangle).append("\"")
					.append(hAxisFontSize)
					.append(hAxisInterval)
					.append(hAxisMinimum)
					.append(hAxisMaximum)					
				.append("/><vertical title=\"")
					.append(vaxis.title)
					.append("\" labelangle=\"").append(vaxis.labelangle).append("\"")
					.append(vAxisFontSize)
					.append(vAxisInterval)
					.append(vAxisMinimum)
					.append(vAxisMaximum)					
				.append("/></axis><mouse wheel=\"")
					.append(mouse.wheel).append("\" drag=\"")
					.append(mouse.drag).append("\" zoomdefault=\"")
					.append(mouse.zoomDefault)
				.append("\" /><zoomslider enabled=\"")
					.append(zs.enabled).append("\" ") ;
				
				if(zs.enabled) {	// -- 사용자가 직접 지정하지 않을 경우, 차트 컴포넌트의 기본값인 minimum=0.5, maximum=2 적용됨.
					if( zs.minimum > 0 )controlsNode.append("minimum=\""+zs.minimum+"\"") ;
					if( zs.maximum > 0 )controlsNode.append("maximum=\""+zs.maximum+"\"") ;
					controlsNode.append("horizontalalign=\"").append(zs.horizontalAlign).append("\"") ;
					controlsNode.append("verticalalign=\"").append(zs.verticalAlign).append("\"") ;
				}
				
				controlsNode.append("/><legend cols=\"")
					.append(legend.cols).append("\" horizontalalign=\"")
					.append(legend.horizontalAlign).append("\" verticalalign=\"")
					.append(legend.verticalAlign).append("\"><![cdata[")
					.append(legend.template)
					.append("]]></legend><label><position>")
					.append(label.position).append("</position><template><![cdata[")
					.append(label.template).append("]]></template></label></controls>") ;
		
		// -- System.out.println( controlsNode ) ;
		return controlsNode.toString() ;
	}
	
	public void reset() {
		haxis.reset() ;
		vaxis.reset() ;
		mouse.reset() ;
		zs.reset() ;
		legend.reset();
		label.reset() ;
	}
}