package com.twobrain.common.util;

import java.util.Properties;

import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeUtility;

public class Mail {

	public static void send(String to, String sTitle, String sMessage) {

		try {
			Properties p = new Properties();
			p.put("mail.smtp.user", "together@useinteractive.co.kr");
			p.put("mail.smtp.host", "smtp.useinteractive.com");
			p.put("mail.smtp.port", "465");
			p.put("mail.smtp.starttls.enable", "true");
			p.put("mail.smtp.auth", "true");
			p.put("mail.smtp.debug", "true");
			p.put("mail.smtp.socketFactory.port", "465");
			p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
			p.put("mail.smtp.socketFactory.fallback", "false");

			try {
				Authenticator auth = new SMTPAuthenticator("together@useinteractive.co.kr","xnrpej");
				Session session = Session.getInstance(p, auth);
				session.setDebug(false);

				MimeMessage msg = new MimeMessage(session);
				String message = sMessage;
				msg.setSubject(MimeUtility.encodeText(sTitle, "UTF-8", "B"));
				Address fromAddr = new InternetAddress("together@useinteractive.co.kr", "투게더");
				msg.setFrom(fromAddr);
				Address toAddr = new InternetAddress(to);
				msg.addRecipient(Message.RecipientType.TO, toAddr);
				msg.setContent(message, "text/html;charset=EUC-KR");
				Transport.send(msg);
			} catch (Exception e) {
				e.printStackTrace();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private static class SMTPAuthenticator extends javax.mail.Authenticator {
		private String sId = "";
		private String sPassword = "";
		
		public SMTPAuthenticator(String id, String password) {
			this.sId = id;
			this.sPassword = password;
		}
		
		public PasswordAuthentication getPasswordAuthentication() {
			return new PasswordAuthentication(this.sId, this.sPassword);
		}
	}
}
