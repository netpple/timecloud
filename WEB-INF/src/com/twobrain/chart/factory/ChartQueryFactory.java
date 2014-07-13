package com.twobrain.chart.factory;

import com.twobrain.chart.api.IChartQueryHandler;
import com.twobrain.chart.service.ChartQueryHandler;

public class ChartQueryFactory {
	public static IChartQueryHandler getChartQueryHandler() {
		return new ChartQueryHandler() ;
	}
}
