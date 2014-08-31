package com.twobrain.common.util;

import com.twobrain.dao.TeamInfo;
import com.twobrain.dao.UserInfo;
import org.apache.commons.lang3.StringUtils;

import java.util.List;

/**
 * Created by netpple on 2014. 7. 20..
 */
public class UserComponent {
    private List<UserInfo> users = null;

    public static UserComponent getInstance(String USER_IDX, String DOMAIN_IDX){
        UserComponent comp = new UserComponent(USER_IDX,DOMAIN_IDX);
        return comp;
    }

    public UserComponent(String USER_IDX,String DOMAIN_IDX){
        List<TeamInfo> teams = TeamInfo.getTeams(USER_IDX,DOMAIN_IDX);
        if(teams == null || teams.size()<1)
            return;

        TeamInfo team = teams.get(0);
        String team_idx = team.getIdx();

        // 소식 팀멤버
        List<UserInfo> users = UserInfo.getTeamUsers(team_idx,DOMAIN_IDX);
        if(users == null || users.size()<1)
            return;

        this.users = users;
    }
    //
    public String getUserCombo(){
        return getUserCombo("");
    }
    public String getUserCombo(final String USER_IDX){
        String userList = "<option value='-1'>없음</option>";
        if(users == null || users.size()<1)return userList;

        for(UserInfo user : users){
            if(StringUtils.equals(USER_IDX,user.getIdx()))continue;
            userList += "<option value='" + user.getIdx() + "'>" + user.getName() + "(" + user.getEmail() + ")</option>";
        }
        return userList;
    }

    //
    public String getUserCheckBox() {
        return getUserCheckBox("");
    }
    public String getUserCheckBox(final String USER_IDX) {    // -- 이미 참조자로 등록돼 있는 사람과 본인은 참조자에서 제외돼야 함.
        String userList = "";
        StringBuffer combo = new StringBuffer();
        combo.append("<div id='observerCheckList' class='control-group'>")
                .append("<label class='control-label' for='userCombo'>참조자 할당</label>")
                .append("<div class='controls'>%s</div></div>");
        if(users == null || users.size()<1)return String.format(combo.toString(),userList);

        for(UserInfo user : users){
            if(StringUtils.equals(USER_IDX,user.getIdx()))continue;
            userList += "<label class='checkbox inline'><input name='pObserver' type='checkbox' value='" + user.getIdx() + "' id='inlineCheckbox1'/>" + user.getName() + " </label>";
        }

        return String.format(combo.toString(),userList);
    }
}