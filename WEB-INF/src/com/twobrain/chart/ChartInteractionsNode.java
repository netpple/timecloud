package com.twobrain.chart;

import java.util.ArrayList;

class ChartInteractionsNode {
	
	private static final String __CHART_INTERACTION_SINGLE__ = "single" ;
	private static final String __CHART_INTERACTION_MULTIPLE__ = "multiple" ;

	private static final int __CHART_INTERACT_URL__ = 1 ;
	private static final int __CHART_INTERACT_XML__ = 2 ;
	
	ArrayList<Interaction> interactions ;
	String mode = __CHART_INTERACTION_SINGLE__ ; // -- single
	
	class Interaction {
		String target = "" ;
		int type = 0 ;
		String value = "" ;
	}
	
	ChartInteractionsNode () {
		interactions = new ArrayList<Interaction>() ;	
	}
	
	protected void setMultipleMode() {
		this.mode = __CHART_INTERACTION_MULTIPLE__ ;
	}
	
	
	protected void appendInteractionXML(String target) {
		Interaction interaction = new Interaction() ;
		interaction.target = target ;
		interaction.type = __CHART_INTERACT_XML__ ;
		interaction.value = "" ;
		appendInteraction( interaction ) ;
	}

	protected void appendInteractionURL(String target,String url) {
		Interaction interaction = new Interaction() ;
		interaction.target = target ;
		interaction.type = __CHART_INTERACT_URL__ ;
		interaction.value = url ;
		appendInteraction( interaction ) ;		
	}
	
	private void appendInteraction(Interaction interaction){
		if(interaction == null)return ;
		interactions.add(interaction) ;
	}
	
	protected String getInteractionsNode() {
		StringBuffer interactionsNode = null ;
		
		int cnt = interactions.size() ;
		if(cnt <=0)return "" ;
		interactionsNode = new StringBuffer() ;
		
		Interaction interaction = null ;
		interactionsNode.append("<interactions mode=\""+mode+"\">") ;
		for (int i=0;i<cnt;i++) {
			interaction = interactions.get(i) ;
			interactionsNode.append("<interaction")
			.append(" target=\"").append(interaction.target)
			.append("\" type=\"").append(interaction.type)
			.append("\" value=\"").append(interaction.value)
			.append("\" />") ;
		}
		interactionsNode.append("</interactions>") ;

		return interactionsNode.toString() ;
	}
}