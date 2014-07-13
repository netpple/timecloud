package com.twobrain.common.config;

import java.io.InputStream;
import java.util.Locale;
import java.util.Properties;
import java.util.ResourceBundle;

public class Config {

	public static Properties getProp(String strPropName) throws Exception {

		Properties props = new Properties();

	  	try {
	  		InputStream in = ClassLoader.getSystemResourceAsStream(strPropName + ".properties");

	  		props.load(in);

	  	} catch(Exception ex) {
			throw new Exception("[Config getProp()] Exception "+ ex.toString() + " property file: " + strPropName + ".properties");
      	}

		return props;
	}

	public static String getProperty(String strPropName, String strKey) {
		return getProperty(strPropName,strKey,Locale.getDefault());
	}
	
	public static int getIntProperty(String strPropName, String strKey) {
		return getIntProperty(strPropName,strKey,Locale.getDefault());
	}	

	public static int getIntProperty(String strPropName, String strKey, Locale locale) {
		String strValue = null;

		try{
		    strValue = getBundle(strPropName,locale).getString(strKey);
		}catch(Exception e){
			System.err.println("[Config getProperty()] Exception " + e.toString() + " property file: " + strPropName + ".properties");
		}

		return Integer.parseInt(strValue);
	}	
	
	public static String getProperty(String strPropName, String strKey, Locale locale) {
		String strValue = null;

		try{
		    strValue = getBundle(strPropName,locale).getString(strKey);
		}catch(Exception e){
			System.err.println("[Config getProperty()] Exception " + e.toString() + " property file: " + strPropName + ".properties");
		}

		return strValue;
	}

	public static ResourceBundle getBundle(String strPropName) {
		return getBundle(strPropName,Locale.getDefault());
	}

	public static ResourceBundle getBundle(String strPropName, Locale locale) {
	    ResourceBundle rb = null;

		try{
		    rb = ReloadablePropertyResourceBundle.getResourceBundle(strPropName,locale);
		}catch(Exception e){
			System.err.println("[Config getProperty()] Exception " + e.toString() + " property file: " + strPropName + ".properties");
		}

		return rb;
	}
}
