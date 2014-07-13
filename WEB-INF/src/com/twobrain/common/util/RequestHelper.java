package com.twobrain.common.util;

import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RequestHelper {
	private HttpServletRequest request;
	private HttpServletResponse response;

	public RequestHelper(HttpServletRequest request) {
		this.request = request;
		printParam();
	}
	
	public RequestHelper(HttpServletRequest request, HttpServletResponse response) {
		this.request = request;
		this.response = response;
		printParam();
	}
	
	public HttpServletRequest getRequestObject() {
		return request;
	}

	public HttpServletResponse getResponseObject() {
		return response;
	}
	
	public String getParamToJava(String name) {
		String value = request.getParameter(name);

		if (value == null) {
			return "";
		} else {
			// return StringUtil.convertToJava(value);
			return value;
		}
	}

	public String getParamToJava(String name, String defaultValue) {
		String value = request.getParameter(name);

		if (value == null) {
			return defaultValue;
		} else {
			// return StringUtil.convertToJava(value);
			return value;
		}
	}

	public String getParam(String name) {
		String value = request.getParameter(name);

		if (value == null) {
			return "";
		} else {
			return value;
		}
	}

	public String getParam(String name, String defaultValue) {
		String value = request.getParameter(name);

		if (value == null || value.equals("")) {
			return defaultValue;
		} else {
			return value;
		}
	}

	public int getIntParam(String name) {
		try {
			String value = request.getParameter(name);

			// if(value == null || value.equals("")) {
			if (value == null) {
				return 0;
			} else {
				return Integer.parseInt(value);
			}
		} catch (NumberFormatException e) {
			System.out.println("[NumberFormatException] : " + e.getMessage());

			return 0;
		}
	}

	public int getIntParam(String name, int defaultValue) {
		try {
			String value = request.getParameter(name);

			if (value == null || value.equals("")) {
				return defaultValue;
			} else {
				return Integer.parseInt(value);
			}
		} catch (NumberFormatException e) {
			System.out.println("[NumberFormatException] : " + e.getMessage());

			return 0;
		}
	}

	public String[] getParamValues(String name) {
		return request.getParameterValues(name);
	}

	public String isSelected(String strParam, String strValue) {
		if (strParam == null) {
			return "";
		}

		if (strParam.equals(strValue)) {
			return "selected";
		} else {
			return "";
		}
	}

	public String isChecked(String strParam, String strValue) {
		if (strParam == null) {
			return "";
		}

		if (strParam.equals(strValue)) {
			return "checked";
		} else {
			return "";
		}
	}

	public String isIn(String strParam, String[] arrValue) {
		if (strParam == null) {
			return "";
		}
		for (int i = 0; i < arrValue.length; i++) {
			if (strParam.equals(arrValue[i])) {
				return "checked";
			}
		}
		return "";
	}
	
	public String getMethod() {
		return request.getMethod();
	}

	/**
	 * 에러 디버그용으로만 사용.
	 * 
	 * @param request
	 */
	private void printParam() {
		System.out.println("\n <<<<<<<<<< [" + Thread.currentThread().toString() + "] " + request.getServletPath() + " Request >>>>>>>>>>");

		Enumeration enumeration = request.getParameterNames();

		while (enumeration.hasMoreElements()) {
			String str = (String) enumeration.nextElement();
			String[] arrValues = request.getParameterValues(str);

			if (arrValues.length > 1) {
				StringBuffer sb = new StringBuffer();
				sb.setLength(0);
				sb.append("{");

				for (int i = 0; i < arrValues.length; i++) {
					if (i != 0) {
						sb.append(",");
					}
					sb.append("\"" + arrValues[i] + "\"");
				}

				sb.append("};");

				System.out.println("String[]" + str + " = " + sb.toString());
				System.out.println("[request](\"" + str + "\", " + str + ");");

			} else {
				System.out.println("[request](\"" + str + "\",\"" + arrValues[0] + "\");");
			}
		}

		System.out.println("");
	}
}
