<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="./common/include/incInit.jspf" %>
<%@ include file="./common/include/incSession.jspf" %>
<%
    if (TASK_IDX <= 0) {
        out.println("Parameter is invalid");
        return;
    }

    final String STR_TASK_IDX = "" + TASK_IDX;

    NotificationService ntfcService = new NotificationService(oUserSession);

    int result = -1; // -- 처리 결과 확인용

    final String OWNER_IDX = "" + ownerIdx;

    String sStartDate = req.getParam("pStartDate", "").replace("-", "");
    String sEndDate = req.getParam("pEndDate", "").replace("-", "");

    // -- 최초입력 시 캘린더 쪽에서 시간입력란 제거 (너무 복잡하고, 잘 안쓸것이기 때문)
    String sStartTime = req.getParam("pStartTime","0000").replace(":","");
    String sEndTime = req.getParam("pEndTime","0000").replace(":","");

    String sStartDateTime = sStartDate + sStartTime + "00";
    String sEndDateTime = sEndDate + sEndTime + "00";

    String sDescription = req.getParam("pDescription", "");
    int iTaskAssignUserId = req.getIntParam("pTaskAssignUserId", -1);

    int iActivityIdx = req.getIntParam("pActivityIdx", -1);

    String ACTIVITY_SEQ,MY_KEY;
    String[] MY_PARAM;
    if(iActivityIdx <= 0) {
        ACTIVITY_SEQ = QueryHandler.executeQueryString("SELECT_ACTIVITY_SEQ");
        MY_KEY = "INSERT_ACTIVITY2";
        MY_PARAM = new String[]{    // -- Task Owner에게 할당되므로, 현재 Task Key가 할당돼야 함.
                ACTIVITY_SEQ,
                STR_TASK_IDX,
                sDescription,
                sStartDateTime,
                sEndDateTime,
                OWNER_IDX,
                DOMAIN_IDX
        };
    }
    else { // 수정모드로 들어온 경우
        ACTIVITY_SEQ = Integer.toString(iActivityIdx);
        MY_KEY = "UPDATE_ACTIVITY";
        MY_PARAM = new String[]{
                sDescription,
                sStartDateTime,
                sEndDateTime,
                ACTIVITY_SEQ,
                OWNER_IDX
        };
    }

    // -- 타인 할당일 경우, 태스크 등록 있음.
    if (iTaskAssignUserId > 0) { // -- 본인할당 기능 추가 - 2013.02.26 -  && iTaskAssignUserId != ownerIdx) {
        // -- Owner Task 확인
        DataSet ds = QueryHandler.executeQuery("SELECT_TASK_LIST2", new String[]{STR_TASK_IDX, OWNER_IDX});
        if (ds == null || !ds.next()) {
            out.println("-1");
            return;
        }

        int iTaskList = ds.getInt(1); // -- TOP TASK IDX
        int iTaskLevel = ds.getInt(2); // -- PARENT TASK LEVEL
        int iTaskRidx = ds.getInt(3); // -- PARENT TASK RIDX

        // -- UPDATE TIMECLOUD_TASK SET N_RIDX=N_RIDX+1 WHERE N_LIST=? AND N_RIDX >= ?

        int newTaskSeq = QueryHandler.executeQueryInt("SELECT_TASK_SEQ");

        Vector<Object> vInsertTaskTransaction = new Vector<Object>();

        // -- 할당 태스크 삽입 위치 확보
        vInsertTaskTransaction.add("UPDATE_TASK_RIDX");
        vInsertTaskTransaction.add(new String[]{"" + iTaskList, "" + iTaskRidx});

        // -- 할당 태스크 등록
        vInsertTaskTransaction.add("INSERT_TASK");
        vInsertTaskTransaction.add(new Object[]{
                newTaskSeq,
                STR_TASK_IDX,        // -- 부모 idx
                "" + iTaskList,        // -- 최상위 태스크 idx
                "" + (iTaskLevel + 1),    // -- 부모 레벨 + 1
                "" + (iTaskRidx + 1),    // -- 부모 정렬 + 1, 부모 밑에 달림
                sDescription,
                "" + iTaskAssignUserId,
                DOMAIN_IDX});

        // -- 할당 액티비티 등록
        vInsertTaskTransaction.add("INSERT_ACTIVITY");
        vInsertTaskTransaction.add(new Object[]{
                newTaskSeq,
                sDescription,
                sStartDateTime,
                sEndDateTime,
                "" + iTaskAssignUserId,
                DOMAIN_IDX
        });

        if (iTaskAssignUserId != ownerIdx) {
            // -- 본인 액티비티로도 등록
            vInsertTaskTransaction.add(MY_KEY);
            vInsertTaskTransaction.add(MY_PARAM);
        }

        String sTransactionResult = QueryHandler.executeTransaction(vInsertTaskTransaction);
        if (sTransactionResult.equals(Cs.COMMIT)) {
            result = 1;
            ntfcService.sendTaskNotification(newTaskSeq);
        }

        String[] observerUsers = req.getParamValues("pObserver");

        if (observerUsers != null) {

            String pComment = req.getParam("pComment", req.getParam("pDescription", ""));    // 참조시 내용, 참조 내용이 없으면 기본 내용데이터로 삽입

            int ret = 0;
            int observerIdx = 0;

            for (int i = 0; i < observerUsers.length; i++) {
                observerIdx = QueryHandler.executeQueryInt("GET_OBSERVER_SEQUENCE");
                String userIdx = observerUsers[i];
                ret += QueryHandler.executeUpdate("INSERT_OBSERVER"
                        , new String[]{"" + observerIdx, pComment, userIdx, "" + newTaskSeq, DOMAIN_IDX});
            }

            if (ret > 0) {
                ntfcService.sendObserverNotification(newTaskSeq);
            }
        }

    } else { // -- 본인의 액티비티 일 경우, 태스크 등록 없음.
        result = QueryHandler.executeUpdate(MY_KEY, MY_PARAM);
    }

    if (result > 0) {
        out.print(ACTIVITY_SEQ);
        // googleCalendarAPI.insertEvent(req.getParam("pDescription","Null Event"), req.getParam("pStartDate",""), req.getParam("pEndDate",""));
        // -- TODO - 방금 등록한 ACTIVITY의 SEQUENCE를 리턴해줘야 함.
    } else out.print("-1");
%>