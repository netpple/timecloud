<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../../common/include/incInit.jspf" %>
<%@ include file="../../common/include/incSession.jspf" %>
<%
    DataSet ds = QueryHandler.executeQuery("SELECT_DOMAIN_USER_LIST", DOMAIN_IDX);

    String listOff = "", tabOff = "<small class='label label-important'>OFF</small>";
    String listOn = "", tabOn = "<small class='label label-warning'>ON</small>";
    if (ds != null) {
        UserInfo user = null;
        String team = "", tr = "", status = "", idx = "";
        while (ds.next()) {
            user = new UserInfo(ds);
            team = user.getTeam();
            idx = user.getIdx();
            if ("".equals(team)) team = "등록된 팀이 없습니다.";

            tr = Html.td(idx)
                    + Html.td(user.getName())
                    + Html.td(getProfileImage(user.getIdx()))
                    + Html.td(user.getEmail())
                    + Html.td(team)
                    + Html.td(user.getEdtDatetime())
                    + Html.td(user.getRegDatetime());

            if (user.isOFF()) {
                status = "<input type='button' class='btn btn-mini btn-danger' value='Off' onClick='javascript:switchOn("
                        + idx + ")' />";
                listOff += Html.tr(tr + Html.td(status));
            } else { // 정상일때 누르면 끄게 됨
                status = "<input type='button' class='btn btn-mini btn-warning' value='On' onClick='javascript:switchOff("
                        + idx + ")' />";
                listOn += Html.tr(tr + Html.td(status));
            }
        }

        String th = "<thead><tr><th>#</th><th>이름</th><th>" + Html.Icon.USER + "</th><th>계정</th><th>소속팀</th><th>lastModified</th><th>최초등록</th><th>상태</th></tr></thead>";
        listOn = Html.table(th + listOn, "class='table table-bordered table-hover'");
        listOff = Html.table(th + listOff, "class='table table-bordered table-hover'");
    }

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>User List</title>
    <%@ include file="../../common/include/incHead.jspf" %>
    <script type="text/javascript">
        function switchOn(idx) {
            if (confirm("사용자를 활성화합니다.\n계속하시겠습니까?")) {
                location.replace("<%=CONTEXT_PATH%>/jsp/admin/user/toggle.jsp?user_idx=" + idx);
            }
            return;
        }

        function switchOff(idx) { // -- task termination
            if (confirm("사용자를 비활성화합니다.\n계속하시겠습니까?")) {
                location.replace("<%=CONTEXT_PATH%>/jsp/admin/user/toggle.jsp?user_idx=" + idx);
            }
            return;
        }

        function check() {
            var f = document.getElementById('f1');

            var email = f.user_email.value;
            var uname = f.user_name.value;
            if (email.length < 5) {
                alert("이메일을 확인해 주세요.");
                return;
            }
            if (uname.length < 2) {
                alert("이름을 확인해 주세요.");
                return;
            }
            var p1 = f.user_passwd.value;
            var p2 = f.user_passwd2.value;
            if (p1 == '') {
                alert("비밀번호를 입력해 주세요");
                return;
            }
            if (p1.length < 4) {
                alert("비밀번호는 4글자 이상입니다.");
                return;
            }
            if (p1 != p2) {
                alert("비밀번호가 일치하지 않습니다.");
                return;
            }

            f.submit();
        }
    </script>
</head>
<body>
<div class="row-fluid">
    <div class='span12'>
        <%@ include file="../../menuGlobal.jsp" %>
        <div class="row-fluid">
            <table width="100%">
                <tr>
                    <td align="right">
                        <!-- Button trigger modal -->
                        <button class="btn btn-primary btn-lg text-right" data-toggle="modal" data-target="#myModal">사용자
                            추가
                        </button>
                    </td>
                </tr>
            </table>

            <%--Modal--%>
            <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal"><span
                                    aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                            <h4 class="modal-title" id="myModalLabel">사용자 등록</h4>
                        </div>
                        <div class="modal-body">
                            <form id='f1' method='post' action='insert.jsp'>
                                <table>
                                    <tr>
                                        <td>이메일:</td>
                                        <td><input type="text" name="user_email"/></td>
                                    </tr>
                                    <tr>
                                        <td>이름:</td>
                                        <td><input type="text" name="user_name"/></td>
                                    </tr>
                                    <tr>
                                        <td>비밀번호 입력:</td>
                                        <td><input type="password" name="user_passwd"/></td>
                                    </tr>
                                    <tr>
                                        <td>비밀번호 확인:</td>
                                        <td><input type="password" name="user_passwd2"/></td>
                                    </tr>
                                </table>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                            <button type="button" class="btn btn-primary" onclick="javascript:check();">Save changes
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <%--Modal--%>
            <ul class="nav nav-tabs">
                <li class=active><a href="#tab1" data-toggle="tab"><%=tabOn %>
                </a></li>
                <li><a href="#tab2" data-toggle="tab"><%=tabOff %>
                </a></li>
            </ul>
            <br/>

            <div class='tab-content'>
                <div class='tab-pane active' id='tab1'><%=listOn %>
                </div>
                <div class='tab-pane' id='tab2'><%=listOff %>
                </div>
            </div>
            <%-- --%>
        </div>
    </div>
</div>
</body>
</html>
<%!

    class UserInfo {
        String n_idx;
        String v_email;
        String v_name;
        String v_reg_datetime;
        String v_edt_datetime;
        String c_off_yn;
        String team;

        public UserInfo(DataSet ds) {
            this.n_idx = ds.getString(1);
            this.v_email = ds.getString(2);
            this.v_name = ds.getString(3);
            this.c_off_yn = ds.getString(4);
            this.v_reg_datetime = ds.getString(5);
            this.v_edt_datetime = ds.getString(6);
            this.team = ds.getString(7);
        }

        public boolean isOFF() {
            return "Y".equals(c_off_yn);
        }

        public String getName() {
            return v_name;
        }

        public String getRegDatetime() {
            return v_reg_datetime;
        }

        public String getEdtDatetime() {
            return v_edt_datetime;
        }

        public String getEmail() {
            return v_email;
        }

        public String getTeam() {
            return team;
        }

        public String getOffYn() {
            return c_off_yn;
        }

        public String getIdx() {
            return n_idx;
        }
    }
%>