package com.twobrain.common.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DateTime {

	// TODO - TIMEGAP 구현
/*
create or replace FUNCTION           FN_TIMEGAP (V_DATETIME IN VARCHAR2)
RETURN VARCHAR2
IS
N_RETURN NUMBER := -1 ;
DT_DATE DATE := NULL ;
N_DAY NUMBER := -1 ;
N_HOUR NUMBER := -1 ;
N_MIN NUMBER := -1 ;
D_GAP FLOAT := -1 ;

BEGIN
	DT_DATE := TO_DATE(V_DATETIME,'YYYYMMDDHH24MISS') ;

	SELECT
		 GAP INTO D_GAP
	FROM (
		SELECT sysdate - DT_DATE AS GAP FROM DUAL
	) ;

	N_DAY := TRUNC(D_GAP) ;

	IF N_DAY < 0 THEN RETURN -1 ; END IF;

	IF (0<= N_DAY AND N_DAY < 1) THEN
		N_HOUR := TRUNC(D_GAP*24) ;

		IF N_HOUR < 0 THEN RETURN -1 ; END IF ;

		IF (0 <= N_HOUR AND N_HOUR < 1) THEN
			N_MIN := TRUNC(D_GAP*24*60) ;
			IF N_MIN < 0 THEN RETURN -1 ; END IF ;

			RETURN N_MIN || '분 전' ;
		ELSE
			RETURN N_HOUR || '시간 전' ;
		END IF;

	ELSE
		IF(N_DAY >=3) THEN
			RETURN TO_CHAR(DT_DATE,'MM.DD HH:MI') ;
		ELSE
			IF (N_DAY=1) THEN RETURN '어제 ' || TO_CHAR(DT_DATE,'PM HH:MI') ; END IF ;
			IF (N_DAY=2) THEN RETURN '그제 ' || TO_CHAR(DT_DATE,'PM HH:MI') ; END IF ;
		END IF ;
	END IF;

	RETURN N_RETURN ;
END FN_TIMEGAP;
*/
	public static String getCurrentDateTime() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		Date date = new Date();
		
		return sdf.format(date);
	}
	
	public static String getCurrentDateTimeMillis() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
		Date date = new Date();
		return sdf.format(date);
	}
	
	public static String getCurrentTimeStamp() {
		return Long.toString(System.currentTimeMillis());
	}
	
	public static String convertDateFormat(String dateTimeString) {
		return convertDateFormat(dateTimeString, "yyyy-MM-dd a h:mm") ;
	}
	
	public static String convertDateFormat(String dateTimeString, String outputFormat) {
		String convertedDateString = "";
		
		SimpleDateFormat parseFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		SimpleDateFormat convertFormat = new SimpleDateFormat( outputFormat );
		
		try {
			Date parseDate = parseFormat.parse(dateTimeString);
			
			convertedDateString = convertFormat.format(parseDate);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return convertedDateString;
	}
	
	public enum DateTimeFormat {
		
	}
	
	

}

