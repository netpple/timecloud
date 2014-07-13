package com.twobrain.common.core;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Types;
import java.util.HashMap;
import java.util.StringTokenizer;
import java.util.Vector;

import com.twobrain.common.init.Initialize;
import com.twobrain.common.log.LogHandler;


public final class QueryHandler {

	protected static HashMap mQueries;
	protected static String sEntireKey;
	
	private QueryHandler() {}
	
	static {
		try{
			mQueries = QueryParser.parseQuery(Initialize.getQueryXMLFiles());
		}catch(Exception e){
			LogHandler.error("################[ QueryHandler static ]#######################");
			LogHandler.error("# Msg : " + e.toString());
			LogHandler.error("################[ ------------------- ]#######################");
		}
	}
	
	protected final static int getParameterCount(String string) {
		int index = 0;
		int count = -1;
		do {
			index = string.indexOf('?', index + 1);
			count++;
		} while (index > 0);
		return count;
	}
	
	public final static void readQuery(String query, Object[] parameters) {
	    StringBuffer buffer = new StringBuffer();
		StringTokenizer stTok = new StringTokenizer(query, "?");
		
		buffer.append("SQL Statement : ");
		int iP = 0;
		String tk = null;
		
		while(stTok.hasMoreTokens()) {
		    buffer.append(stTok.nextToken());
		    
		    if(parameters != null && parameters.length > iP) {
		        if(parameters[iP] != null) {
			        tk = parameters[iP].toString();
			        
			        if("null".equals(tk)){
			            buffer.append(tk);
			        } else {
					    buffer.append("'");
					    buffer.append(tk);
					    buffer.append("'"); 
			        }
		        }
		    }
		    iP++;
		}
		LogHandler.println("[QueryHandler readQuery] " + buffer.toString());
	}
	
	public static String getQuery(String key, String repl) {
		String query = null;
		if(mQueries.containsKey(key)) {
			Object[] value = (Object[]) mQueries.get(key);
			query = (String) value[0];
		} else {
			LogHandler.error("QuerySet안에 해당 Statement가 없습니다!! 철자를 확인하시거나 다시 한번 확인해 주세요!! 호출쿼리 키 : "+key);
			return null;
		} 
		if(repl != null) {
			StringTokenizer st = new StringTokenizer(repl, "^");
			int i = 0;			
			while(st.hasMoreTokens()) {
				String value = st.nextToken();
				if(!st.equals("repl=")) {
					query = query.replace("$"+i+"$", value);
				}
				i++;
			}
		} 
		return query;
	}
	
	protected final static DataSet makeDataSet(String key, Object[] condition, String repl) {
		PoolManager poolMgr = new PoolManager();
		
		String sQuery = null;
		Connection mConnection = null;
		PreparedStatement mPstmt = null;
		ResultSet mResultSet = null;
		DataSet ds = null;
		
		Vector<String> vData = new Vector<String>();
		HashMap<String,Integer> columnName = new HashMap<String,Integer>();
		mConnection = poolMgr.getConnection();
		sQuery = getQuery(key,repl);
		
		try {
			mPstmt = mConnection.prepareStatement(sQuery);
			if( condition != null ) {
				for(int i=0, size  = condition.length; i < size; i++) {
					mPstmt.setObject(i+1,condition[i]);
				}
			}
			
			mResultSet = mPstmt.executeQuery();
			readQuery(sQuery, condition);

	    	ResultSetMetaData mResultSetMetaData = mResultSet.getMetaData();
			
	    	int rows = 0;
	    	int columns = mResultSetMetaData.getColumnCount();
	    	
	    	while (mResultSet.next()) {
	       		
	    		for(int i = 0; i < columns; i++) {
		    		String strTemp = mResultSet.getString(i+1);
	      			if (mResultSetMetaData.getColumnType(i+1) == Types.TIMESTAMP) {
	      		   		if(strTemp == null || strTemp.equals("")) {
	      		   			vData.addElement("");
	      		   		} else {
	      		   			vData.addElement(strTemp.substring(0, 10));
	      		   		}
	      		    } else {
	      		    	if(strTemp == null) {
	        	 			strTemp = "";
	        	 			vData.addElement(strTemp);
	        	 		} else {
	        	 			vData.addElement(strTemp.trim());
	        	 		}
	       			}
	    		}
	    		rows ++;
	    	}
	    	for(int j = 0; j < columns; j++) {
	    		columnName.put(mResultSetMetaData.getColumnName(j+1).toUpperCase(), (j+1));
	    	}
	    	int v_size = vData.size();

	    	if (mResultSet != null) {
	    		String[] vec2array = new String[v_size];
	    		vData.toArray(vec2array);
	    		ds = new DataSet(vec2array, columns, columnName);	    		
	    	}
		} catch (SQLException se) {
			LogHandler.error("################[Time] "+(new java.util.Date()));
			LogHandler.error("################[makeDataSet] SQLException START!!!#######################");
			LogHandler.error("[makeDataSet] SQLState : " + se.getSQLState());
			LogHandler.error("[makeDataSet] Message  : " + se.getMessage());
			LogHandler.error("[makeDataSet] Error Code : " + se.getErrorCode());
			LogHandler.error("[makeDataSet] KEY : " + sEntireKey);
			LogHandler.error("[makeDataSet] Query : " + sQuery);

      		if (condition != null) {
	      		for(int i = 0; i < condition.length; i++) {
	      			LogHandler.error("[makeDataSet] Condition["+i+"]= '"+condition[i].toString()+"'");
	      		}
      		}
			sEntireKey = null;
			LogHandler.error("################[makeDataSet] SQLException END!!!#########################");
		} finally {
			try {
				mResultSet.close();
				mPstmt.close();
				poolMgr.freeConnection(mConnection);
			} catch (Exception ecp) {
			}
		}
		return ds;
	}
	
	/*
	 * Execute Query
	 */
	public static DataSet executeQuery(String query, Object[] condition, String repl) {
		return makeDataSet(query, condition, repl);
	}
	
	public static DataSet executeQuery(String query) {
		return executeQuery(query,null,null);
	}
	
	public static DataSet executeQuery(String query, Object[] condition) {
		return executeQuery(query,condition,null);
	}
	
	public static DataSet executeQuery(String query, int condition) {
		return executeQuery(query,new String[] { Integer.toString(condition) }, null);
	}
	
	public static DataSet executeQuery(String query, String condition) {
		return executeQuery(query,new String[] { condition }, null);
	}
	
	/*
	 * Execute Query Integer
	 */
	
	public static int executeQueryInt(String query, Object[] condition, String repl) {
		DataSet ds = makeDataSet(query, condition, repl);
		int iResult = 0;
		if(ds != null && ds.next()) {
			iResult = ds.getInt(1);
		}
		return iResult;
	}
	
	public static int executeQueryInt(String query) {
		return executeQueryInt(query,null,null);
	}
	
	public static int executeQueryInt(String query, Object[] condition) {
		return executeQueryInt(query,condition,null);
	}
	
	public static int executeQueryInt(String query, int condition) {
		return executeQueryInt(query,new String[] { Integer.toString(condition) }, null);
	}
	
	public static int executeQueryInt(String query, String condition) {
		return executeQueryInt(query,new String[] { condition }, null);
	}
	
	/*
	 * Execute Query String
	 */
	
	public static String executeQueryString(String query, Object[] condition, String repl) {
		DataSet ds = makeDataSet(query, condition, repl);
		String sResult = "";
		if(ds != null && ds.next()) {
			sResult = ds.getString(1);
		}
		return sResult;
	}
	
	public static String executeQueryString(String query) {
		return executeQueryString(query,null,null);
	}
	
	public static String executeQueryString(String query, Object[] condition) {
		return executeQueryString(query,condition,null);
	}
	
	public static String executeQueryString(String query, int condition) {
		return executeQueryString(query,new String[] { Integer.toString(condition) }, null);
	}
	
	public static String executeQueryString(String query, String condition) {
		return executeQueryString(query,new String[] { condition }, null);
	}
	
	
	
	public static boolean executeExisting(String query, Object[] condition, String repl) {
		DataSet ds = makeDataSet(query, condition, repl);
		String sResult = "";
		if(ds != null && ds.next()) {
			sResult = ds.getString(1);
		}
		
		if("".equals(sResult))
			return false;
		else if("0".equals(sResult))
			return false;
		else
			return true;
	}
	
	public static boolean executeExisting(String query) {
		return executeExisting(query,null,null);
	}
	
	public static boolean executeExisting(String query, Object[] condition) {
		return executeExisting(query,condition,null);
	}
	
	public static boolean executeExisting(String query, int condition) {
		return executeExisting(query,new String[] { Integer.toString(condition) }, null);
	}
	
	public static boolean executeExisting(String query, String condition) {
		return executeExisting(query,new String[] { condition }, null);
	}
	
	
	
	
	
	protected final static int executeData(String key, Object[] condition, String repl) {
		PoolManager poolMgr = new PoolManager();
		
		int iResult = 0;
		String sQuery = null;
		Connection mConnection = null;
		PreparedStatement mPstmt = null;

		try {
			mConnection = poolMgr.getConnection();
			mConnection.setAutoCommit(false);
			sQuery = getQuery(key, repl);
			mPstmt = mConnection.prepareStatement(sQuery);

	      	if(condition != null) {    		
		      	for(int i = 0; i < condition.length; i++) {
		      		mPstmt.setObject(i+1, condition[i]);
		      	}
	      	}
	      	iResult = mPstmt.executeUpdate();
	      	readQuery(sQuery, condition);
	      	mConnection.commit();
		} catch (SQLException se) {
			LogHandler.error("################[Time] "+(new java.util.Date()));
			LogHandler.error("################[makeDataSet] SQLException START!!!#######################");
			LogHandler.error("[makeDataSet] SQLState : " + se.getSQLState());
			LogHandler.error("[makeDataSet] Message  : " + se.getMessage());
			LogHandler.error("[makeDataSet] Error Code : " + se.getErrorCode());
			LogHandler.error("[makeDataSet] KEY : " + sEntireKey);
			LogHandler.error("[makeDataSet] Query : " + sQuery);
			
			if (condition != null) {
				for(int i = 0; i < condition.length; i++) {
					LogHandler.error("[makeDataSet] Condition["+i+"]= '"+condition[i].toString()+"'");
				}
			}
			sEntireKey = null;
			LogHandler.error("################[makeDataSet] SQLException END!!!#########################");
		} finally {
			try {
				mPstmt.close();
				poolMgr.freeConnection(mConnection);
			} catch (Exception ecp) {
			}
		}
		return iResult;
	}
	
	public static int executeUpdate(String query, Object[] condition, String repl) {
		return executeData(query, condition, repl);
	}
	
	public static int executeUpdate(String query) {
		return executeUpdate(query,null,null);
	}
	
	public static int executeUpdate(String query, Object[] condition) {
		return executeUpdate(query,condition,null);
	}
	
	public static int executeUpdate(String query, int condition) {
		return executeUpdate(query,new String[] { Integer.toString(condition) }, null);
	}
	
	public static int executeUpdate(String query, String condition) {
		return executeUpdate(query,new String[] { condition }, null);
	}
	
	
	public static String executeTransaction(Vector<Object> vCondition) {

		int size = vCondition.size();

		Object[] aCondition = new Object[size];

		for(int i = 0; i < aCondition.length; i++) {
			aCondition[i] = vCondition.elementAt(i);
		}
		return executeTransaction(aCondition);
	}

	public static String executeTransaction(Object[] aCondition) {
	    String msg = "commit";
	    String entire_key = "";
	    
	    Connection con = null;
	    PreparedStatement stmt = null;
	    String query = null;

		PoolManager connMgr = new PoolManager(); 
		
	    try {
	    	con = connMgr.getConnection();
	    	
			try {
				con.setAutoCommit(false);
			} catch(Exception exs) {
				LogHandler.error("[executeTransaction] Error Message : "+exs.getMessage());
			}

			for(int ti = 0; ti < aCondition.length; ti++) {
				String key = (String)aCondition[ti];
			  	Object[] condition = (Object[])aCondition[ti+1];

			  	query = null;
			  	query = getQuery(key, null);

			  	entire_key = key;

				if(query == null) {
					try {
						con.rollback();
						msg = "rollback";
						LogHandler.error("[executeTransaction]에서 query가  null이므로  Rollback됨!!!!!");
					} catch (SQLException e2) { }

					return msg;
				}

				if (condition != null) {
		      		for(int i = 0; i < condition.length; i++) {
		      			LogHandler.error("[makeDataSet] Condition["+i+"]= '"+condition[i].toString()+"'");
		      		}
	      		}
				
				stmt = con.prepareStatement(query);

				if (condition != null){
					for(int j = 0; j < condition.length; j++) {
				    	stmt.setObject(j+1, condition[j]);
				    }
			    }

		      	stmt.executeUpdate();

		      	readQuery(query, condition);
		      	ti += 1; 
			}

		   	try { con.commit(); } catch(SQLException ex) { }
		   	
		} catch (SQLException se) {
			try {
				con.rollback();
				msg = "rollback";

				LogHandler.error("################[Time] "+(new java.util.Date()));
				LogHandler.error("################[executeTransaction] SQLException START!!!#######################");
				LogHandler.error("[executeTransaction] 에서 SQLException 발생. Transaction Rollback");
				LogHandler.error("[executeTransaction] SQLState : " + se.getSQLState());
				LogHandler.error("[executeTransaction] Message  : " + se.getMessage());
				LogHandler.error("[executeTransaction] Error Code : " + se.getErrorCode());
				LogHandler.error("[executeTransaction] KEY : " + entire_key);
				LogHandler.error("[executeTransaction] Query : " + query);
				LogHandler.error("################[executeTransaction] SQLException START!!!#######################");
				
			} catch (SQLException e2) {
			}

		} catch (Exception ex) {
			try {
				con.rollback();
				msg = "rollback";
				LogHandler.error("[executeTransaction] 에서 Exception 발생. Transaction Rollback");
				LogHandler.error("MESSAGE : "+ex.getMessage());
			} catch (SQLException e2) {
			}

		} finally {


			if(stmt != null) {
				try {
					stmt.close();
				} catch(Exception e1) {}
			}

			if(con != null){
				try{
					 con.setAutoCommit(true);
				}catch (Exception e1) {
				}
				connMgr.freeConnection(con);
			}
	    }
	    return msg;
	}

	public static void reset() {
		if(mQueries != null) {
			mQueries.clear();
		}
		try {
			mQueries = QueryParser.parseQuery(Initialize.getQueryXMLFiles());
		} catch (Exception e) {
			LogHandler.error("[Error When Reset] " + e.getMessage());
		}
	}
}
