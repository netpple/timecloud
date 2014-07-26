package com.twobrain.dao;

import com.twobrain.common.core.DataSet;
import com.twobrain.common.core.QueryHandler;
import lombok.Getter;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by netpple on 2014. 7. 19..
 */
public class UserInfo {
    @Getter final String idx;
    @Getter final String email;
    @Getter final String name;
    @Getter final String regDatetime; // 등록일
    @Getter final String edtDatetime; // 최근 갱신일
    @Getter final String offYn;
    @Getter final String tel;
    @Getter final String notiEmail;

    public static UserInfo getUserByIdx(final int user_idx) {
        DataSet ds = QueryHandler.executeQuery("SELECT_USER_INFO", user_idx);
        if(ds == null || !ds.next())return null;
        return new UserInfo(ds);
    }

    public static UserInfo getUserByEmail(final String user_email){
        DataSet ds = QueryHandler.executeQuery("SELECT_USER_INFO2", user_email);
        if(ds == null || !ds.next())return null;
        return new UserInfo(ds);
    }

    public static UserInfo getDomainUserByEmail(final String user_email, final String DOMAIN_IDX){
        DataSet ds = QueryHandler.executeQuery("SELECT_USER_INFO3", new String[]{user_email,DOMAIN_IDX});
        if(ds == null || !ds.next())return null;
        return new UserInfo(ds);
    }

    public static List<UserInfo> getTeamUsers(final String team_idx, final String domain_idx){
        List<UserInfo> users = null;
        DataSet ds = QueryHandler.executeQuery("SELECT_TEAM_USER_LIST",new String[]{team_idx,domain_idx});
        if(ds == null || ds.size()<1)return null;

        users= new ArrayList<UserInfo>();
        while(ds.next()){
            users.add(new UserInfo(ds));
        }

        return users;
    }

    private UserInfo(DataSet ds) {
        idx = ds.getString("N_IDX");
        email = ds.getString("V_EMAIL");
        name = ds.getString("V_NAME");
        offYn = ds.getString("C_OFF_YN");
        regDatetime = ds.getString("V_REG_DATETIME");
        edtDatetime = ds.getString("V_EDT_DATETIME");
        tel = ds.getString("V_TEL");
        notiEmail = ds.getString("V_NOTI_EMAIL");
    }

    public boolean isOFF() {
        return "Y".equals(getOffYn());
    }

    public String get() {
        // -- task_idx를 경로에 노출하지 않는 방법은?
        return "<a href='userInfo.jsp?user_idx=" + getIdx() + "'>" + getEmail() + "</a>";
    }
}
