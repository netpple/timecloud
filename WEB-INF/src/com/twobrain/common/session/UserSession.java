package com.twobrain.common.session;

import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;

import com.twobrain.common.core.DataSet;

public class UserSession implements HttpSessionBindingListener, Comparable<UserSession> {

	private String userIdx = "";
	private String password = "";
	private String email = "";
	private String name = "";
	private String ipAddress = "";
	private String domain = "";
    private String domainIdx = "";
	private String host = "";
	private String subEmail = "";
	
	public UserSession() {}

	public UserSession (DataSet dsInfo) {
		userIdx = dsInfo.getString(1);
		email = dsInfo.getString(2);
		name = dsInfo.getString(3);
		password = dsInfo.getString(7);
        subEmail = dsInfo.getString(8);    // 서브 이베일로 정리
        domain = dsInfo.getString(9); //email.substring(email.indexOf('@') + 1, email.length());
        domainIdx = dsInfo.getString(10);
	}

	public int hashCode() {
		return 13*email.hashCode();
	}
	
	public boolean equals(UserSession user) {
		return compareTo(user) == 0;
	}

	public int compareTo(UserSession user) {
		return email.compareTo(((UserSession)user).getUserEmail());
	}

	public void valueBound(HttpSessionBindingEvent event) {}

	public void valueUnbound(HttpSessionBindingEvent event) {
		UserMonitor monitor = UserMonitor.getInstance();
		monitor.removeUserSession(this);

		try {
			this.finalize();
		} catch (Throwable t) {
		}
	} 

	
    public int getUserIdx() {
        return Integer.parseInt(userIdx);
    }

    public String getUserEmail() {
        return email;
    }

    public String getUserName() {
        return name;
    }
    
    public void setLoginIp(String ipAddress) {
    	this.ipAddress = ipAddress;
    }
    
    public String getLoginIp() {
    	return ipAddress;
    }
    
    public String getPassword() {
    	return password;
    }
    
    public String getDomainIdx() {
    	return domainIdx;
    }

    public String getSubEmail() {
    	return subEmail;
    }
    
    public void setHost(String host) {
    	this.host = host;
    }
    
    public String getHost() {
    	return host;
    }
}