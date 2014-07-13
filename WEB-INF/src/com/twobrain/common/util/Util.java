package com.twobrain.common.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

public class Util {
	public static String getMD5Hash(String str){
		String MD5 = ""; 
		try{
			MessageDigest md = MessageDigest.getInstance("MD5"); 
			md.update(str.getBytes()); 
			byte byteData[] = md.digest();
			StringBuffer sb = new StringBuffer(); 
			for(int i = 0 ; i < byteData.length ; i++){
				sb.append(Integer.toString((byteData[i]&0xff) + 0x100, 16).substring(1));
			}
			MD5 = sb.toString();
			
		}catch(NoSuchAlgorithmException e){
			e.printStackTrace(); 
			MD5 = null; 
		}
		return MD5;
	}
	
	public static String getCookieValue(HttpServletRequest request, String key) {
		String value = "";
		
		Cookie[] cookies = request.getCookies();
		
		for(int i=0, count = cookies.length; i < count; i++ ){
			if(cookies[i].getName().equals(key)) {
				value = cookies[i].getValue();
			}
		}
		
		return value;
	}
	
	public static Cookie getCookie(HttpServletRequest request, String key) {
		Cookie cookie = null;
		
		Cookie[] cookies = request.getCookies();
		
		for(int i=0, count = cookies.length; i < count; i++ ){
			if(cookies[i].getName().equals(key)) {
				cookie = cookies[i];
			}
		}
		
		return cookie;
	}
	
	
}
