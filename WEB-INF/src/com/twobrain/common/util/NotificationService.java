package com.twobrain.common.util;

import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeUtility;

import lombok.Getter;
import lombok.Setter;

import com.google.gson.Gson;
import com.twobrain.common.config.Config;
import com.twobrain.common.core.DataSet;
import com.twobrain.common.core.QueryHandler;
import com.twobrain.common.session.UserSession;

enum NotificationType {
	Task,
	Feedback,
	File,
	Observer
}

public class NotificationService {
	private UserSession userSession;
	
	public NotificationService(UserSession session) {
		userSession = session;
	}
	
	/**
	 * 태스크 할당 노티피케이션
	 * @param taskIdx : 태스크 IDX
	 */
	public void sendTaskNotification(int taskIdx) {
		Notification.createNotification(userSession, NotificationType.Task, taskIdx, taskIdx).notification();
	}
	
	/**
	 * 태스크 참조 노티피케이션
	 * @param taskIdx : 태스크 IDX
	 */
	public void sendObserverNotification(int taskIdx) {
		Notification.createNotification(userSession, NotificationType.Observer, taskIdx, taskIdx).notification();
	}
	
	/**
	 * 파일 업로드 노티피케이션
	 * @param taskIdx : 태스크 IDX
	 * @param files : 전체 파일 명
	 * @param notiFileIdx : 파일 IDX
	 * @param notiFileName : 파일 명
	 * @param notiFileCount : 파일 갯수
	 */
	public void sendFileNotification(int taskIdx, String files, int notiFileIdx, String notiFileName, int notiFileCount) {
		Notification.createFileNotification(userSession, taskIdx, notiFileIdx, notiFileCount, notiFileName).notification();
	}
	
	/**
	 * 피드백 노티피케이션
	 * @param taskIdx : 태스크 IDX
	 * @param toolIdx : 피드백 IDX
	 * @param message : 피드맥 메시지
	 */
	public void sendFeedbackNotification(int taskIdx, int toolIdx, String message) {
		Notification.createFeedbackNotification(userSession, taskIdx, toolIdx, message).notification();
	}
	
	/**
	 * 피드백 노티피케이션 테스트
	 * @param taskIdx : 태스크 IDX
	 * @param toolIdx : 피드백 IDX
	 * @param message : 피드맥 메시지
	 */
	public void sendFeedbackNotificationTest(int taskIdx, int toolIdx, String message) {
		Notification.createFeedbackNotification(userSession, taskIdx, toolIdx, message).akkaTest();
	}
	
	
}

/**
 * Notification Model
 */
class Notification {
	private static String META_FILE_NAME = "FILE_NAME";
	private static String META_FILE_COUNT = "FILE_COUNT";
	private static String META_FEEDBKAC_MESSAGE = "FEEDBACK_MESSAGE";
	
	// Notification Target User List
	@Setter @Getter public ArrayList<String> ntfcTargetUser;
	
	// Notification Mail Title
	@Setter @Getter public String mailTitle = "";
	
	// Notification Mail Body
	@Setter @Getter public String mailBody = "";
	
	// 태스크 명 
	@Setter @Getter public String taskName = "";
	
	// Link URL
	@Setter @Getter public String linkUrl = "";

	// 태스크 IDX
	@Setter @Getter public int taskIdx;
	
	// 태스크 오너 IDX
	@Setter @Getter public int taskOwnerIdx;
	
	// 노티피케이션 전송 사용자 IDX
	@Setter @Getter public int ntfcSenderIdx;
	
	// 노티피케이션이 발생된 테이블(도구) IDX
	@Setter @Getter public int ntfcTableIdx;
	
	// 노티피케이션 전송 사용자 명
	@Setter @Getter public String ntfcSenderName;
	
	// 노티피케이션이 발생된 테이블(도구) 명
	@Setter @Getter public String ntfcTableName;
	
	// 노티피케이션 메시지 ( TIMECLOUD_NOTIFICATION의 V_DESC와 맵핑 )
	@Setter @Getter public String ntfcMessage;
	
	// 도구별로 필요한 사용자 정의 파라미터 (메타정보)
	@Setter @Getter public Map<String,Object> ntfcMetaInfo;
	
	// 노티피케이션 타입
	@Setter @Getter public NotificationType ntfcType;
	
	// 사용자 세션 정보
	@Setter @Getter public transient UserSession userSession;
	
	/**
	 * Notification Factory 생성자
	 * @param userSession : 세션
	 * @param ntfcType : 노티피케이션 타입
	 * @param taskIdx : 태스크 IDX
	 * @param toolIdx : 도구 IDX
	 * @return Notification Model Object
	 */
	public static Notification createNotification(UserSession userSession, NotificationType ntfcType, int taskIdx, int toolIdx) {
		Notification ntfc = new Notification(userSession, ntfcType, taskIdx, toolIdx);
		return ntfc.build();
	}
	
	/**
	 * 파일 노티피케이션 Factory 생성자
	 * @param userSession : 세션
	 * @param taskIdx : 태스크 IDX
	 * @param toolIdx : 도구 IDX ( 파일 IDX )
	 * @param fileCount : 파일카운트
	 * @param fileName : 파일명
	 * @return : Notification Model Object
	 */
	public static Notification createFileNotification(UserSession userSession, int taskIdx, int toolIdx, int fileCount, String fileName) {
		Map<String, Object> metaInfo = new HashMap<String,Object>();
		metaInfo.put(META_FILE_NAME, fileName);
		metaInfo.put(META_FILE_COUNT, fileCount);
		
		Notification ntfc = createNotification(userSession, NotificationType.File, taskIdx, toolIdx);
		ntfc.setNtfcMetaInfo(metaInfo);

		return ntfc.build();
	}
	
	/**
	 * 피드백 노티피케이션 Factory 생성자
	 * @param userSession : 세션
	 * @param taskIdx : 태스크 IDX
	 * @param toolIdx : 도구 IDX ( 피드백 IDX )
	 * @param feedback : 피드맥 메시지
	 * @return : Notification Model Object
	 */
	public static Notification createFeedbackNotification(UserSession userSession, int taskIdx, int toolIdx, String feedback) {
		Map<String, Object> metaInfo = new HashMap<String,Object>();
		metaInfo.put(META_FEEDBKAC_MESSAGE, feedback);
		
		Notification ntfc = createNotification(userSession, NotificationType.Feedback, taskIdx, toolIdx);
		ntfc.setNtfcMetaInfo(metaInfo);
		
		return ntfc.build();
	}
	
	/**
	 * Notification 생성자
	 * @param userSession : 세션
	 * @param ntfcType : 노티피케이션 타입
	 * @param taskIdx : 태스크 IDX
	 * @param toolIdx : 도구 IDX
	 */
	private Notification(UserSession userSession, NotificationType ntfcType, int taskIdx, int toolIdx) {
		ntfcTargetUser = new ArrayList<String>();
		ntfcMetaInfo = new HashMap<String,Object>();
		
		setNtfcType(ntfcType);
		setTaskIdx(taskIdx);
		setUserSession(userSession);
		setNtfcSenderName(userSession.getUserName());
		setNtfcSenderIdx(userSession.getUserIdx());
		setNtfcTableIdx(toolIdx);
	}
	
	/**
	 * 노티피케이션 정보 생성
	 * @return
	 */
	public Notification build() {
		// 태스크 기본 정보 설정
		buildTaskInfo();
		
		// 툴별 메시지 및 노티피케이션 타겟 유저 저보 설정
		buildToolInfo();
		
		// 본인은 노티피케이션 대상에서 제외
		removeNtfcTarget(getUserSession().getUserIdx());
		
		return this;
	}
	
	/**
	 * 태스크 기본 정보 설정
	 */
	private void buildTaskInfo() {
		DataSet dsTaskInfo = QueryHandler.executeQuery("SELECT_TASK_INFO_FOR_YAMMER_NOTIFICATION", new Object[] { getTaskIdx() });
		
		if(dsTaskInfo != null && dsTaskInfo.next()) {
			String taskName = dsTaskInfo.getString(1);
			int parentIdx = Integer.parseInt(dsTaskInfo.getString(2).split("-")[0]);
			int ownerIdx = dsTaskInfo.getInt(3);
			
			setTaskName(taskName);
			
			addNtfcTarget(parentIdx);
			addNtfcTarget(ownerIdx);
			
			DataSet dsObserver = QueryHandler.executeQuery("SELECT_OBSERVER_LIST2", getTaskIdx()) ;
			if(dsObserver != null && dsObserver.size() > 0) {
				while(dsObserver.next()) {
					addNtfcTarget(dsObserver.getInt(1));
				}
			}
		}
	}
	
	/**
	 * TODO : 나중에 메시지들을 Globalization 할 수 있도록 패턴을 찾아야한다 ( 다국어 처리 또한.. )
	 * 		 setMailTitle(), setMailBody(), setNtfcMessage()
	 */
	private void buildToolInfo() {
		StringBuffer sbLinkUrl = new StringBuffer();
		sbLinkUrl.append(getUserSession().getHost());
		
		switch(getNtfcType()) {
			case Task :
				setNtfcTableName("TIMECLOUD_TASK");
				sbLinkUrl.append("/jsp/task.jsp?tsk_idx="+ getTaskIdx());
				
				setMailTitle(String.format("%s님이 태스크를 할당하였습니다.", getNtfcSenderName()));
				setMailBody(String.format("%s님이 태스크를 할당하였습니다.<br/><br/>태스크 : %s<br/><br/>내용보기 : %s",getNtfcSenderName(), getTaskName(), sbLinkUrl.toString()));
				setNtfcMessage(String.format("%s님이 태스크를 할당하였습니다.<br/>태스크 : %s",getNtfcSenderName(), getTaskName()));
				break;
				
			case File :
				setNtfcTableName("TIMECLOUD_FILE");
				sbLinkUrl.append("/jsp/file.jsp?tsk_idx="+ getTaskIdx());
				
				setMailTitle(String.format("%s님이 파일 업로드하였습니다.", getNtfcSenderName()));
				setMailBody(String.format("%s님이 파일 업로드하였습니다. <br/><br/>태스크 : %s<br/><br/> 파일 : %s<br/><br/>파일보기 : %s",getNtfcSenderName(), taskName, getNtfcMetaInfo().get(META_FILE_NAME), sbLinkUrl.toString()));
				setNtfcMessage(String.format("%s님이 파일 업로드하였습니다.<br/>태스크 : %s<br/><br/> 파일 : %s",getNtfcSenderName(), taskName, getNtfcMetaInfo().get(META_FILE_NAME)));
				
				DataSet dsFileUploader = QueryHandler.executeQuery("SELECT_FILE_UPLOADER", getTaskIdx());
				if(dsFileUploader != null && dsFileUploader.size() > 0) {
					while(dsFileUploader.next()) {
						addNtfcTarget(dsFileUploader.getInt(1));
					}
				}
				break;
				
			case Feedback :
				setNtfcTableName("TIMECLOUD_FEEDBACK");
				sbLinkUrl.append("/jsp/task.jsp?tsk_idx="+ getTaskIdx());
				
				setMailTitle(String.format("%s님이 태스크에 피드백을 남기기셨습니다.", getNtfcSenderName()));
				setMailBody(String.format("%s : %s<br/><br/>태스크 : %s<br/><br/>내용보기 : %s",getNtfcSenderName(), getNtfcMetaInfo().get(META_FEEDBKAC_MESSAGE), getTaskName(), sbLinkUrl.toString()));
				setNtfcMessage(String.format("%s : %s<br/>태스크 : %s",getNtfcSenderName(), getNtfcMetaInfo().get(META_FEEDBKAC_MESSAGE), getTaskName()));
				
				DataSet dsFeedbackTalker = QueryHandler.executeQuery("SELECT_FEEDBACK_TALKER", taskIdx);
				
				if(dsFeedbackTalker != null && dsFeedbackTalker.size() > 0) {
					while(dsFeedbackTalker.next()) {
						addNtfcTarget(dsFeedbackTalker.getInt(1));
					}
				}
				break;
				
			case Observer :
				setNtfcTableName("TIMECLOUD_TASK");
				sbLinkUrl.append("/jsp/task.jsp?tsk_idx="+ getTaskIdx());
				setMailTitle(String.format("%s님이 태스크를 참조하였습니다.", getNtfcSenderName()));
				setMailBody(String.format("%s님이 태스크를 참조하였습니다.<br/><br/>태스크 : %s<br/><br/>내용보기 : %s",getNtfcSenderName(), getTaskName(), sbLinkUrl.toString()));
				setNtfcMessage(String.format("%s님이 태스크를 참조하였습니다.<br/>태스크 : %s",getNtfcSenderName(), getTaskName()));
				break;
			
			default :
				break;
		}
		
		setLinkUrl(sbLinkUrl.toString());
	}
	
	/**
	 * 노티피케이션 타겟을 추가한다
	 * @param userIdx : 사용자 IDX
	 */
	private void addNtfcTarget(int userIdx) {
		String _idx = Integer.toString(userIdx);
		if(getNtfcTargetUser().contains(_idx) == false) {
			ntfcTargetUser.add(_idx);
		}
	}
	
	/**
	 * 노티피케이션 타겟을 제거한다
	 * @param userIdx
	 */
	private void removeNtfcTarget(int userIdx) {
		String _idx = Integer.toString(userIdx);
		if(getNtfcTargetUser().contains(_idx)) {
			ntfcTargetUser.remove(_idx);
		}
	}
	
	/**
	 * 실제 노티피케이션을 수행한다.
	 * 메일 전송 & DB 저장 & Akka Request( Active User WebSocket Push )
	 */
	public void notification() {
		sendEmail();
		save();
		requestAkkaNotification();
	}
	
	public void akkaTest() {
		requestAkkaNotification();
	}
	
	/**
	 * 메일로 노티피케이션을 전송한다
	 */
	private void sendEmail() {
		new Thread() {
			public void run() {
				for(String userIdx : getNtfcTargetUser()) {
					String email = getNotiEmailAddress(userIdx);
					
					if(email != null && "".equals(email) == false) {
						EmailAuthenticator authenticator = new EmailAuthenticator();
						 
						 Properties gmailProps = new Properties();
						 gmailProps.put("mail.smtp.starttls.enable", "true");
						 gmailProps.put("mail.smtp.host", "smtp.gmail.com");
						 gmailProps.put("mail.smtp.auth", "true");
						 gmailProps.put("mail.smtp.port", "587");
						
				        Session session = Session.getInstance(gmailProps, authenticator);
				         
				        try {
				            Message msg = new MimeMessage(session);
				            msg.setFrom(new InternetAddress("tt@2brain.com"));
				            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
				            msg.setSubject(MimeUtility.encodeText(getMailTitle(), "UTF-8", "B"));
				            msg.setContent(getMailBody(), "text/html; charset=UTF-8");
				            msg.setSentDate(new Date());
				            Transport.send(msg);
				        } catch (MessagingException e) {
				            e.printStackTrace();
				        } catch (UnsupportedEncodingException e) {
							e.printStackTrace();
						}
					}
				}
			}
		}.start();
	}
	
	/**
	 * 사용자 IDX를 이용해 메일을 전송할 EMAIL 주소를 가져온다
	 * @param userIdx : 사용자 IDX
	 * @return
	 */
	private String getNotiEmailAddress(String userIdx){
		return QueryHandler.executeQueryString("SELECT_USER_NOTI_EMAIL", new Object[] { userIdx });
	}
	
	/**
	 * 노티피케이션 테이블에 저장한다
	 */
	private void save() {
		new Thread() {
			public void run() {
				for(String userIdx : getNtfcTargetUser()) {
					Object[] params = new Object[]{getNtfcMessage(), getNtfcSenderIdx(), userIdx, getNtfcTableName(), getNtfcTableIdx(), getTaskIdx(), userSession.getDomainIdx()} ;
					QueryHandler.executeUpdate("TEST_INSERT_NOTIFICATION",params) ;
				}
			}
		}.start();
	}
	
	/**
	 * Akka Server에 WebSocket 데이터를 전송한다
	 */
	private void requestAkkaNotification() {
		if(getNtfcTargetUser() != null && getNtfcTargetUser().size() > 0) {
			
			try { 
				String json = new Gson().toJson(this);
				
				String server = Config.getProperty("init", "NOTIFICATION_SERVER_URL");
				
				HttpURLConnection httpcon = (HttpURLConnection) ((new URL("http://"+server+"/noti.req").openConnection()));
				httpcon.setDoOutput(true);
				httpcon.setDoInput(true);
				httpcon.setRequestProperty("Content-Type", "application/json");
				httpcon.setRequestProperty("Accept", "application/json");
				httpcon.setRequestMethod("POST");
				httpcon.connect();

				byte[] outputBytes = json.getBytes("UTF-8");
				OutputStream os = httpcon.getOutputStream();
				os.write(outputBytes);
				os.flush();
				os.close();
				
				httpcon.getInputStream().close();
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
			}
		}
	}
	
	/**
	 * Email 인증 클래스
	 */
	static class EmailAuthenticator extends Authenticator {
        private String id; 
        private String pw; 
 
        public EmailAuthenticator(){
            this.id = "tt@2brain.com";
            this.pw = "3951qlalfdldi";
        }
         
        public EmailAuthenticator(String id, String pw) {
            this.id = id;
            this.pw = pw;
        }
        protected PasswordAuthentication getPasswordAuthentication() {
            return new PasswordAuthentication(id, pw);
        }
 
    }
}

