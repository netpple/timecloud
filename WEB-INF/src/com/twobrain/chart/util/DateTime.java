// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) ansi 
// Source File Name:   DateTime.java

package com.twobrain.chart.util ;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

public class DateTime {
	private static TimeZone tzBase = TimeZone.getTimeZone("Asia/Seoul");

	public DateTime() {
	}

	private static int randomRange(int n1, int n2) {
		return (int) (Math.random() * (double) ((n2 - n1) + 1)) + n1;
	}

	public static Date getCurrentDate() {
		Calendar calendar = Calendar.getInstance();
		return calendar.getTime();
	}

	public static String getCurrentDate(String dateFormat) {
		SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
		return sdf.format(getCurrentDate());
	}

	public static String getFormattedDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		Calendar calendar = Calendar.getInstance();
		return sdf.format(calendar.getTime());
	}

	public static String getFormattedDate(Date currentDate) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		return sdf.format(currentDate);
	}

	public static String getFormattedDate(Date currentDate, String dateFormat) {
		SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
		return sdf.format(currentDate);
	}

	public static String getRandomDate() {
		Calendar now = Calendar.getInstance();
		now.add(5, randomRange(1, 365));
		Date tdate = now.getTime();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		return sdf.format(tdate);
	}

	public static String getRandomDate(int day1, int day2) {
		Calendar now = Calendar.getInstance();
		now.add(5, randomRange(day1, day2));
		Date tdate = now.getTime();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		return sdf.format(tdate);
	}

	/**
	 * 
	 * 타임존 차이를 분단위로 계산하여 리턴한다.
	 * 
	 * @Method Name : getIntervalTimeZone
	 * @param inTzCd
	 * @return
	 */
	public static int getIntervalTimeZone(String inTzCd) {
		int result = 0;

		TimeZone tzTarget = null;

		if (inTzCd != null && !"".equals(inTzCd.trim())) {
			tzTarget = TimeZone.getTimeZone(inTzCd.trim());
			result = (tzTarget.getRawOffset() - tzBase.getRawOffset()) / (1000 * 60);
		}

		return result;
	}
}
