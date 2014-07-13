package com.twobrain.common.core;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import com.twobrain.common.config.Config;

public class PoolManager {
	
	private String mJdbcName = "jdbc";
	
	public PoolManager() {
		this.mJdbcName = Config.getProperty("init", "JNDI_JDBC_NAME") ;
	};
	
	public final Connection getConnection() {
		Connection con = null;
		Context ctx = null;
		DataSource ds = null;
		
        try {
        	ctx = new InitialContext();
        	ds = (DataSource) ctx.lookup(mJdbcName) ;
        	con = ds.getConnection();
		} catch (NamingException e) {
			System.out.println( "[DBUtilPoolManager.getConnection] NamingException" + e.toString() );
			e.printStackTrace();
		} catch (SQLException e) {
			System.out.println( "[DBUtilPoolManager.getConnection] SQLException" + e.toString() );
			e.printStackTrace();
		}
    
		return con;
	}
	
    public void freeConnection(Connection con){
        if (con != null) {
            try {
				if( !con.getAutoCommit() ){
					con.rollback();
				}
				
				con.setAutoCommit(true);

				if( !con.isClosed() ){
					con.close();
				}

			 } catch (Exception e) {
				e.printStackTrace();

			 } finally {
				con = null;
			 }
        }
    }
}
