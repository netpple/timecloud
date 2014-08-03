<%@ page import="com.twobrain.common.util.Html" %>
<%@ page import="java.util.Iterator" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/include/incInit.jspf" %>
<%@ include file="../common/include/incSession.jspf" %>
<%
    if (TEAM_IDX > 0) {
        response.sendRedirect("view.jsp");
        return;
    }
    List<TeamInfo> teams = TeamInfo.getDomainTeams(DOMAIN_IDX);

    final String thead = "<thead><tr><th>#</th><th>팀</th><th>팀원수</th><th>팀장</th><th>lastModified</th><th>최초등록</th><th>가입</th></tr></thead>";
    String nodata = Html.tr(Html.td("데이터가 없습니다.", "style='text-align:center' colspan=8"));

    StringBuffer sbListOn = new StringBuffer(thead);
    int oncnt = 0;
    String join = "";
    if (teams != null && teams.size() > 0) {
        TeamInfo team = null;
        Iterator<TeamInfo> it = teams.iterator();
        String row = "", idx = "", n_owner_idx = "", owner_name = "";
        while (it.hasNext()) {
            team = it.next();
            idx = team.getIdx();
            n_owner_idx = team.getOwnerIdx();
            owner_name = team.getOwnerName();

            row = Html.td(idx)
                    + Html.td(Html.a(team.getName(), String.format("href='view.jsp?team_idx=%s'", idx)))
                    + Html.td(team.getUserCnt())
                    + Html.td(getProfileImage(n_owner_idx) + Html.span(" " + owner_name))
                    + Html.td(team.getEdtDatetime())
                    + Html.td(team.getRegDatetime())
                    + Html.td(Html.button("가입", "onclick='javascript:joinTeam(" + idx + ");'"));
            sbListOn.append(Html.tr(row));
        }
    }

    if (oncnt == 0) sbListOn.append(nodata);

    String listOn = Html.table(sbListOn.toString(), "class='table table-bordered table-hover'");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>User List</title>
    <%@ include file="../common/include/incHead.jspf" %>
    <script type="text/javascript">
        function joinTeam(idx) {
            if (confirm("가입하시겠습니까?")) {
                // 서버에 팀원 등록 요청
                $.getJSON("memberInsert.jsp?team_idx=" + idx + "&user_idx=" + <%=USER_IDX%>, function (json) {
                    if (json.result != "<%=Cs.SUCCESS%>") {
                        alert(json.msg);
                        return false;
                    }
                    alert("가입되었습니다.");
                    location.reload();
                    return false;
                }).done(function () {
                }).fail(function () {
                }).always(function () {
                });
            }


            return;
        }
    </script>
</head>
<body>
<div class="row-fluid">
    <div class='span12'>
        <%@ include file="../menuGlobal.jsp" %>
        <div class="row-fluid">
            <%--<div class='span2 vertNav'><%=getVertNav(req, oUserSession) %></div>--%>
            <div class='span12 all'>
                <%-- --%>
                <table width="100%">
                    <tr>
                        <td><h3>Current Team List</h3></td>
                        <td align="right">
                            <!-- Button trigger modal -->
                            <button class="btn btn-primary btn-lg text-right" data-toggle="modal"
                                    data-target="#myModal">팀 등록
                            </button>
                        </td>
                    </tr>
                </table>

                <%-- Modal --%>
                <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
                     aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><span
                                        aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                                <h4 class="modal-title" id="myModalLabel">팀 등록</h4>
                            </div>
                            <div class="modal-body">
                                <form id='f1' method='post' action='insert.jsp'>
                                    <table>
                                        <tr>
                                            <td>팀 명 :</td>
                                            <td><input type="text" name="team_name"/></td>
                                        </tr>
                                    </table>
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                <button type="button" class="btn btn-primary"
                                        onclick="javascript:document.getElementById('f1').submit();">Save changes
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <div><%=listOn %>
                </div>
                <%-- --%>
            </div>
        </div>
    </div>
    <%--<%=getNotification(oUserSession, "span3 noti") %>--%>
</div>
</body>
</html>