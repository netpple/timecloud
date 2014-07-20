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

// SUCCESS CODE
    public static final String SUCCESS = "0";
// FAIL CODE (0 is SUCCESS)
    public static final String FAIL = "1"; // 그냥 에러
    public static final String FAIL_USER = "11"; // 에러 사유 : USER관련 에러
    public static final String FAIL_USER_GET_NONE = "1110"; // 에러(1)고, USER(1)에서 GET(1)하다 났고, USER정보가 없다.(결과없음)
    public static final String FAIL_USER_GET_PARAM = "1111"; // 파라메터이상
    public static final String FAIL_USER_GET_ERROR = "1112"; // 에러(1)고, USER(1)에서 GET하다 났고, 가져오다 실패했다.

    public static final String FAIL_TEAMUSER = "12"; //에러(1)고 TEAMUSER(2)에서 났다.

    public static final String FAIL_TEAMUSER_ADD_PARAM = "1221"; // 파라메터 이상
    public static final String FAIL_TEAMUSER_ADD_ERROR = "1222"; //에러(1)고, TEAMUSER(2)에서 DEL(3)하다 났다.
    public static final String FAIL_TEAMUSER_DEL_PARAM = "1231"; // 파라메터 이상
    public static final String FAIL_TEAMUSER_DEL_ERROR = "1232"; //에러(1)고, TEAMUSER(2)에서 DEL(3)하다 났다.
}
