package com.twobrain.chart.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.twobrain.chart.api.IChartQueryHandler;
import com.twobrain.common.core.DataSet;
import com.twobrain.common.core.QueryHandler;
/*
import com.edi.common.dbtool.DataSet;
import com.edi.common.dbtool.QueryHandler;
*/
/*
 * framework에 따라서 만들어 쓰는 메쏘드임.
 * 
 * */
public class ChartQueryHandler implements IChartQueryHandler {

	public List getKpiResultList(String queryKey, Map paramMap)
			throws Exception {
		String AspGroupCd = "" + paramMap.get("AspGroupCd") ;
		String AspIdx = "" + paramMap.get("AspIdx") ;
		
		DataSet ds = QueryHandler.executeQuery("KPI_TEST_01",new String[]{AspGroupCd,AspIdx});
		if (ds != null && ds.size() > 0) {
			List<Map<String,String>> list = new ArrayList<Map<String,String>>() ;
			Map<String, String> result = new HashMap<String, String>() ;
			// -- A.N_ASP_IDX,A.C_ASP_G_CODE,A.C_ASP_CODE,
 
			while (ds.next()) {
				
				result.put("ASP_IDX",ds.getString("ASP_IDX")) ;
				result.put("ASP_G_CODE",ds.getString("ASP_G_CODE")) ;
				result.put("ASP_CODE",ds.getString("ASP_CODE")) ;
				
				list.add(result) ;
			}
			
			return list ;
		}
		
		return null;
	}
}
