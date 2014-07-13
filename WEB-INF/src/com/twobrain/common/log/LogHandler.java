package com.twobrain.common.log;

import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.twobrain.common.config.Config;


public class LogHandler {

	private static boolean IS_DEBUG;
	private static boolean IS_INFO;
	private static boolean IS_ERROR;
	private static boolean IS_PRINT;

	static {
		init();
	}

	public static void init() {

		try {
			IS_DEBUG = Boolean.valueOf(Config.getProperty("log", "IS_DEBUG")).booleanValue();
			IS_INFO = Boolean.valueOf(Config.getProperty("log", "IS_INFO")).booleanValue();
			IS_ERROR = Boolean.valueOf(Config.getProperty("log", "IS_ERROR")).booleanValue();
        	IS_PRINT = Boolean.valueOf(Config.getProperty("log", "IS_PRINT")).booleanValue();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void debug(String msg) {
		if(IS_DEBUG) {
			PrintWriter logger = null;

			long currentDateTime = System.currentTimeMillis();

			try {

				String path = Config.getProperty("log", "LOG.DEBUG.SAVEPATH")
						+ getCurrentDate().substring(0, 6);

				String logFile = path + "/DEBUG." + new java.sql.Date(currentDateTime)+ ".log";

				File filePath = new File(path);

				if (!filePath.exists()) {
					filePath.mkdirs();
				}

				logger = new PrintWriter(new FileWriter(logFile, true), true);

				logger.println(" [ DEBUG ] [ " + new java.sql.Time(currentDateTime) + " ] " + msg);

	        } catch(Exception ex) {
				System.err.println("[DEBUG "+new java.sql.Date(currentDateTime)+" "+new java.sql.Time(currentDateTime)+"] Logger ERR toString : "+ex.toString());
				System.err.println("[DEBUG "+new java.sql.Date(currentDateTime)+" "+new java.sql.Time(currentDateTime)+"] Logger ERR Message : "+ex.getMessage());

			} finally {
				if(logger != null) logger.close();
			}
		}
	}

	public static void info(String msg) {
		if(IS_INFO) {
			PrintWriter logger = null;

			long currentDateTime = System.currentTimeMillis();

			try {

				String path = Config.getProperty("log", "LOG.INFO.SAVEPATH")
						+ getCurrentDate().substring(0, 6);

				String logFile = path + "/INFO." + new java.sql.Date(currentDateTime)+ ".log";

				File filePath = new File(path);

				if (!filePath.exists()) {
					filePath.mkdirs();
				}

				logger = new PrintWriter(new FileWriter(logFile, true), true);

				logger.println(" [ INFO ] [ " + new java.sql.Time(currentDateTime) + " ] " + msg);

	        } catch(Exception ex) {
				System.err.println("[INFO "+new java.sql.Date(currentDateTime)+" "+new java.sql.Time(currentDateTime)+"] Logger ERR toString : "+ex.toString());
				System.err.println("[INFO "+new java.sql.Date(currentDateTime)+" "+new java.sql.Time(currentDateTime)+"] Logger ERR Message : "+ex.getMessage());

			} finally {
				if(logger != null) logger.close();
			}
		}
	}

	public static void error(String msg) {
		if(IS_ERROR) {
			PrintWriter logger = null;
			String strOut = null;
			long currentDateTime = System.currentTimeMillis();

			try {

				String path = Config.getProperty("log", "LOG.ERROR.SAVEPATH")
						+ getCurrentDate().substring(0, 6);

				String logFile = path + "/ERROR." + new java.sql.Date(currentDateTime)+ ".log";

				File filePath = new File(path);

				if (!filePath.exists()) {
					filePath.mkdirs();
				}

				logger = new PrintWriter(new FileWriter(logFile, true), true);
				strOut = " [ ERROR ] [ " + new java.sql.Time(currentDateTime) + " ] " + msg;
				logger.println(strOut);
				if (IS_DEBUG){
					System.out.println(strOut);
				}

	        } catch(Exception ex) {
				System.err.println("[ERROR "+new java.sql.Date(currentDateTime)+" "+new java.sql.Time(currentDateTime)+"] Logger ERR toString : "+ex.toString());
				System.err.println("[ERROR "+new java.sql.Date(currentDateTime)+" "+new java.sql.Time(currentDateTime)+"] Logger ERR Message : "+ex.getMessage());

			} finally {
				if(logger != null) logger.close();
			}
		}
	}
	
	/**
	 * 콘솔에 메세지 출력
	 * @param msg : 메세지
	 */
	public static void println(String msg) {
		if ("".equals(msg) == true) {
			System.err.println(msg);
			return;
		}
		
		if(IS_PRINT) {
			long currentDateTime = System.currentTimeMillis();
			
			System.err.print(" [ PRINT ] ["+new java.sql.Date(currentDateTime)+" "+new java.sql.Time(currentDateTime)+"]");
			System.err.println(msg);
		}
	}
	/**
	 * 콘솔에 메세지 출력
	 * @param msg : 메세지
	 */
	public static void println(Object msg) {
		if ("".equals(msg) == true) {
			System.err.println(msg);
			return;
		}
		
		if(IS_PRINT) {
			long currentDateTime = System.currentTimeMillis();
			
			System.err.print(" [ PRINT ] ["+new java.sql.Date(currentDateTime)+" "+new java.sql.Time(currentDateTime)+"]");
			System.err.println(msg);
		}
	}
	
	public static String getCurrentDate() {
	    SimpleDateFormat sdf = null;

    	sdf = new SimpleDateFormat ("yyyyMMdd");

	    Date currentDate = new Date();
	    String dateString = sdf.format(currentDate);

		return dateString;
	}	
}
