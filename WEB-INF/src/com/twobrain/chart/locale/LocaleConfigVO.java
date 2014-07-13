package com.twobrain.chart.locale;

public class LocaleConfigVO implements java.io.Serializable {
	/**
     * 
     */
	private static final long serialVersionUID = 5996346419821397125L;
	private String language;
	private String country;
	private String encoding;
	private String fileEncoding;
	private String displayName;
	private String defaultYn;

	public String getLanguage() {
		return language;
	}

	public void setLanguage(String value) {
		language = value;
	}

	public String getCountry() {
		return country;
	}

	public void setCountry(String value) {
		country = value;
	}

	public String getEncoding() {
		return encoding;
	}

	public void setEncoding(String value) {
		encoding = value;
	}

	public String getFileEncoding() {
		return fileEncoding;
	}

	public void setFileEncoding(String value) {
		fileEncoding = value;
	}

	public String getDisplayName() {
		return displayName;
	}

	public void setDisplayName(String value) {
		displayName = value;
	}

	public String getDefaultYn() {
		return defaultYn;
	}

	public void setDefaultYn(String value) {
		defaultYn = value;
	}

}