package com.twobrain.chart.factory;

import javax.servlet.http.HttpServletRequest;

import com.twobrain.chart.api.IChartSessionHandler;
import com.twobrain.chart.service.ChartSessionHandler;

public class ChartSessionFactory {
	public static IChartSessionHandler getChartSessionHandler(HttpServletRequest req) {
		return new ChartSessionHandler(req) ;
	}
}
