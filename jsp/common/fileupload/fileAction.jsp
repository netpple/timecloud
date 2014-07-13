<%@page import="com.google.gson.Gson"%>
<%@page import="com.google.gson.JsonElement"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.sun.image.codec.jpeg.JPEGCodec"%>
<%@page import="com.twobrain.common.object.JsonFile"%>
<%@page import="com.twobrain.common.util.JpegReader"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="org.apache.commons.fileupload.FileUploadException"%>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/incInit.jspf" %>
<%@ include file="../include/incSession.jspf" %>

<%@ page import="org.imgscalr.Scalr"%>
<%@ page import="javax.imageio.IIOException" %>
<%@ page import="javax.imageio.ImageIO"%>
<%@ page import="javax.servlet.ServletException"%>
<%@ page import="javax.servlet.ServletOutputStream"%>
<%@ page import="javax.servlet.http.HttpServletRequest"%>
<%@ page import="javax.servlet.http.HttpServletResponse"%>
<%@ page import="javax.swing.*"%>
<%@ page import="java.awt.*"%>
<%@ page import="java.awt.geom.AffineTransform"%>
<%@ page import="java.awt.image.BufferedImage"%>
<%@ page import="java.io.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="java.util.List"%>
<%@ page import="com.twobrain.common.log.LogHandler" %>
<%

	//GetOutputStream 에러를 방지하기 위함 (jspWriter error) -> 서블렛으로 이동시 필요 없음
	out.clear();
	pageContext.pushBody();

	FileHandler oFileHandler = new FileHandler(DOMAIN_IDX, req, oUserSession);
	
	String sMethod = req.getMethod();
	String sAction = req.getParam("pAction","");

	if("GET".equals(sMethod)) {
		if("DownloadFile".equals(sAction)) {
			oFileHandler.downloadFile();
		} else if("GetThumbNail".equals(sAction)) {
			oFileHandler.getThumbNail();
		} else if("DeleteFile".equals(sAction)) {
			oFileHandler.deleteFile();
		} else if("GetFileList".equals(sAction)) {
			oFileHandler.getFileList();
		}
	} else if("POST".equals(sMethod)) {
		oFileHandler.uploadFile();
	}
	
	// GetOutputStream 에러를 방지하기 위함 (jspWriter error) -> 서블렛으로 이동시 필요 없음
	out.clear();
	out = pageContext.pushBody();
%>

<%!
	public class FileHandler {
        final private String DOMAIN_IDX ;

		private int iThumbSize = 75;
		private int iThumbNailSize = 160;
		private String sBaseUploadPath = "";
		private String sThumbnailUploadPath = "";
		private String sFileDefaultThumbnailPath = "";
		private String sActionJspName = "";
		private RequestHelper oReqHelper = null;
		private UserSession oUserSession = null;
		
		public FileHandler(final String DOMAIN_IDX, RequestHelper req, UserSession session) {
            this.DOMAIN_IDX = DOMAIN_IDX;
			this.oReqHelper = req;
			this.oUserSession = session;
			this.sBaseUploadPath = Config.getProperty("init", "FILE_UPLOAD_BASE_REPOSITORY") + oUserSession.getDomainIdx() + "/files/";
			this.sThumbnailUploadPath = Config.getProperty("init", "FILE_UPLOAD_BASE_REPOSITORY") + oUserSession.getDomainIdx() + "/thumbnail/";
			this.sFileDefaultThumbnailPath = String.format(Config.getProperty("init", "FILE_DEFAULT_THUMBNAIL_URN"),  oUserSession.getDomainIdx(), "file_icon.png") ;
			sActionJspName = oReqHelper.getRequestObject().getContextPath() + "/jsp/common/fileupload/fileAction.jsp";
			checkUploadDirectory();
		}
		
		private void checkUploadDirectory() {
			File f = new File(sBaseUploadPath);
			if(f.exists() == false) {
				f.mkdirs();
			}
		}
		
		private boolean isImage(String sExtention) {
			boolean isImage = false;
			if (sExtention.equals("png")) {
				isImage = true;
			} else if (sExtention.equals("jpeg")) {
				isImage = true;
			} else if (sExtention.equals("jpg")) {
				isImage = true;
			} else if (sExtention.equals("gif")) {
				isImage = true;
			}
			
			return isImage;
		}
		
		private void getFileList()  throws ServletException, IOException {
			String sTaskIdx = oReqHelper.getParam("tsk_idx","");
			// -- added by Sam Kim at 2013.11.20 for task view all mode
			int taskList = oReqHelper.getIntParam("tsk_list", -1) ;
			
			if("".equals(sTaskIdx) == false) {
				String qkey = null ;
				Object[] param = null ;
				if(taskList > 0) {
					qkey = "TEST_SELECT_TASK_FILE_ALL" ;
					param = new Object[]{taskList} ;
				}
				else {
					qkey = "SELECT_FILE_LIST" ;
					param = new Object[]{sTaskIdx} ;
				}
				
				DataSet oFileListDataSet = QueryHandler.executeQuery(qkey, param);
				
				ArrayList<JsonFile> files = new ArrayList<JsonFile>();
				
				if(oFileListDataSet != null && oFileListDataSet.size() > 0) {
					try {
						while(oFileListDataSet.next()) {
							int iIndex = oFileListDataSet.getInt(1);
							String sOriginFileName = oFileListDataSet.getString(2);
							String sSaveFileName = oFileListDataSet.getString(3);
							String sExtention = oFileListDataSet.getString(4);
							String sFileSize = oFileListDataSet.getString(5);
							int iOwnerIndex = oFileListDataSet.getInt(6);
							String sRegDateTime = DateTime.convertDateFormat(oFileListDataSet.getString(7));
							String sDelYn = oFileListDataSet.getString(8);
                            String sOwnerName = oFileListDataSet.getString(9);
                            String sTimeGap = oFileListDataSet.getString(12);   // 1분전, 2분전 등등
//                            System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"+sRegDateTime);
//                            System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"+sTimeGap);
						
							JsonFile jsonFile = new JsonFile();
							
							jsonFile.setTaskIdx(sTaskIdx);
							jsonFile.setOwnerIdx(oUserSession.getUserIdx());
							jsonFile.setOwnerName(oUserSession.getUserName());
							jsonFile.setName(sOriginFileName);
							jsonFile.setSize(sFileSize);
							jsonFile.setUrl(sActionJspName + "?pAction=DownloadFile&pFileIdx=" + iIndex);
							if(isImage(sExtention)) {
								jsonFile.setThumbnailUrl(sActionJspName + "?pAction=DownloadFile&pFileIdx=" + iIndex+"&pThumbnail=true");
								getThumbNailInfo(String.valueOf(iIndex), jsonFile);
							}else{
								jsonFile.setThumbnailUrl(sFileDefaultThumbnailPath);
							}
							//if(oUserSession.getUserIdx() == iOwnerIndex) {
								System.out.println(oUserSession.getUserIdx()+","+iOwnerIndex) ;
								jsonFile.setDeleteUrl(sActionJspName + "?pAction=DeleteFile&pFileIdx=" + iIndex);
							//}
							jsonFile.setDeleteType("GET");
							jsonFile.setDate(sRegDateTime);
							
							files.add(jsonFile);
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				
				HttpServletResponse response = oReqHelper.getResponseObject();
				Gson gson = new Gson();
				JsonElement element = gson.toJsonTree(files);
				JsonObject object = new JsonObject();
				object.add("files", element);
				
				response.setCharacterEncoding("UTF-8");
				response.setContentType("application/json");
				PrintWriter oPrintWriter = response.getWriter();
				oPrintWriter.write(object.toString());
				oPrintWriter.close();

			}
		}
		
		private void downloadFile() throws ServletException, IOException {
			try {
				TimeCloudFile oTimeCloudFile = getFileInfo(oReqHelper.getIntParam("pFileIdx",-1));
				Boolean isImage = Boolean.valueOf(oReqHelper.getParam("pThumbnail", "false"));
				String sPathString = "";
				
				if(oTimeCloudFile.isValidFile() == false)
					return;
					
				File file = null;	
				HttpServletResponse response = oReqHelper.getResponseObject();
				
				if(isImage){ sPathString = sThumbnailUploadPath; }
				else{ sPathString = sBaseUploadPath; }

				file = new File(sPathString + oTimeCloudFile.getSaveFileName());
				
		        if (file.exists()) {
		            int bytes = 0;
		            
		            QueryHandler.executeUpdate("UPDATE_FILE_COUNT", oTimeCloudFile.getIndex());
		            
		            ServletOutputStream oSevletOutputStream = response.getOutputStream();
		            response.setContentType("Content-type: application/octet-stream; charset=utf-8");
		            response.setContentLength((int) file.length());
		            response.setHeader( "Content-Disposition", "attachment; filename=\"" + HTMLEntities.htmlentities(URLEncoder.encode(oTimeCloudFile.getOriginFileName(),"UTF-8")) + "\"" );
		
		            byte[] buffer = new byte[2048];
		            DataInputStream oDataInputStream = new DataInputStream(new FileInputStream(file));
		
		            while ((oDataInputStream != null) && ((bytes = oDataInputStream.read(buffer)) != -1)) {
		            	oSevletOutputStream.write(buffer, 0, bytes);
		            }
		            
		            oDataInputStream.close();
		            oSevletOutputStream.flush();
		            oSevletOutputStream.close();
		        }
			} catch (Exception e) {
				
			}
		}
		
		private void deleteFile() {
			try {
				TimeCloudFile oTimeCloudFile = getFileInfo(oReqHelper.getIntParam("pFileIdx",-1));
	
				if(oTimeCloudFile.isValidFile() == false)
					return;
				
				int iResult = QueryHandler.executeUpdate("DELETE_FILE", oTimeCloudFile.getIndex());
				
				if(iResult > 0) {
					File file = new File(sBaseUploadPath + oTimeCloudFile.getSaveFileName());
					if (file.exists()) {
						//file.delete();
					}
				}
			} catch(Exception e) {}
		}
		
		private void getThumbNail() throws ServletException, IOException {
			try {
				TimeCloudFile oTimeCloudFile = getFileInfo(oReqHelper.getIntParam("pFileIdx",-1));
	
				if(oTimeCloudFile.isValidFile() == false)
					return;
				
				File file = new File(sBaseUploadPath + oTimeCloudFile.getSaveFileName());
				
				if (file.exists()) {
					
					HttpServletResponse response = oReqHelper.getResponseObject();
					
					String sExtention = oTimeCloudFile.getExtention();
					
					if (sExtention.equals("png") || sExtention.equals("jpeg")|| sExtention.equals("jpg") || sExtention.equals("gif")) {
						BufferedImage im = ImageIO.read(file);
						
						if (im != null) {
							BufferedImage thumb = Scalr.resize(im, iThumbSize);
							ByteArrayOutputStream os = new ByteArrayOutputStream();
							
							if (sExtention.equals("png")) {
								ImageIO.write(thumb, "PNG" , os);
								response.setContentType("image/png");
							} else if (sExtention.equals("jpeg")) {
								ImageIO.write(thumb, "jpg" , os);
								response.setContentType("image/jpeg");
							} else if (sExtention.equals("jpg")) {
								ImageIO.write(thumb, "jpg" , os);
								response.setContentType("image/jpeg");
							} else if (sExtention.equals("gif")) {
								ImageIO.write(thumb, "gif" , os);
								response.setContentType("image/gif");
							}
							
		                    ServletOutputStream srvos = response.getOutputStream();
		                    response.setContentLength(os.size());
		                    response.setHeader( "Content-Disposition", "inline; filename=\"" + HTMLEntities.htmlentities(URLEncoder.encode(oTimeCloudFile.getOriginFileName(),"UTF-8")) + "\"" );
		                    os.writeTo(srvos);
		                    srvos.flush();
		                    srvos.close();
			            }
					}
				}
			} catch(Exception e) {
				
			}
		}
		private void getThumbNailInfo(String fileName, JsonFile jsonFile) throws ServletException, IOException{
			try {
				if(!new File(sThumbnailUploadPath + fileName).exists()){
					makeNewThumbNail(fileName);	
				}
				Image img = new ImageIcon(sThumbnailUploadPath + fileName).getImage();
				jsonFile.setThumbnailWidth(img.getWidth(null));
				jsonFile.setThumbnailHeight(img.getHeight(null));
			} catch(Exception e) {
			}
		}
		
		private void makeNewThumbNail(String fileName) throws ServletException, IOException {
			try {
				int width=0;
				int height=0;
				
	          	BufferedImage bsrc = null;
	          	BufferedImage bdest = null;
				File srcFile = new File(sBaseUploadPath + fileName);
				
				try{
					bsrc = ImageIO.read(new File(sBaseUploadPath + fileName));
				}catch(IIOException e1){
					//CMYK 이미지 읽을 시 IIOException 발생
					//CMYK 이미지 읽기를 시도한다.
					//일반적인 CMYK 이미지 이면 여기로 오게 될듯
					bsrc = JpegReader.readImage(srcFile);
				}catch(IllegalArgumentException e2){
					// Numbers of source Raster bands and source color space components do not match 라는 메세지와 함께 발생
					// 특정 CMYK 이미지 읽을 경우 발생 하는 것 같은데..
					// 보통 CMYK 이미지를 JPEGCodec을 사용하여 읽어 오면 색이 전부 깨져서 읽힌다.
					// 그러나  IllegalArgumentException 경우 일때는 JPEGCodec으로 하여도 색이 깨지지 않는듯...?
					bsrc = JPEGCodec.createJPEGDecoder(new FileInputStream(srcFile)).decodeAsBufferedImage();
				}catch(Exception e3){
					//LogHandler.error(" __JM__ DEBUG :: Exception = " + e3.getMessage());
					e3.printStackTrace(); // 이 외 예외가 더 발생할지 지켜 봐야할듯 _ // __131203__JM__
				}
	          	
	          	if(bsrc.getWidth() > iThumbNailSize || bsrc.getHeight() > iThumbNailSize){
		          	if(bsrc.getWidth()>bsrc.getHeight()){
						height = (bsrc.getHeight()*iThumbNailSize)/bsrc.getWidth();
						width = iThumbNailSize;
				  	}else {
				  		width = (bsrc.getWidth()*iThumbNailSize)/bsrc.getHeight();
						height = iThumbNailSize;
				  	}
		            bdest = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
		            Graphics2D g = bdest.createGraphics();
		            AffineTransform at = AffineTransform.getScaleInstance((double) width / bsrc.getWidth(),(double) height / bsrc.getHeight());
		            g.drawRenderedImage(bsrc, at);	

			        ImageIO.write(bdest, "png", new File(sThumbnailUploadPath + fileName));
				}else{
			        ImageIO.write(bsrc, "png", new File(sThumbnailUploadPath + fileName));
				}
	
	            
	            
			} catch(Exception e) {
			}
		}
		
		private void uploadFile() throws ServletException, IOException {
			HttpServletResponse response = oReqHelper.getResponseObject();
			HttpServletRequest request = oReqHelper.getRequestObject();

			if (!ServletFileUpload.isMultipartContent(request)) {
				throw new IllegalArgumentException("Request is not multipart, please 'multipart/form-data' enctype for your form.");
			}

			
			ArrayList<JsonFile> files = new ArrayList<JsonFile>();

			try {
				DiskFileItemFactory oDiskItemFactory = new DiskFileItemFactory();
				
				ServletFileUpload oUploadFileHandler = new ServletFileUpload(oDiskItemFactory);
				List<FileItem> items = oUploadFileHandler.parseRequest(request);
	           
				FileUploadInfo oFileUploadInfo = new FileUploadInfo();

				for (FileItem item : items) {
					if (item.isFormField()) {
						oFileUploadInfo.addParam(item.getFieldName(), item.getString());
					}
				}

				String sUserIdx = Integer.toString(oUserSession.getUserIdx());
				String sTaskIdx = oFileUploadInfo.getParam("tsk_idx");
				
				StringBuffer sb = new StringBuffer();
				
				int notiFileIdx = -1, notiFileCount = 0 ;	// -- notification 때 대표로 한개 파일만 넘기기 위함
				String notiFileName = null ; 
				for (FileItem item : items) {
					if (!item.isFormField()) {
						File oFile = new File(item.getName());
						
						int idx = QueryHandler.executeQueryInt("SELECT_FILE_SEQUENCE");
						if(idx <=0 ) {
							// -- fail to get a new sequence
							continue ;
						}
						
						String sIdx = "" + idx ; 
						String sSaveFileName = sIdx;
						String sOriginFileName = oFile.getName();
						String sExt = getExtention(sOriginFileName);
						String sFileSize = Long.toString(item.getSize());
						String sRegDateTime = DateTime.getCurrentDateTime();
						
						if(notiFileIdx <= 0) {
							notiFileIdx = idx ;
							notiFileName = sOriginFileName ;
						}
						notiFileCount ++ ;
						
						String[] asFileParam = new String[] { sIdx, sTaskIdx, sOriginFileName, sSaveFileName, sExt, sFileSize, sUserIdx, DOMAIN_IDX  };
						
						Vector<Object> vFileInsertTransaction = new Vector<Object>();
						vFileInsertTransaction.add("INSERT_FILE");
						vFileInsertTransaction.add(asFileParam);
						/*
						vFileInsertTransaction.add("INSERT_ACTIVITY");
						vFileInsertTransaction.add(asActivityParam);
						*/
						String sTransactionResult = QueryHandler.executeTransaction(vFileInsertTransaction);
								
						if(sTransactionResult.equals(Cs.COMMIT)) {
							File file = new File(sBaseUploadPath + sSaveFileName);
							item.write(file);
							
							JsonFile jsonFile = new JsonFile();
							
							jsonFile.setTaskIdx(sTaskIdx);
							jsonFile.setOwnerIdx(oUserSession.getUserIdx());
							jsonFile.setOwnerName(oUserSession.getUserName());
		 					jsonFile.setName(sOriginFileName);
							jsonFile.setSize(sFileSize);
							jsonFile.setUrl(sActionJspName + "?pAction=DownloadFile&pFileIdx=" + sIdx);
							if(isImage(sExt)) {
								jsonFile.setThumbnailUrl(sActionJspName + "?pAction=DownloadFile&pFileIdx=" + sIdx+"&pThumbnail=true");
								getThumbNailInfo(sSaveFileName, jsonFile);
							}else{
								jsonFile.setThumbnailUrl(sFileDefaultThumbnailPath);
							}
							
							jsonFile.setDeleteUrl(sActionJspName + "?pAction=DeleteFile&pFileIdx=" + sIdx);
							jsonFile.setDeleteType("GET");
							jsonFile.setDate(DateTime.convertDateFormat(sRegDateTime));
							files.add(jsonFile);
							
							sb.append(sOriginFileName);
						}
	               }
	           }
				
				NotificationService ntfcService = new NotificationService(oUserSession);
				ntfcService.sendFileNotification(Integer.parseInt(sTaskIdx), sb.toString(), notiFileIdx, notiFileName, notiFileCount);
				
	       } catch (FileUploadException e) {
	               throw new RuntimeException(e);
	       } catch (Exception e) {
	               throw new RuntimeException(e);
	       } finally {
				Gson gson = new Gson();
				
				JsonElement element = gson.toJsonTree(files);
				JsonObject object = new JsonObject();
				object.add("files", element);
				
				response.setCharacterEncoding("UTF-8");
				response.setContentType("application/json");
				PrintWriter oPrintWriter = response.getWriter();
				oPrintWriter.write(object.toString());
				oPrintWriter.close();
	       }
		}
	
		private String getExtention(String filename) {
			String suffix = "";
			int pos = filename.lastIndexOf('.');
			if (pos > 0 && pos < filename.length() - 1) {
				suffix = filename.substring(pos + 1);
			}
			return suffix.toLowerCase();
		}
	   
		private TimeCloudFile getFileInfo(int fileIndex) {
			if(fileIndex > 0) {
				return new TimeCloudFile(QueryHandler.executeQuery("SELECT_FILE_INFO", fileIndex));
			} else {
				return null;
			}
		}
	}
   
	class FileUploadInfo {
	   private Hashtable<String,String> oFileUploadInfo;
	   
	   public FileUploadInfo() {
		   oFileUploadInfo = new Hashtable<String,String>();
	   }
	   
	   public String getParam(String key, String defaultValue) {
		   String sValue = defaultValue;
		   
		   try {
				if(oFileUploadInfo.containsKey(key)) {
					sValue = oFileUploadInfo.get(key);
					
					if(sValue == null || sValue.equals(""))
						sValue = defaultValue;
				}
		   } catch(Exception e) {
		   }
		   
		   return sValue;
	   }
	   
	   public String getParam(String key) {
		   return getParam(key,"");
	   }
	   
	   public void addParam(String key, String value) {
		   try {
			   oFileUploadInfo.put(key,value);
		   } catch (Exception e) {}
	   }
   }
	
	class TimeCloudFile {
		private String sSaveFileName = "";
		private String sOriginFileName = "";
		private String sExtention = "";
		private String sRegDateTime = "";
		private String sDelYn = "";
		private int iTaskIdx = -1;
		private int iIndex = -1;
		private int iOwnerIndex = 0;
		private int iFileSize = -1;
		private boolean isValidFile = false;
	
		public TimeCloudFile(DataSet ds) {
			if(ds != null && ds.next()) {
				iIndex = ds.getInt("N_IDX");
				iTaskIdx = ds.getInt("N_TASK_IDX");
				sOriginFileName = ds.getString("V_ORIGIN_NAME");
				sSaveFileName = ds.getString("V_SAVE_NAME");
				sExtention = ds.getString("V_EXT");
				iOwnerIndex = ds.getInt("N_OWNER_IDX");
				sRegDateTime = ds.getString("V_REG_DATETIME");
				sDelYn = ds.getString("C_DEL_YN");
				iFileSize = ds.getInt("N_FILE_SIZE");
				
				isValidFile = true;
			}
		}
		
		public int getIndex() {
			return iIndex;
		}
		
		public void setIndex(int index) {
			iIndex = index;
		}
		
		public int getOwnerIndex() {
			return iOwnerIndex;
		}
		
		public void setOwnerIndex(int ownerIndex) {
			iOwnerIndex = ownerIndex;
		}
		
		
		public int getTaskIdx() {
			return iTaskIdx;
		}
		
		public void setTaskIdx(int taskIdx) {
			iTaskIdx = taskIdx;
		}
		
		public boolean isDeleted() {
			return sDelYn.equals("Y") == true ? true : false;
		}
		
		public void setDelYn(String delYn) {
			sDelYn = delYn;
		}
		
		public boolean isValidFile() {
			return isValidFile;
		}
		
		public void setIsValidFile(boolean _isValidFile) {
			isValidFile = _isValidFile;
					
		}
		
		public String getRegDateTime() {
			return sRegDateTime;
		}
		
		public void setRegDateTime(String regDateTime) {
			sRegDateTime = regDateTime;
		}
		
		public String getExtention() {
			return sExtention;
		}
		
		public void setExtention(String extention) {
			sExtention = extention;
		}
		
		public String getOriginFileName() {
			return sOriginFileName;
		}
		
		public void setOriginFileName(String originFileName) {
			sOriginFileName = originFileName;
		}
		
		public String getSaveFileName() {
			return sSaveFileName;
		}
		
		public void setSaveFileName(String saveFileName) {
			sSaveFileName = saveFileName;
		}
		
		public int getFileSize() {
			return iFileSize;
		}
		
		public void setFileSize(int fileSize) {
			iFileSize = fileSize;
		}
	}
%>