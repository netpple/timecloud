<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/include/incInit.jspf" %>
<%@ include file="../common/include/incSession.jspf" %>
<%
    int p = req.getIntParam("p", 1); // paging
    int start = 1 + (p - 1) * 10;
    int end = start + 10 - 1;

    JsonResult result = new JsonResult();

    List<Tool> recently = getToolList(QueryHandler.executeQuery("SELECT_TIMELINE", new String[]{USER_IDX}, String.format("AND 1=1^WHERE ro BETWEEN %d AND %d", start, end)));

    result.recently = recently; // recently tools
    result.count = recently.size();

    result.result = Cs.SUCCESS;
    result.msg = Cs.SUCCESS_MSG_1;

    result.nexturl = String.format("/jsp/timeline/list.jsp?p=%d",p+1);

    out.print(new Gson().toJson(result));
%><%!
    // DAO
    public class JsonResult {
        public String result = Cs.FAIL;
        public String msg = Cs.FAIL_MSG_1;
        public int count = 0;
        public List<Tool> recently;
        public String nexturl = null;
    }

    public List<Tool> getToolList(DataSet ds) {
        List<Tool> list = new ArrayList<Tool>();
        if (ds == null || ds.size() < 1) return list;
        while (ds.next()) {
            list.add(new Tool(ds));
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


%>