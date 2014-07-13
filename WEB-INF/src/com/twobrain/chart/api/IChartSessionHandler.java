package com.twobrain.chart.api;

public interface IChartSessionHandler {
	public abstract boolean checkSession() ;
	public abstract String getTimeZone() ;
	public abstract String getLocaleCode() ;
}
