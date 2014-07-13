<%@ page import="java.io.File" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/include/incInit.jspf" %>
<%@ include file="../common/include/incSession.jspf" %>
<%
    final String FILE_UPLOAD_BASE_REPOSITORY = Config.getProperty("init", "FILE_UPLOAD_BASE_REPOSITORY");    //업로드 위치
    String uploadPath = FILE_UPLOAD_BASE_REPOSITORY + "/profile/";   // 프로필 원본 저장할 필요있나 ? 일단 하자.
    System.out.println(String.format("%s%s", uploadPath, USER_IDX));
    File myPhoto = new File(String.format("%s%s", uploadPath, USER_IDX));
    boolean hasMyPhoto = myPhoto.exists();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>프로필 사진 변경</title>
    <%@ include file="../common/include/incHead.jspf" %>
</head>
<body>
<div class='row-fluid'>
    <div>
        <div><%=getProfileImage(oUserSession.getDomainIdx(), oUserSession.getUserIdx())%>
            <%--<div class="row fileupload-buttonbar" style="margin-left:5px;">--%>
                <%
                    if (!hasMyPhoto) {
                %>
                <form id="fileupload" action="/jsp/profile/photoAction.jsp" method="POST" enctype="multipart/form-data">
                    <div class="col-lg-7">
                        <input type="file" name="file">
                        <button type="submit" class="btn btn-primary start">
                            <i class="glyphicon glyphicon-upload"></i>
                            <span class="file">저장</span>
                        </button>
                    </div>
                </form>
                <%} else {%>
                <button type="button" class="btn btn-primary start" onclick="javascript:location.replace('/jsp/profile/photoAction.jsp?pAction=DeleteFile');">
                    <i class="glyphicon glyphicon-upload"></i>
                    <span class="file">삭제</span>
                </button>
                <%}%>
            <%--</div>--%>
        </div>
    </div>
</div>
</body>
</html>