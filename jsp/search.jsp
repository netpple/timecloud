<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.HashMap,java.util.Map" %>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %>
<%!
%><%
    StringBuffer sb = new StringBuffer();    // -- 검색 결과
    Object[] params = null;
    Map map = new HashMap();
    map.put("ACTIVITY", new Integer(0));
    map.put("FEEDBACK", new Integer(0));
    map.put("FILE", new Integer(0));
    map.put("TASK", new Integer(0));
    String msg_result = "검색결과가 없습니다. ";

    if (pSearchValue == null || "".equals(pSearchValue)) {
        sb.append("검색어를 입력해 주세요.");
    } else {
        String repl = "", searchValue = pSearchValue, searchMsgHead = "";
        if (pSearchValue.charAt(0) == '@') {    // 검색연산자
            repl = " AND Y.V_NAME LIKE(?)";

            searchValue = searchValue.substring(1);
            int pos = searchValue.indexOf('#');
            if (pos > 0) {
                String searchName = searchValue.substring(0, pos).trim();
                String searchText = searchValue.substring(pos + 1).trim();
                repl += " AND X.V_DESC LIKE(?)";
                params = new Object[]{"%" + searchName + "%", "%" + searchText + "%", Integer.toString(TEAM_IDX), DOMAIN_IDX};
                searchMsgHead = String.format("<b>%s</b>님이 작성한 콘텐츠 중에 ", searchName);
                searchValue = searchText;
            } else {
                params = new Object[]{"%" + searchValue + "%", Integer.toString(TEAM_IDX), DOMAIN_IDX};
                searchMsgHead = "사용자";
            }

        } else {
            repl = " AND X.V_DESC LIKE(?)";
            params = new Object[]{"%" + searchValue + "%", Integer.toString(TEAM_IDX), DOMAIN_IDX};
        }

        DataSet dsSearch = QueryHandler.executeQuery("TEST_SELECT_SEARCH_TEAM", params, repl);
        int searchCnt = (dsSearch != null) ? dsSearch.size() : 0;
        msg_result = String.format("<small>%s \"<b>%s</b>\"로 검색한 결과가 %s 건 입니다.</small>", searchMsgHead, searchValue, "" + searchCnt);

        if (searchCnt > 0) {
            Search search = null;
            String v_type = "", t_type = null;
            int n_type_cnt = 0;
            while (dsSearch.next()) {
                search = new Search(dsSearch, oUserSession);
                t_type = search.getType();
                if (!t_type.equals(v_type)) {
                    if (n_type_cnt > 0) map.put(v_type, new Integer(n_type_cnt));

                    v_type = t_type;
                    sb.append("<h6 id='" + v_type + "'>" + v_type + "</h6>");
                    n_type_cnt = 0;
                }
                sb.append(search.get());
                n_type_cnt++;
            }

            if (n_type_cnt > 0) map.put(v_type, new Integer(n_type_cnt));
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>검색 결과</title>
    <%@ include file="./common/include/incHead.jspf" %>
    <style type="text/css">
        .search {
            clear: both;
            padding-bottom: 2px;
        }

        .search dt {
            float: left;
            width: 50px;
            height: 50px;
            margin-bottom: 3px;
        }

        .search dd {
            margin-left: 70px;
        }
    </style>
</head>
<body>
<div class="row-fluid">
    <div class='span12'>
        <%@ include file="./menuGlobal.jsp" %>
        <div class='row-fluid'>
            <%--<div class='span2 vertNav'><%=getVertNav(req, oUserSession) %></div>--%>
            <div class='span12 all'><%=msg_result %>
                <div class="AXTabs">
                    <div class="AXTabsTray">
                        <a href="#ACTIVITY" class="AXTab">Activity(<%=map.get("ACTIVITY") %>)</a>
                        <a href="#FEEDBACK" class="AXTab">Feedback(<%=map.get("FEEDBACK") %>)</a>
                        <a href="#FILE" class="AXTab">File(<%=map.get("FILE") %>)</a>
                        <a href="#TASK" class="AXTab">Task(<%=map.get("TASK") %>)</a>

                        <div class="clear"></div>
                    </div>
                </div>
                <%=sb.toString()%>
            </div>
        </div>
    </div>
    <%--<%=getNotification(oUserSession, "span2 noti") %>--%>
</div>
</body>
</html>
<%@ include file="./common/include/incFooter.jspf" %>
<%!
    class Search {    // class Tool과 v_task 빼고 동일함
        int n_idx = -1;
        int n_task_idx = -1;
        int n_owner_idx = -1;

        String v_desc;
        String v_timegap;
        String v_recent;
        String v_type; // -- TASK, FEEDBACK, FILE, ACTIVITY
        String c_off_yn;
        String v_owner;
        String v_task;

        UserSession sess;

        public Search(DataSet ds, UserSession sess) {
            this.n_idx = ds.getInt(1);
            this.n_task_idx = ds.getInt(2);
            this.n_owner_idx = ds.getInt(3);
            this.v_desc = ds.getString(4);
            this.v_timegap = ds.getString(5);
            this.v_recent = ds.getString(6);
            this.v_type = ds.getString(7);
            this.c_off_yn = ds.getString(8);
            this.v_owner = ds.getString(9);
            this.v_task = ds.getString(10);

            this.sess = sess;
        }

        private boolean isMe() {
            return (n_owner_idx == sess.getUserIdx());
        }

        public String getType() {
            return v_type;
        }

        private String getActionMessage() {
            String msg = "";
            if ("ACTIVITY".equals(v_type)) {
                msg = "수행한 액티비티입니다." + Html.Icon.ACTIVITY;
            } else if ("FEEDBACK".equals(v_type)) {
                msg = "남긴 피드백입니다." + Html.Icon.FEEDBACK;
            } else if ("FILE".equals(v_type)) {
                msg = "파일을 업로드하였습니다." + Html.Icon.FILE;
            } else if ("TASK".equals(v_type)) {
                if ("Y".equals(c_off_yn)) msg = "완료한 태스크입니다. ";
                else msg = "진행 중인 태스크입니다.";
                msg += Html.Icon.TASK;
            } else {
                msg = "";
            }

            return msg;
        }

        public String get() {
            StringBuffer sbOut = new StringBuffer();

            try {

                // -- TODO - 사용자 사진은 사용자 인식값(PK등)으로 가져올 수 있으면, DB부하 없이도 쓸 수 있어.. 그게 아니면, 썸네일 정도는 경로정보를 N_OWNER_IDX와 매핑하여 서버 메모리에 로딩 시켜 놓고 쓰는게 유리함.

                // -- String sUserInfo = new User(n_owner_idx).get();

                String message = null;
                if (isMe()) {    // -- my feedback
                    message = "내가 " + getActionMessage();
                } else {
                    message = "<strong>" + v_owner + "</strong>님이 " + getActionMessage();
                }
                message += " " + v_timegap;


                sbOut.append("<div class='search'><dl>");
                sbOut.append("<dt class='img'>");
                sbOut.append(getProfileImage(n_owner_idx));
                sbOut.append("</dt>");
                sbOut.append("<dd><small>");
                sbOut.append(message);
                sbOut.append("</small></dd>");
                sbOut.append("<dd>");
                sbOut.append(addLink(stringToHTMLString(v_desc)));    // -- 본문 링크
                sbOut.append("</dd>");
                sbOut.append("<dd>");
                sbOut.append(Html.Icon.TASK + " <a href='javascript:onTaskHomePop(" + n_task_idx + ")'>" + v_task + "</a>");
                sbOut.append("</dd>");
                sbOut.append("</dl></div>");

            } catch (Exception e) {
            }
            return sbOut.toString();
        }
    }
%>