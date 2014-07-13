package com.twobrain.chart.api;

import java.util.List;
import java.util.Map;

public interface IChartQueryHandler {
	public abstract List getKpiResultList(String queryName, Map paramMap) throws Exception;
}
