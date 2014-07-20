package com.twobrain.common.constants;

public class Cs {
    private Cs(){}
	public static final String FILE_TYPE_PROFILE_IMAGE = "0001";
	public static final String COMMIT = "commit";
	
	public static final String REPO_BASE_PATH = "FILE_UPLOAD_BASE_REPOSITORY";
	
	public static final String USER_PROFILE_IMAGE_URN = "USER_PROFILE_IMAGE_URN" ;
	
//	public static final String TIMECLOUD_LOGIN_ID = "TIMECLOUD_LOGIN_ID";

	public static final String TIMECLOUD_LOGIN_DOMAIN = "TIMECLOUD_LOGIN_DOMAIN";
	public static final String TIMECLOUD_LOGIN_EMAIL = "TIMECLOUD_LOGIN_EMAIL";
	public static final String TIMECLOUD_LOGIN_PWD = "TIMECLOUD_LOGIN_PWD";

// ACTION TYPE
    public static final String PARAM = "0";
    public static final String CREATE = "1";
    public static final String READ = "2";
    public static final String UPDATE = "3";
    public static final String DELETE = "4";
    public static final String AUTH = "5";

// CODE FORMAT
    public static final String FORMAT_CODE = "%s%s";

// SUCCESS CODE
    public static final String SUCCESS = "0";
    public static final String SUCCESS_PARAM = String.format(FORMAT_CODE,SUCCESS,PARAM);
    public static final String SUCCESS_CREATE = String.format(FORMAT_CODE,SUCCESS,CREATE);
    public static final String SUCCESS_READ = String.format(FORMAT_CODE,SUCCESS,READ);
    public static final String SUCCESS_UPDATE = String.format(FORMAT_CODE,SUCCESS,UPDATE);
    public static final String SUCCESS_DELETE = String.format(FORMAT_CODE,SUCCESS,DELETE);
    public static final String SUCCESS_AUTH = String.format(FORMAT_CODE,SUCCESS,AUTH);

// FAIL CODE
    public static final String FAIL = "1"; // 그냥 에러
    public static final String FAIL_PARAM = String.format(FORMAT_CODE,FAIL,PARAM);
    public static final String FAIL_CREATE = String.format(FORMAT_CODE,FAIL,CREATE);
    public static final String FAIL_READ = String.format(FORMAT_CODE,FAIL,READ);
    public static final String FAIL_UPDATE = String.format(FORMAT_CODE,FAIL,UPDATE);
    public static final String FAIL_DELETE = String.format(FORMAT_CODE,FAIL,DELETE);
    public static final String FAIL_AUTH = String.format(FORMAT_CODE,FAIL,AUTH);

// FAIL MESSAGE
    public static final String FAIL_MSG_1 = "처리실패";
    public static final String FAIL_MSG_2 = "잘못된 접근입니다.";
    public static final String FAIL_MSG_3 = "요청하신 정보가 없습니다.";

// SUCCESS MESSAGE
    public static final String SUCCESS_MSG_1 = "처리되었습니다.";
    public static final String SUCCESS_MSG_2 = "저장되었습니다.";
    public static final String SUCCESS_MSG_3 = "삭제되었습니다.";
}