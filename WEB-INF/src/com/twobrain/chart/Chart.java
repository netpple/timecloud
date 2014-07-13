package com.twobrain.chart;

public class Chart {
	private String _controls = null ;
	private String _chart = null ;
	
	protected void setChart(String chart) {
		this._chart = chart ;
	}
	protected void setControls(String controls) {
		this._controls = controls ;
	}
	
	public String getChart() {
		return _chart ;
	}
	
	public String getControls() {
		return _controls ;
	}
}
