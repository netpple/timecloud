<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/include/incInit.jspf" %>
<%@ include file="../common/include/incSession.jspf" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>User List</title>
    <%@ include file="../common/include/incHead.jspf" %>
    <%@ include file="../common/include/incFileUpload.jspf" %>
    <script type="text/javascript">
        var TEAM_IDX = -1;
        function getTeamIdx() {
            return TEAM_IDX;
        }
        $(document).ready(function () {
            TEAM_IDX = getURLParameter("team_idx");
            getTeamInfo();
            getMemberList();
            setMemberSearch(); // click method set
        });

        function getTeamInfo() {
            $.getJSON("info.jsp?team_idx=" + getTeamIdx(), function (data) {
                if (data.result != "<%=Cs.SUCCESS%>") {
                    console.log(data.msg);
                    return false;
                }
                // 데이터 뿌림
                var team = $("#team_info td");
                team.eq(0).text(data.team_name); //팀명
                team.eq(1).html("<img src='" + data.owner_photo + "' onerror=\"this.src='/html/images/avatar.png'\" />" + data.owner_name); //팀장
                team.eq(2).text(data.regdate); //등록일
                team.eq(3).text(data.upddate); //갱신
            }).fail(function () {
                console.log("fail");
            });
        }

        function getMemberList() {
            $.getJSON("memberList.jsp?team_idx=" + getTeamIdx(), function (data) {
                if (data.result != "<%=Cs.SUCCESS%>") {
                    console.log(data.msg);
                    return false;
                }
                var tbody = $("#memberList tbody");

                if (data.count < 0) {
                    console.log(data.msg);
                    return false;
                }

                $(data.list).each(function () {
                    tbody.append(getMemberRow(this.idx, this.photo, this.name, this.email, this.tel));
                });
            }).done().fail(function () {
            }).always();
        }

        function setMemberSearch() {
            $("#memberSearch").on("click", function (event) {
                var email = $("#memberModal form.form-inline>input[name=email]").val();
                if (email.length <= 0) {
                    alert("email을 입력해주세요");
                    return false;
                }

                if (isMember(email))return false;

                if (isSearchedUser(email))return false;
                // 이미 조회된 사용자면 다시 검색하지 않음. 등록진행

                if (!validEmail(email))return false;

                memberSearch(email);
            });
        }

    </script>
    <script type="text/javascript">
        function getMemberRow(idx, photo, name, email, tel) {
            tr = "<tr id=user_" + idx + ">" +
                    "<td><img src='" + photo + "' onerror=\"this.src='/html/images/avatar.png'\" /></td>" +
                    "<td>" + name + "</td>" +
                    "<td class=email>" + email + "</td>" +
                    "<td>" + tel + "</td>" +
                    "<td><a href='javascript:deleteItem(" + idx + ");'><i class=icon-trash></i></a></td>" +
                    "</tr>";

            return tr;
        }

        function isSearchedUser(email) {
            var info = $("#memberInfo td");
            if (email == info.eq(0).text()) {
                if (confirm("등록하시겠습니까?"))
                    addItem();

                return true;
            }
            return false;
        }

        function isMember(email) {
            var existUser = false;
            $("#memberList td.email").each(function () { // 등록된 사용자 목록 들고와서 비교. 있으면 끝낸다.
                if ($(this).text() == email) {
                    alert("이미 등록된 사용자입니다.");
                    existUser = true;
                    return false;
                }
            });
            return existUser;
        }

        function validEmail(email) {
            // TODO - CODING
            return true;
        }
        function memberSearch(email) {
            var info = $("#memberInfo td");
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
        }

        function deleteMe(){    // 팀탈퇴
            deleteItem(<%=USER_IDX%>);
            alert("탈퇴하셨습니다.");
            location.replace("/");
        }

        function deleteItem(user_idx) {
            $.getJSON("memberDelete.jsp?team_idx=" + getTeamIdx() + "&user_idx=" + user_idx, function (data) {
                alert(data.msg);
                if (data.result == "<%=Cs.SUCCESS%>") { // 삭제 성공 시
                    $("#user_" + user_idx).remove();
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

            // 서버에 팀원 등록 요청
            $.getJSON("memberInsert.jsp?team_idx=" + getTeamIdx() + "&user_idx=" + user_id, function (json) {
                if (json.result != "<%=Cs.SUCCESS%>"){
                    alert(json.msg);
                    return false;
                }

                $("tbody", list).append(getMemberRow(user_id, photo_url, name, email, tel));
            }).done(function () {
                resetMemberInfo(info);
            }).fail(function () {
            }).always(function () {
            });




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
    <div class='span8'>
        <%@ include file="../menuGlobal.jsp" %>
        <div class="row-fluid">
            <%--<div class='span2 vertNav'><%=getVertNav(req, oUserSession) %></div>--%>
            <div class='span12 all'>
                <%-- --%>
                <%--<div class="row-fluid">--%>
                    <%--<div class="span6"><h3>Team</h3></div>--%>
                    <%--<div class="span6">--%>
                        <%--<button type="button" class="btn pull-right" onclick="javascript:if(confirm('탈퇴하시겠습니까?')){deleteMe();};">팀탈퇴</button>--%>
                    <%--</div>--%>
                <%--</div>--%>

                <table class="table table-bordered">
                    <tbody id="team_info">
                    <tr>
                        <th width="80px">팀 명</th>
                        <td></td>
                    </tr>
                    <tr>
                        <th>팀 장</th>
                        <td></td>
                    </tr>
                    <tr>
                        <th>등록일</th>
                        <td></td>
                    </tr>
                    <tr>
                        <th>갱신일</th>
                        <td></td>
                    </tr>
                    </tbody>
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
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="span1"></div>
    <%=getNotification(oUserSession, "span3 noti") %>
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
                <button type="button" class="btn btn-default" data-dismiss="modal"
                        onclick="javascript:resetMemberInfo($('#memberInfo td'))">Close
                </button>
                <button type="button" class="btn btn-primary" onclick="javascript:addItem();">Add</button>
            </div>
        </div>
    </div>
</div>
<%--Modal--%>
</body>
</html>