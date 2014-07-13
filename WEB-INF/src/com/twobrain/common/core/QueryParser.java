package com.twobrain.common.core;

import java.io.File;
import java.util.HashMap;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;

import com.twobrain.common.log.LogHandler;


public class QueryParser {
	
	private static HashMap<String,Object> Querys = new HashMap<String,Object>();
	public static HashMap<String,Object> parseQuery(String[] queryFileNames) {
		for(int i = 0; i < queryFileNames.length; i++) {
	        File file = new File(queryFileNames[i]);
	        if(file.exists()) {
	        	Querys = parseQuery(queryFileNames[i], Querys);
	        } else {
	        	LogHandler.info("XML File Does Not Exists !!! - " + queryFileNames[i]);
	        }
	    }
		
		return Querys;
	}
	
	public static HashMap<String,Object> parseQuery(String queryFileName, HashMap<String,Object> queryMap) {
		
		String queryId = null;
		String queryValue = null;
			
		try {
			Document doc = getDocument(queryFileName);
			Element root = doc.getRootElement();
			
			LogHandler.debug("queryFileName : " + queryFileName);
	
			List queries = root.getChildren("query");
	
			for(int j = 0; j < queries.size(); j++) {
				Element query = (Element)queries.get(j);
				
				queryId = query.getChild("id").getText().trim();
				queryValue = query.getChild("value").getText();
				
				HashMap<String,Object> columnSizeMap = new HashMap<String,Object>();
				List columnSizes = query.getChildren("columnsize");
				for (int k = 0, size = columnSizes.size(); k < size; k++) {
					Element columnSize = (Element)columnSizes.get(k);
					String columnName      = columnSize.getAttributeValue("column_name");
					String columnSizeValue = columnSize.getText();
					try {
						Integer columnSizeInt = new Integer(columnSizeValue);
						columnSizeMap.put(columnName, columnSizeInt);
					}
					catch(Exception e) {
						
					}
				}
				
				Object[] value = new Object[2];
				value[0] = queryValue;
				value[1] = columnSizeMap;				
				
				if (!queryMap.containsKey(queryId)) {
					queryMap.put(queryId, value);
				} else {
				    LogHandler.debug("Query Id가 중복됩니다 !!! [ " + j + " ] : " + queryId);				    
				}
			}	
		} catch ( Exception e ) {
		}
		return queryMap;
	}
	
	
	private static Document getDocument(String queryFileName) throws JDOMException, Exception {
		File file = new File(queryFileName);
		LogHandler.info("query file name :" + queryFileName);
		if(file.exists()) {
			SAXBuilder builder = new SAXBuilder();
			return builder.build(file);
		} else {
			return null; 
		}
	}
}
