package com.twobrain.common.util;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

public class MultiPartRequestHelper {

	private HttpServletRequest request = null;
	private HttpServletResponse response = null;
	private ServletFileUpload servletFileUploadHandler = null;
	private List<FileItem> fileItemList = null;
	private Hashtable<String, Object> formParameters = null;

	public MultiPartRequestHelper(HttpServletRequest request, HttpServletResponse response) {
		this.request = request;
		this.formParameters = new Hashtable<String, Object>();

		if (!ServletFileUpload.isMultipartContent(request)) {
			throw new IllegalArgumentException(
					"Request is not multipart, please 'multipart/form-data' enctype for your form.");
		}
		
		try {
			DiskFileItemFactory oDiskItemFactory = new DiskFileItemFactory();
			servletFileUploadHandler = new ServletFileUpload(oDiskItemFactory);
			List<FileItem> items = servletFileUploadHandler.parseRequest(request);
	       
			fileItemList = new ArrayList<FileItem>();
			
			for (FileItem item : items) {
				if (item.isFormField()) {
					formParameters.put(item.getFieldName(), item.getString("UTF-8"));
				} else {
					fileItemList.add(item);
				}
			}
			printParam();
		} catch (Exception e) {
		}
	}
	
	public List<FileItem> getFileItems() {
		return fileItemList;
	}

	public HttpServletRequest getRequest() {
		return request;
	}
	
	public HttpServletResponse getResponse() {
		return response;
	}

	public String getParam(String name) {
		String value = null;

		try {
			value = (String)formParameters.get(name);
		} catch (Exception e) {
		}

		return value;
	}

	public String getParam(String name, String defaultValue) {
		String value = getParam(name);

		if (value == null || value.equals("")) {
			return defaultValue;
		} else {
			return value;
		}
	}

	public int getIntParam(String name) {
		String value = "";

		try {
			return (Integer.parseInt((String)formParameters.get(name)));
		} catch (Exception e) {
			System.out.println("[Exception] : " + e.getMessage());
		}

		return 0;
	}
	
	public String[] getParams(String name) {
		String[] asParams = null;
		try {
			asParams = (String[])formParameters.get(name);
		} catch (Exception e) {
			System.out.println("[Exception] : " + e.getMessage());
		}
		return asParams;
	}

	public int getIntParam(String name, int defaultValue) {
		try {
			String value = "";

			try {
				value = (String)formParameters.get(name);
			} catch (Exception e) {
			}

			if (value == null || value.equals("")) {
				return defaultValue;
			} else {
				return Integer.parseInt(value);
			}
		} catch (NumberFormatException e) {
			System.out.println("[Exception] : " + e.getMessage());
			return 0;
		}
	}

	private void printParam() {
		System.out.println("\n <<<<<<<<<< ["
				+ Thread.currentThread().toString() + "] "
				+ request.getServletPath() + " Request >>>>>>>>>>");

		Enumeration<String> enumeration = formParameters.keys();

		while (enumeration.hasMoreElements()) {
			String str = (String) enumeration.nextElement();
			String arrValues = (String)formParameters.get(str);
			System.out.println("[request](\"" + str + "\",\"" + arrValues
					+ "\");");
		}

		System.out.println("");
	}
}
