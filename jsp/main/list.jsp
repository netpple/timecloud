<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/include/incInit.jspf" %>
<%@ include file="../common/include/incSession.jspf" %>
<%
    JsonResult result = new JsonResult();

    List<Task> taskList = getTaskList(QueryHandler.executeQuery("SELECT_TASK_RECENTLY"
            , new String[]{USER_IDX, USER_IDX, USER_IDX, USER_IDX, "30", "1", "10"})); //USER_IDX(4),GAP(day),START(rownum),END(rownum)
    List<Tool> recently = getToolList(QueryHandler.executeQuery("SELECT_TIMELINE", new String[]{USER_IDX}, "AND 1=1^WHERE ro BETWEEN 1 AND 10"));
    List<Notification> notis = getNotificationList(QueryHandler.executeQuery("TEST_SELECT_MYNOTIFICATION", new String[]{USER_IDX, "1", "10"}));
    List<Feedback> feedbackList = getFeedbackList(
            QueryHandler.executeQuery(
                    "SELECT_FEEDBACK_ALL2"
                    , new String[]{USER_IDX, USER_IDX}
                    , "WHERE 1=1^WHERE ro BETWEEN 1 AND 10"));
//                    , "WHERE (GAP BETWEEN 0 AND 30)^WHERE ROWNUM BETWEEN 1 AND 10")); // 기간 조건 최근 30일 이내
    List<Favorite> favoriteList = getFavoriteList(QueryHandler.executeQuery("TEST_SELECT_MYFAVORITE", USER_IDX));
    // 집계 블럭
    DataSet ds = QueryHandler.executeQuery ("KPI_TOOL_COUNT"
            , new String[]{USER_IDX,DOMAIN_IDX,USER_IDX,DOMAIN_IDX,USER_IDX,DOMAIN_IDX,USER_IDX,DOMAIN_IDX}
            , "AND N_OWNER_IDX = ? AND N_DOMAIN_IDX = ?^AND N_OWNER_IDX = ? AND N_DOMAIN_IDX = ?^AND N_OWNER_IDX = ? AND N_DOMAIN_IDX = ?^AND N_OWNER_IDX = ? AND N_DOMAIN_IDX = ?");
    if(ds != null && ds.next()){
        result.cnt = new int[]{ds.getInt(1),ds.getInt(2),ds.getInt(3),ds.getInt(4)};
    }
    //

    result.list = taskList; // mytask
    result.recently = recently; // recently tools
    result.notis = notis;
    result.feedbacks = feedbackList;
    result.favorites = favoriteList;
    result.result = Cs.SUCCESS;
    result.msg = Cs.SUCCESS_MSG_1;

    out.print(new Gson().toJson(result));
%><%!
    // DAO
    public class JsonResult {
        public String result = Cs.FAIL;
        public String msg = Cs.FAIL_MSG_1;
        public List<Task> list;
        public List<Tool> recently;
        public List<Notification> notis;
        public List<Feedback> feedbacks;
        public List<Favorite> favorites;
        //
        public int[] cnt = {0,0,0,0};

    }

    public List<Favorite> getFavoriteList(DataSet ds) {
        List<Favorite> list = new ArrayList<Favorite>();
        if (ds == null || ds.size() < 1) return null;
        while (ds.next()) {
            list.add(new Favorite(ds));
        }
        return list;
    }

    public List<Feedback> getFeedbackList(DataSet ds) {
        List<Feedback> list = new ArrayList<Feedback>();
        while (ds.next()) {
            list.add(new Feedback(ds));
        }

        return list;
    }

    public List<Tool> getToolList(DataSet ds) {
        List<Tool> list = new ArrayList<Tool>();
        if (ds == null || ds.size() < 1) return list;
        while (ds.next()) {
            list.add(new Tool(ds));
        }
        return list;
    }

    public List<Task> getTaskList(DataSet ds) {
        List<Task> list = new ArrayList<Task>();
        if (ds == null || ds.size() < 1) return list;
        while (ds.next()) {
            list.add(new Task(ds));
        }
        return list;
    }

    private List<Notification> getNotificationList(DataSet ds) {
        List<Notification> list = new ArrayList<Notification>();
        if (ds == null || ds.size() < 1) return list;
        while (ds.next()) {
            list.add(new Notification(ds));
        }
        return list;
    }

    public class Tool {
        public int idx;
        public String desc;
        public String offyn;
        public String timegap;
        public int taskidx;
        public String type;

        public Tool(DataSet ds) {
            idx = ds.getInt(1); // tool_idx
            taskidx = ds.getInt(2);
            desc = ds.getString(3);
            timegap = ds.getString(4);
            type = ds.getString(5);
        }
    }

    public class Notification {
        public int taskIdx;
        public String ntfcMessage;
        public String ntfcType;
        public int creator_idx;
        public String timegap;
        public String v_tbl_nm;
        public int n_tbl_idx;
        public String creator_photo;
        public String creator_name;
        public String task;

        public Notification(DataSet ds) {
            taskIdx = ds.getInt(1);
            ntfcMessage = ds.getString(2);
            ntfcType = "Feedback";
            creator_idx = ds.getInt(3);
            timegap = ds.getString(4);
            v_tbl_nm = ds.getString(5);
            n_tbl_idx = ds.getInt(6);
            creator_photo = getProfileImageUrl(creator_idx);
        }
    }

    public class Feedback {
        public int n_idx = -1;
        public int n_owner_idx = -1;
        public int taskidx = -1;
        public String desc;
        public String timegap = "";
        public String v_reg_datetime;
        public String v_task_desc;
        public int n_task_owner = -1;
        public String v_feedback_owner;
        public String c_task_status;
        public String domainyn;
        public String photourl = "";

        public Feedback(DataSet ds) {
            this.n_idx = ds.getInt(1);
            this.n_owner_idx = ds.getInt(2);
            this.taskidx = ds.getInt(3);
            this.desc = ds.getString(4);
            this.v_reg_datetime = ds.getString(5);
            this.v_task_desc = ds.getString(6);
            this.n_task_owner = ds.getInt(7);
            this.v_feedback_owner = ds.getString(8);
            this.c_task_status = ds.getString(9);
            // ds.getFloat(10) - gap(days)
            this.timegap = ds.getString(11);
            this.domainyn = ds.getString(12);
            this.photourl = getProfileImageUrl(n_owner_idx);
        }
    }

    public class Favorite {
        public int idx;
        public int taskidx;
        public String desc;

        public Favorite(DataSet ds) {
            idx = ds.getInt(1); // -- favorite idx
            taskidx = ds.getInt(2);
            desc = ds.getString(3);
        }
    }

    public class Task {
        public int idx;
        public String desc;
        public String offyn;
        public String timegap;
        public String domainyn;
        public Task(){}
        public Task(DataSet ds) {
            idx = ds.getInt(1);
            desc = ds.getString(2);
            offyn = ds.getString(3);
            timegap = ds.getString(4);
            domainyn = ds.getString(8);
        }
    }
%>