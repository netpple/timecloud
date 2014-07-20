package com.twobrain.common.util;

public class JavaScript {

	private static String SCRIPT_PREFIX = "<script type=\"text/javascript\">";
	private static String SCRIPT_SUFFIX = "</script>";
	private JavaScript(){}
	public static String redirect(String msg, String url) {
		String out = "" ;
		out = alert( msg ) ;
		out += redirect(url) ;
		return write(out) ;
	}
	
	public static String redirect(String url) {
		String out = "" ;
		if(url != null && !"".equals(url.trim()) ){
			out = ("location.replace(\""+url+"\")") ;
		}
		
		return out ;
	}
	
	public static String alert(String msg) {
		String out = "" ;
		if(msg != null && !"".equals(msg.trim()) ){
			out = ("alert(\"" + msg + "\"); ") ;
		}

		return out ;
	}
	
	public static String write(String script) {
		StringBuilder sb = new StringBuilder();
		
		sb.append(SCRIPT_PREFIX);
		sb.append(script);
		sb.append(SCRIPT_SUFFIX);
		
		return sb.toString();
	}
}