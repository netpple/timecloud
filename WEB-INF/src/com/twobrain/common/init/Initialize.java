package com.twobrain.common.init;

import java.io.File;
import java.util.StringTokenizer;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import com.twobrain.common.core.QueryParser;

public class Initialize extends HttpServlet {
	private static String strRealQueryPath = null;
	private static String strQueryXMLFile = null;
	private static String[] strQueryXMLFiles = null;

	public void init() throws ServletException {
		strQueryXMLFile = getInitParameter("QueryXMLFile");

		strRealQueryPath = getServletContext().getRealPath("/")
				+ File.separator + "WEB-INF" + File.separator + "query"
				+ File.separator;

		strQueryXMLFiles = getXMLFiles(strQueryXMLFile, strRealQueryPath);

		QueryParser.parseQuery(strQueryXMLFiles);
	}

	private String[] getXMLFiles(String strSourceFile, String realPath) {
		StringTokenizer token = new StringTokenizer(strSourceFile, ",");
		String[] strTargetFiles = null;
		strTargetFiles = new String[token.countTokens()];

		int i = 0;
		strTargetFiles = new String[token.countTokens()];
		while (token.hasMoreTokens()) {
			strSourceFile = realPath + removeSpaceAll(token.nextToken());
			strTargetFiles[i] = strSourceFile;
			i++;
		}
		return strTargetFiles;
	}

	public static String[] getQueryXMLFiles() {
		return strQueryXMLFiles;
	}

	private String removeSpaceAll(String str) {
		str = str.replace("\n", "");
		str = str.replace("\r", "");
		str = str.replace("\t", "");
		str = str.replace(" ", "");
		str.trim();
		return str;
	}
}
