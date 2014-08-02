<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../../common/include/incInit.jspf" %>
<%@ include file="../../common/include/incSession.jspf" %>
<%
    int iUserIdx = req.getIntParam("pUserIdx", -1);
    String sUserName = req.getParam("pUserName", "");
    String sTel = req.getParam("pTel", "");
    String sNotiEmail = req.getParam("pNotiEmail");

    if ("".equals(sUserName)) {
        out.println("user name must be exists.");
        return;
    } else {
        sUserName = sUserName.trim();
        if (sUserName.length() < 2) {
            out.println("user name is too short .");
            return;
        }
    }

    String key = "INSERT_USER"; // -- QUERY KEY
    String[] param = null;

    int result = 0;

    if (iUserIdx > 0) {    // -- 수정

        DataSet oUserInfo = QueryHandler.executeQuery("SELECT_USER_INFO", iUserIdx);
        String sSavePassword = "";

        if (oUserInfo != null && oUserInfo.next()) {
            String sOriginPassword = oUserInfo.getString(7);
            String sInputOriginPassword = req.getParam("pUserPasswdNow", "");
            String isPartnerControl = req.getParam("pPartnerControl", "N");

            if ("N".equals(isPartnerControl)) {
                if ("".equals(sInputOriginPassword) == true) {
                    out.print(JavaScript.write("alert('현재 패스워드를 입력하세요'); history.back(1);"));
                    return;
                }

                sSavePassword = sOriginPassword;

                if (sOriginPassword.equals(sInputOriginPassword) == false) {
                    out.print(JavaScript.write("alert('현재 패스워드를 확인하세요'); history.back(1);"));
                    return;
                }
            }

            String sPassword1 = req.getParam("pUserPasswd", "");
            String sPassword2 = req.getParam("pUserPasswd2", "");
            String passwordRepl = " ";

            if ("".equals(sPassword1) == false && "".equals(sPassword2) == false) {
                passwordRepl = "V_PASSWD = FN_CRYPT('1','" + sPassword2 + "','TT'),";
                if (sPassword1.equals(sPassword2) == false) {
                    out.print(JavaScript.write("alert('동일 패스워드를 입력하세요'); history.back(1);"));
                    return;
                }

                sSavePassword = sPassword1;
            }

            key = "UPDATE_USER";
            param = new String[]{sUserName, sTel, sNotiEmail, Integer.toString(iUserIdx)};

            if ("Y".equals(isPartnerControl)) {
                String[] partners = req.getParamValues("pObserver");

                QueryHandler.executeUpdate("DELETE_PARTNER", iUserIdx);

                if (partners != null) {
                    for (String partner : partners) {
                        QueryHandler.executeUpdate("INSERT_PARTNER", new Object[]{iUserIdx, partner});
                    }
                }
            }

            Cookie loginPwd = Util.getCookie(request, Cs.TIMECLOUD_LOGIN_PWD);

            if (loginPwd != null) {
                loginPwd.setMaxAge(60 * 60 * 24 * 30);
                loginPwd.setValue(Util.getMD5Hash(sPassword2));
                response.addCookie(loginPwd);
            }

            result = QueryHandler.executeUpdate(key, param, passwordRepl);

        } else {
            out.println("fail to update");
        }
    } else { // -- 신규등록
        String pUserEmail = req.getParam("pUserEmail");
        String pUserPasswd = req.getParam("pUserPasswd");
        // -- validation
        if (pUserEmail == null || pUserPasswd == null) {
            out.println("email or password is null");
            return;
        }

        pUserEmail = pUserEmail.trim();
        pUserPasswd = pUserPasswd.trim();
        if (pUserEmail.length() < 5 || pUserPasswd.length() < 1) { // -- email과 비밀번호 길이 체크
            out.println("email or password length is too short.");
            return;
        }

        // -- TODO - EMAIL 및 비밀번호 정규화 체크 로직 필요
        // -- TODO - VALIDATION 공통함수 필요

        param = new String[]{
                pUserEmail,
                pUserPasswd,
                sUserName,
                sTel
        };

        result = QueryHandler.executeUpdate(key, param);
    }

    String url = "";

    if (iUserIdx > 0) {
        url = "location.replace('userInfo.jsp?user_idx=" + iUserIdx + "');";
    } else {
        url = "location.replace('list.jsp')";
    }

    if (result > 0) {
        out.print(JavaScript.write("alert('사용자 정보저장 완료');" + url));
    } else {
        out.print(JavaScript.write("alert('사용자 정보저장 실패');" + url));
    }


%>
<%!
    private String getExtention(String filename) {
        String suffix = "";
        int pos = filename.lastIndexOf('.');
        if (pos > 0 && pos < filename.length() - 1) {
            suffix = filename.substring(pos + 1);
        }
        return suffix.toLowerCase();
    }
%>
