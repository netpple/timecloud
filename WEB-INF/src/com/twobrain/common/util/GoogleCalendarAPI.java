package com.twobrain.common.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import org.json.JSONException;
import org.json.JSONObject;

import com.twobrain.common.session.UserSession;

public class GoogleCalendarAPI {
	
	private final static String LISTS_CALENDAR_API_URL = "https://www.googleapis.com/calendar/v3/lists/{calendarListID}/calendar?{parameters}";
	private final static String USERS_CALENDAR_API_URL = "https://www.googleapis.com/calendar/v3/users/{userID}/lists?{parameters}";
	private final static String BASIC_CALENDAR_API_URL = "https://www.googleapis.com/calendar/v3/calendars";
	private final static String EVENT_CALENDAR_API_URL = "https://www.googleapis.com/calendar/v3/calendars/{calendarId}/events";
	private final static String GOOGLE_AUTH_URL = "https://accounts.google.com/o/oauth2/auth";
	private final static String GOOGLE_TOKEN_URL = "https://accounts.google.com/o/oauth2/token";
	private final static String CLIENT_ID = "134449519148-jft4ej2djqr2ndvglobjc0vol0al90rq.apps.googleusercontent.com";
	private final static String CLIENT_SECRET = "0bh_m7wOMMzMBpbXzfIH1xJR";
	private final static String SCOPE_VALUES = "https://www.googleapis.com/auth/userinfo.profile+https://www.googleapis.com/auth/userinfo.email+https://www.googleapis.com/auth/calendar";
	
	public enum Response_Type {AUTH_CODE, ACCESS_TOKEN,CODE_VALUE};
	
	private UserSession userSession;
	private String sCalendarID = "";
	private String sGCToken = "";
	private static String REDIRECT_URI = "";
	
	public GoogleCalendarAPI(UserSession session){
		userSession = session;
	}
	/*
	public GoogleCalendarAPI(){
	
	}*/
	
	public String getAuthUrl(String sState, String sRedirect_url, Response_Type rType){
		String sURL = GOOGLE_AUTH_URL+"";
		REDIRECT_URI = sRedirect_url;
		
		if(rType == Response_Type.ACCESS_TOKEN){
			sURL += "?response_type=token";
		}else{
			sURL += "?response_type=code";
		}
		
	
		sURL += "&scope="+SCOPE_VALUES;
		
		sURL += "&redirect_uri="+REDIRECT_URI;
		
		if(!sState.equals("")){
			sURL += "&state="+sState;
		}
		
		sURL += "&client_id="+CLIENT_ID;
		
		return sURL;
	}
	
	public String getToken(String sCode){
		String  sParams = "";
		sParams += "code="+sCode;
		sParams += "&client_id="+CLIENT_ID;
		sParams += "&client_secret="+CLIENT_SECRET;
		sParams += "&redirect_uri="+REDIRECT_URI;
		sParams += "&grant_type=authorization_code";
		URL oURL;
		try {
			oURL = new URL(GOOGLE_TOKEN_URL);
			HttpURLConnection urlConnection = (HttpURLConnection)oURL.openConnection();
			urlConnection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			urlConnection.setRequestMethod("POST");
			
			urlConnection.setDoInput(true);
			urlConnection.setDoOutput(true);
			
			OutputStream out_stream = urlConnection.getOutputStream();
			
			out_stream.write(sParams.getBytes());
			out_stream.flush();
			out_stream.close();
			
			BufferedReader rd = new BufferedReader(new InputStreamReader(urlConnection.getInputStream(), "UTF-8"));
			String sReadLine = "";
			String sReadData = "";
			while((sReadLine = rd.readLine()) != null){
				sReadData += sReadLine+"\n";
			}
			rd.close();

			JSONObject oJsonObject = new JSONObject(sReadData);
			String sToken = oJsonObject.getString("access_token");
			System.out.println("Token : "+sToken);
			return sToken;
		} catch (Exception e) {
			System.out.println("[Error :: getToken] "+e);
		}
		
		return "";
	}

	public String insertCalendars(String sToken, String sSummary){
		JSONObject jParams = new JSONObject();
		try {
			jParams.append("summary", sSummary);
			String sParams = jParams.toString();
			
			URL oURL = new URL(BASIC_CALENDAR_API_URL+"?access_token="+sToken);
			HttpURLConnection urlConnection = (HttpURLConnection)oURL.openConnection();
			urlConnection.setRequestProperty("Content-Type", "application/json");
			urlConnection.setRequestMethod("POST");
			
			urlConnection.setDoInput(true);
			urlConnection.setDoOutput(true);
			
			OutputStream out_stream = urlConnection.getOutputStream();
			
			out_stream.write(sParams.getBytes());
			out_stream.flush();
			out_stream.close();
			
			BufferedReader rd = new BufferedReader(new InputStreamReader(urlConnection.getInputStream(), "UTF-8"));
			String sReadLine = "";
			String sReadData = "";
			while((sReadLine = rd.readLine()) != null){
				sReadData += sReadLine+"\n";
			}
			rd.close();

			JSONObject oJsonObject = new JSONObject(sReadData);
			String sID = oJsonObject.getString("id");
			System.out.println("ID : "+sID);
			return sID;
		} catch (Exception e) {
			System.out.println("[Error :: insertCalendars] "+e);
		}
		return "";
	}
	
	private void insertEvent(String sToken, String sCalendarID, String sSummary, String sStartTime, String sEndTime){
		JSONObject jParams = new JSONObject();
		try {
			jParams.append("summary", sSummary);
			
			JSONObject jStartTime = new JSONObject();
			jStartTime.append("date",sStartTime);
			
			JSONObject jEndTime = new JSONObject();
			jEndTime.append("date",sEndTime);
			
			jParams.append("start", jStartTime);
			jParams.append("end", jEndTime);
			
			String sParams = jParams.toString();
			System.out.println("sParams : "+sParams);
			String sURL =  EVENT_CALENDAR_API_URL+"?access_token="+sToken;
			sURL = sURL.replace("{calendarId}", sCalendarID);
			
			URL oURL = new URL(sURL);
			HttpURLConnection urlConnection = (HttpURLConnection)oURL.openConnection();
			urlConnection.setRequestProperty("Content-Type", "application/json");
			urlConnection.setRequestMethod("POST");
			
			urlConnection.setDoInput(true);
			urlConnection.setDoOutput(true);
			
			OutputStream out_stream = urlConnection.getOutputStream();
			
			out_stream.write(sParams.getBytes("UTF-8"));
			out_stream.flush();
			out_stream.close();
			
			BufferedReader rd = new BufferedReader(new InputStreamReader(urlConnection.getInputStream(), "UTF-8"));
			String sReadLine = "";
			String sReadData = "";
			while((sReadLine = rd.readLine()) != null){
				sReadData += sReadLine+"\n";
			}
			rd.close();

			JSONObject oJsonObject = new JSONObject(sReadData);
			String sID = oJsonObject.getString("id");
			System.out.println("ID : "+sID);
		} catch (Exception e) {
			System.out.println("[Error :: insertCalendars] "+e);
		}
	}

	
	public void insertEvent(String sSummary, String sStartTime, String sEndTime){
		insertEvent(sGCToken, sCalendarID, sSummary, sStartTime, sEndTime);
	}
	
	public void insertEvent(String sSummary, String sDate){
		insertEvent(sSummary, sDate, sDate);
	}
}
