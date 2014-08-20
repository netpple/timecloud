package com.twobrain.dao;

import com.twobrain.common.core.DataSet;
import com.twobrain.common.core.QueryHandler;
import lombok.Getter;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by netpple on 2014. 7. 18..
 */
public class TeamInfo {

    @Getter
    final private String idx;
    @Getter
    final private String name;
    @Getter
    final private String regDatetime;
    @Getter
    final private String edtDatetime;
    @Getter
    final private String offYn;
    @Getter
    final private String userCnt;
    @Getter
    final private String ownerIdx;
    @Getter
    final private String ownerName;

    public static List<TeamInfo> getDomainTeams(String DOMAIN_IDX) {
        return getListAction("SELECT_DOMAIN_TEAM_LIST", DOMAIN_IDX);
    }

    public static List<TeamInfo> getTeams(String USER_IDX, String DOMAIN_IDX) {
        return getListAction("SELECT_USER_TEAM_LIST", USER_IDX, DOMAIN_IDX);
    }

    private static List<TeamInfo> getListAction(String query, String... params) {
        List<TeamInfo> teams = null;
        DataSet ds = QueryHandler.executeQuery(query, params);
        if (ds == null || ds.size() < 1) return null;
        teams = new ArrayList<TeamInfo>();
        while (ds.next()) {
            teams.add(new TeamInfo(ds));
        }

        return teams;
    }

    public static boolean isTeamMember(String USER_IDX, String team_idx, String DOMAIN_IDX) {
        int cnt = QueryHandler.executeQueryInt("SELECT_IS_TEAM_MEMBER", new String[]{USER_IDX, team_idx, DOMAIN_IDX});
        return (cnt > 0);
    }

    public static TeamInfo getInstance(final String team_idx, final String domain_idx) { // 도메인 관리자용
        DataSet ds = QueryHandler.executeQuery("SELECT_TEAM_INFO", new String[]{domain_idx, team_idx}, "AND A.N_DOMAIN_IDX = ? AND A.N_IDX = ?");
        if (ds == null || !ds.next()) return null;
        TeamInfo team = new TeamInfo(ds);
        return team;
    }

    public static TeamInfo getInstance(final String user_idx, final String team_idx, final String domain_idx) {
        DataSet ds = QueryHandler.executeQuery("SELECT_TEAM_INFO", new String[]{user_idx, domain_idx, team_idx}, "AND B.N_USER_IDX = ? AND A.N_DOMAIN_IDX = ? AND A.N_IDX = ?");
        if (ds == null || !ds.next()) return null;
        TeamInfo team = new TeamInfo(ds);
        return team;
    }

    public TeamInfo(DataSet ds) {
        this.idx = ds.getString("N_IDX");
        this.name = ds.getString("V_NAME");
        this.offYn = ds.getString("C_OFF_YN");
        this.regDatetime = ds.getString("V_REG_DATETIME");
        this.edtDatetime = ds.getString("V_EDT_DATETIME");
        this.userCnt = ds.getString("USER_CNT");
        this.ownerIdx = ds.getString("N_OWNER_IDX");
        this.ownerName = ds.getString("OWNER_NAME");
    }

    public boolean isOFF() {
        return "Y".equals(getOffYn());
    }
}