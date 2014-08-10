<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/include/incInit.jspf" %>
<%@ include file="../common/include/incSession.jspf" %>
<%
    int p = req.getIntParam("p",1); // paging
    int start = 1 +(p-1)*10;
    int end = start + 10 - 1;
    JsonResult result = new JsonResult();
    List<Feedback> feedbackList = getFeedbackList(
            QueryHandler.executeQuery(
                    "SELECT_FEEDBACK_ALL2"
                    , new String[]{USER_IDX, USER_IDX}
                    , String.format("WHERE 1=1^WHERE ro BETWEEN %d AND %d",start,end)));

    result.feedbacks = feedbackList;
    result.count = feedbackList.size();

    result.result = Cs.SUCCESS;
    result.msg = Cs.SUCCESS_MSG_1;

    result.nexturl = String.format("/jsp/feedback/list.jsp?p=%d",p+1);


    out.print(new Gson().toJson(result));
%><%!
    // DAO
    public class JsonResult {
        public String result = Cs.FAIL;
        public String msg = Cs.FAIL_MSG_1;
        public int count = 0;
        public List<Feedback> feedbacks;
        public String nexturl = null;

    }

    public List<Feedback> getFeedbackList(DataSet ds) {
        List<Feedback> list = new ArrayList<Feedback>();
        while (ds.next()) {
            list.add(new Feedback(ds));
        }

        return list;
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
            this.photourl = getProfileImageUrl(n_owner_idx);
        }
    }
%>