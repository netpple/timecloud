package com.twobrain.chart.util;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;

public class LocaleUtil {
	public static final String _KOR_ = "KO";
	public static final String _ENG_ = "EN";
	public static final String _CHN_ = "ZH";
	public static final String _JPN_ = "JA";

	public static final String DB_DTTM_FORMAT = "yyyyMMddHHmmss";

	public static Locale getLocale(String inLoacle) {
		Locale locale = Locale.KOREAN;

		if ((inLoacle != null) && (!"".equals(inLoacle.toUpperCase()))) {
			if ("KO".equals(inLoacle))
				locale = Locale.KOREAN;
			else if ("EN".equals(inLoacle))
				locale = Locale.ENGLISH;
			else if ("ZH".equals(inLoacle))
				locale = Locale.CHINESE;
			else if ("JA".equals(inLoacle)) {
				locale = Locale.JAPANESE;
			}
		}

		return locale;
	}

	/*
	 * DB 저장된 값을 화면 출력용(세션 날짜+시간 형식)으로 변화 (시차 적용)
	 * 
	 * @param date DB 저장 날짜
	 * 
	 * @param dateFormat 날짜 형식
	 * 
	 * @param timeFormat 시간 형식
	 * 
	 * @param intervalTime 서버 시간과 사용자가 시차(분단위)
	 */
	public static String getDBToView(String date, String intervalTime) {
		String rtnVal = "";
		try {

			int interval = Integer.parseInt(intervalTime);
			Calendar fromCal = Calendar.getInstance();

			if (date.length() > 14) {
				date = date.substring(0, 14);
			} else {
				while (date.length() < 14) {
					date = date + "0";
				}
			}

			fromCal.setTime(new SimpleDateFormat(DB_DTTM_FORMAT, LocaleUtil.getLocale("")).parse(date));
			SimpleDateFormat disFormat = new SimpleDateFormat(DB_DTTM_FORMAT, LocaleUtil.getLocale(""));
			fromCal.add(Calendar.MINUTE, interval);
			rtnVal = disFormat.format(fromCal.getTime());

		} catch (Exception e) {
			System.out.println("getDBToView Error : " + e.toString());
		}

		return rtnVal;
	}

	/*
	 * 화면 값을 DB 저장 형식으로 변환(시차 적용)
	 * 
	 * @param date 화면 날짜
	 * 
	 * @param dateFormat 날짜 형식
	 * 
	 * @param intervalTime 서버 시간과 사용자가 시차(분단위)
	 */
	public static String getViewToDB(String date, String intervalTime) {
		String rtnVal = "";
		try {

			int interval = Integer.parseInt(intervalTime);
			Calendar fromCal = Calendar.getInstance();

			if (date.length() > 14) {
				date = date.substring(0, 14);
			} else {
				while (date.length() < 14) {
					date = date + "0";
				}
			}
			
			fromCal.setTime(new SimpleDateFormat(DB_DTTM_FORMAT, LocaleUtil.getLocale("")).parse(date));
			SimpleDateFormat disFormat = new SimpleDateFormat(DB_DTTM_FORMAT, LocaleUtil.getLocale(""));
			fromCal.add(Calendar.MINUTE, -interval);
			rtnVal = disFormat.format(fromCal.getTime());

		} catch (Exception e) {
			System.out.println("getViewToDB Error : " + e.toString());
		}

		return rtnVal;
	}
}