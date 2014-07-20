<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/include/incInit.jspf" %>
<%@ include file="../common/include/incSession.jspf" %>
<%
    RequestHelper mReq = new RequestHelper(request, response);
    int idx = mReq.getIntParam("team_idx", -1);
    if (idx < 1) {
        out.print(JavaScript.write("alert('잘못된 접근입니다.');location.replace('list.jsp');"));
        return;
    }

    DataSet ds = QueryHandler.executeQuery("SELECT_TEAM_INFO", new String[]{USER_IDX, DOMAIN_IDX, Integer.toString(idx)});
    TeamInfo team = null;
    if (ds != null && ds.next()) team = new TeamInfo(ds);

    if (team == null) {
        out.print(JavaScript.write("alert('접근권한이 없습니다.');location.replace('list.jsp');"));
        return;
    }

    final String team_idx = team.getIdx();
    final String team_name = team.getName();
    final String owner_name = team.getOwnerName();
    final String owner_idx = team.getOwnerIdx();
    final String owner_photo = getProfileImage(owner_idx);
    String regdate = team.getRegDatetime();
    String upddate = team.getEdtDatetime();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>User List</title>
    <%@ include file="../common/include/incHead.jspf" %>
    <%@ include file="../common/include/incFileUpload.jspf" %>

    <script type="text/javascript">
        $(document).ready(function () {
            $("#memberSearch").on("click", function (event) {
                var email = $("#memberModal form.form-inline>input[name=email]").val();
                if (email.length <= 0) {
                    alert("email을 입력해주세요");
                    return false;
                }

                var existUser = false;
                $("#memberList td.email").each(function () { // 등록된 사용자 목록 들고와서 비교. 있으면 끝낸다.
                    if ($(this).text() == email) {
                        alert("이미 등록된 사용자입니다.");
                        existUser = true;
                        return false;
                    }
                });
                if (existUser)return false;

                // 이미 조회된 사용자면 스킵한다.
                var info = $("#memberInfo td");
                if (email == info.eq(0).text()) {
                    if(confirm("등록하시겠습니까?"))
                        addItem();
                    return false;
                }

                // TODO - email validation

                // ajax request for json result
                $.getJSON("member.jsp?email=" + email, function (data) {
                    if (data.result != '0') {
                        alert(data.msg);
                        return false;
                    }

                    info.eq(0).text(data.email);
                    info.eq(0).attr({id: data.idx});
                    info.eq(1).text(data.name);
                    info.eq(2).html("<img src='" + data.photo + "' onerror=\"this.src='/html/images/avatar.png'\">");
                    info.eq(3).text(data.tel);
                }).done(function () {
                }).fail(function () {
                }).always(function () {
                });
            });
        });

        function deleteItem(user_idx) {
            $.getJSON("memberDelete.jsp?team_idx=<%=team_idx%>&user_idx=" + user_idx, function (data) {
                alert(data.msg);
                if (data.result == "<%=Cs.SUCCESS%>") { // 삭제 성공 시
                    $("#user_"+user_idx).remove();
                }
            }).done().fail().always();
        }

        function addItem() {
            var info = $("#memberInfo td"); // td 엘리먼트 배열
            var list = $("#memberList");
            // 등록할 아이템 체크
            var email = info.eq(0).text();
            if (email == "") { // 추가할 사용자가 없는 경우
                alert("등록할 사용자를 검색해주세요");
                return false;
            }
            var name = info.eq(1).text();
            var photo_url = info.eq(2).find("img").attr('src');
            var tel = info.eq(3).text();
            var user_id = info.eq(0).attr('id');

            // 목록 체크
            if ($("tbody tr.none", list).length == 1) // 빈 목록일 경우. tr.none 제거
                $("tbody tr.none", list).remove();
            else { // 목록이 있을 경우 이미 등록된 사용자 인지 확인
                var existUser = false;
                $("td.email", list).each(function () { // 등록된 사용자 목록 들고와서 비교. 있으면 끝낸다.
                    if ($(this).text() == email) {
                        alert("이미 등록된 사용자입니다.");
                        existUser = true;
                        return false;
                    }
                });
                if (existUser) {
                    resetMemberInfo(info);
                    return false;
                }
            }

            $.getJSON("memberInsert.jsp?team_idx=<%=team_idx%>&user_idx=" + user_id, function (json) {
                if(json.result != "<%=Cs.SUCCESS%>")
                    alert(json.msg);
            }).done(function () {
            }).fail(function () {
            }).always(function () {
            });

            $("tbody", list).append("<tr id='user_"+user_id+"'><td><img src='"
                    + photo_url + "' onerror=\"this.src='/html/images/avatar.png'\"/></td><td>"
                    + name + "</td><td class=email>"
                    + email + "</td><td>"
                    + tel + "</td><td><a href='javascript:deleteItem(" + user_id + ");'><i class=icon-trash></i></a></td></tr>");

            resetMemberInfo(info);
        }

        function resetMemberInfo(info) {
            info.each(function () {
                $(this).text("");
            });
            info.eq(0).removeAttr("id");

            $("#memberModal form input[type=text]").val("");
        }
    </script>
</head>
<body>
<div class="row-fluid">
    <div class='span10'>
        <%@ include file="../menuGlobal.jsp" %>
        <div class="row-fluid">
            <div class='span2 vertNav'><%=getVertNav(req, oUserSession) %>
            </div>
            <div class='span10 all'>
                <%-- --%>
                <h3>Team</h3>
                <table class="table table-bordered">
                    <tr>
                        <th width="80px">팀 명</th>
                        <td><%=team_name%>
                        </td>
                    </tr>
                    <tr>
                        <th>팀 장</th>
                        <td><%=owner_photo + " " + Html.span(owner_name)%>
                        </td>
                    </tr>
                    <tr>
                        <th>등록일</th>
                        <td><%=regdate%>
                        </td>
                    </tr>
                    <tr>
                        <th>갱신일</th>
                        <td><%=upddate%>
                        </td>
                    </tr>
                </table>
                <div class="form-actions">
                    <button type="button" class="btn pull-right" data-toggle="modal" data-target="#memberModal">팀원 등록
                    </button>
                </div>
                <%-- --%>
                <div id="memberList">
                    <table class='table table-bordered table-hover'>
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>이름</th>
                            <th>이메일</th>
                            <th>연락처</th>
                            <th>&nbsp;</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            List<UserInfo> list = UserInfo.getTeamUsers(team_idx, DOMAIN_IDX);
                            if (list != null && list.size() > 0) {
                                Iterator<UserInfo> it = list.iterator();
                                StringBuffer sbTr = new StringBuffer();
                                while (it.hasNext()) {
                                    UserInfo info = it.next();
                                    sbTr.append(Html.tr(Html.td(getProfileImage(info.getIdx()))
                                                    + Html.td(info.getName())
                                                    + Html.td(info.getEmail(), "class=email")
                                                    + Html.td(info.getTel())
                                                    + Html.td("<a href='javascript:deleteItem(" + info.getIdx() + ");'><i class=icon-trash></i></a>"), "id=user_"+info.getIdx())
                                    );
                                }
                                out.print(sbTr.toString());
                            } else {
                        %>
                        <tr class="none">
                            <td style='text-align:center' colspan=6>데이터가 없습니다.</td>
                        </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <%=getNotification(oUserSession, "span2 noti") %>
</div>
<%--Modal Password--%>
<div class="modal fade" id="memberModal" tabindex="-1" role="dialog" aria-labelledby="memberModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span
                        aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                <h4 class="modal-title" id="memberModalLabel">팀원 등록</h4>
            </div>
            <div class="modal-body">
                <form class="form-inline" role="search"
                      onkeypress='if(event.keyCode==13){$("#memberSearch").click();return false;}'>
                    <span>이메일:</span>
                    <input type="text" name="email" class="form-control" placeholder="Search">
                    <button id="memberSearch" type="button" class="btn btn-default">조회</button>
                </form>
                <div id="memberInfo">
                    <table class="table table-bordered">
                        <tr>
                            <th width="80px">이메일</th>
                            <td></td>
                        </tr>
                        <tr>
                            <th>이름</th>
                            <td></td>
                        </tr>
                        <tr>
                            <th>사진</th>
                            <td></td>
                        </tr>
                        <tr>
                            <th>연락처</th>
                            <td></td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal" onclick="javascript:resetMemberInfo($('#memberInfo td'))">Close</button>
                <button type="button" class="btn btn-primary" onclick="javascript:addItem();">Add</button>
            </div>
        </div>
    </div>
</div>
<%--Modal--%>
</body>
</html>