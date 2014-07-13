package com.twobrain.chart.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

// -- import com.ems.back.common.AdminSession;
import com.twobrain.chart.api.IChartSessionHandler;

/*
 * 이 클래스는 포팅하는 프레임웍의 세션 연동 부분
 * 
 * */
public class ChartSessionHandler implements IChartSessionHandler {
	HttpSession session ;
	HttpServletRequest request ;
	
	// -- EC-Platform에 종속적
	// -- AdminSession s_oAdmin = null ;
	
	public ChartSessionHandler(HttpServletRequest req) {
		this.request = req ;
		this.session = req.getSession() ;
		// -- this.s_oAdmin = (AdminSession)session.getAttribute("SESS_ADMIN_OBJECT");
	}

	public boolean checkSession() {
		// TODO Auto-generated method stub
		return true ; // -- (s_oAdmin != null) ;
	}

	public String getTimeZone() {
		// TODO Auto-generated method stub
		return "Asia/Seoul";
	}

	public String getLocaleCode() {
		// TODO Auto-generated method stub
		return "ko" ;
	}
}
