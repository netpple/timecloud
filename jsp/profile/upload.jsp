<%@page import="com.google.gson.Gson" %>
<%@page import="com.google.gson.JsonElement" %>
<%@page import="com.google.gson.JsonObject" %>
<%@page import="com.sun.image.codec.jpeg.JPEGCodec" %>
<%@page import="com.twobrain.common.object.JsonUserImage" %>
<%@page import="com.twobrain.common.util.JpegReader" %>
<%@page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.FileUploadException" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/include/incInit.jspf" %>
<%@ include file="../common/include/incSession.jspf" %>

<%@ page import="javax.imageio.IIOException" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="javax.servlet.ServletException" %>
<%@ page import="javax.servlet.ServletOutputStream" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="java.awt.*" %>
<%@ page import="java.awt.geom.AffineTransform" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.List" %>
<%
    //GetOutputStream 에러를 방지하기 위함 (jspWriter error) -> 서블렛으로 이동시 필요 없음
    out.clear();
    pageContext.pushBody();
//    out.println(oUserSession.getDomainIdx());
//    if(true)return;
    FileHandler oFileHandler = new FileHandler(req, oUserSession);

    String sMethod = req.getMethod();
    String sAction = req.getParam("pAction", "");

    if ("GET".equals(sMethod)) {
        if ("DownloadFile".equals(sAction)) {
            oFileHandler.downloadProfileImage();
        } else if ("GetProfileImage".equals(sAction)) {
            oFileHandler.getProfileImage();
        } else if ("DeleteFile".equals(sAction)) {
            oFileHandler.deleteProfileImage();
        }
    } else if ("POST".equals(sMethod)) {
        oFileHandler.uploadFile();
    }

    // GetOutputStream 에러를 방지하기 위함 (jspWriter error) -> 서블렛으로 이동시 필요 없음
    out.clear();
    out = pageContext.pushBody();
%>

<%!
    public class FileHandler {
        private final String FILE_UPLOAD_BASE_REPOSITORY = Config.getProperty("init", "FILE_UPLOAD_BASE_REPOSITORY");    //업로드 위치
        private final String USER_PROFILE_IMAGE_URN = Config.getProperty("init", "USER_PROFILE_IMAGE_URN"); //프로필이미지 URN - /repos/%s/profile/%s.%s
//        private final String USER_PROFILE_IMAGE_GRAY_URN = Config.getProperty("init", "USER_PROFILE_IMAGE_GRAY_URN"); //프로필이미지 URN - /repos/%s/profile/%s_g.%s


        final private String DOMAIN_IDX;
        final private int USER_IDX;

        private int iThumbSize = 75;
        private int iThumbNailSize = 60;

        private String uploadPath = ""; // 원본 저장 경로

        private String sActionJspName = "";
        private RequestHelper oReqHelper = null;
        private UserSession oUserSession = null;

        public FileHandler(RequestHelper req, UserSession session) {
            this.oUserSession = session;
            this.DOMAIN_IDX = oUserSession.getDomainIdx();
            this.USER_IDX = oUserSession.getUserIdx();
            this.oReqHelper = req;
            this.uploadPath = FILE_UPLOAD_BASE_REPOSITORY + DOMAIN_IDX + "/profile/";   // 프로필 원본 저장할 필요있나 ? 일단 하자.
            // TODO - MAKE A GRAY IMAGE

            sActionJspName = oReqHelper.getRequestObject().getContextPath() + "/jsp/profile/upload.jsp";
            checkUploadDirectory();
        }

        private void checkUploadDirectory() {
            File f = new File(uploadPath);
            if (f.exists() == false) {
                f.mkdirs();
            }
        }

        private boolean isImage(String sExtention) {
            boolean isImage = false;
            if (sExtention.equalsIgnoreCase("png")) {
                isImage = true;
            } else if (sExtention.equalsIgnoreCase("jpeg")) {
                isImage = true;
            } else if (sExtention.equalsIgnoreCase("jpg")) {
                isImage = true;
            } else if (sExtention.equalsIgnoreCase("gif")) {
                isImage = true;
            }

            return isImage;
        }

        private void downloadProfileImage() throws ServletException, IOException {
            HttpServletResponse response = oReqHelper.getResponseObject();
            try {
                File thumb = new File(String.format("%s%d", uploadPath, USER_IDX));
                File gray = new File(String.format("%s%d_g", uploadPath, USER_IDX));

                if (thumb.exists()) {
                    int bytes = 0;

                    ServletOutputStream oSevletOutputStream = response.getOutputStream();
                    response.setContentType("Content-type: application/octet-stream; charset=utf-8");
                    response.setContentLength((int) thumb.length());
                    response.setHeader("Content-Disposition", "attachment; filename=\"" + HTMLEntities.htmlentities(URLEncoder.encode(this.oUserSession.getUserName() + ".png", "UTF-8")) + "\"");

                    byte[] buffer = new byte[2048];
                    DataInputStream oDataInputStream = new DataInputStream(new FileInputStream(thumb));

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

        private void deleteProfileImage() {
            try {
                File thumb = new File(String.format("%s%d", uploadPath, USER_IDX));
                File gray = new File(String.format("%s%d_g", uploadPath, USER_IDX));
                if (thumb.exists())
                    thumb.delete();
                if (gray.exists())
                    gray.delete();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        private File getProfileFile(){
            File file = new File(String.format("%s%d",uploadPath,USER_IDX));
            return file;
        }

        private void getProfileImage()  throws ServletException, IOException {

            File file = getProfileFile();
            if(!file.exists())return;

            ArrayList<JsonUserImage> files = new ArrayList<JsonUserImage>();
            JsonUserImage userImage = new JsonUserImage();
            userImage.setOwnerIdx(USER_IDX);
            userImage.setName(String.format("%s.png", oUserSession.getUserName()));
            String sFileSize = Long.toString(file.length());
            userImage.setSize(sFileSize);
            userImage.setUrl(sActionJspName + "?pAction=DownloadFile");
            userImage.setDeleteUrl(sActionJspName + "?pAction=DeleteFile");
            files.add(userImage);

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

        private void makeNewThumbNail(File file, String fileName) throws ServletException, IOException {
            try {
                int width = 0, height = 0;

                BufferedImage bsrc = null;  // 원본
                BufferedImage bdest = null, bgray = null; // 썸네일

                File srcFile = file; //new File(uploadPath + fileName);

                try {
                    bsrc = ImageIO.read(srcFile); // 원본
                } catch (IIOException e1) {
                    //CMYK 이미지 읽을 시 IIOException 발생
                    //CMYK 이미지 읽기를 시도한다.
                    //일반적인 CMYK 이미지 이면 여기로 오게 될듯
                    bsrc = JpegReader.readImage(srcFile);
                } catch (IllegalArgumentException e2) {
                    // Numbers of source Raster bands and source color space components do not match 라는 메세지와 함께 발생
                    // 특정 CMYK 이미지 읽을 경우 발생 하는 것 같은데..
                    // 보통 CMYK 이미지를 JPEGCodec을 사용하여 읽어 오면 색이 전부 깨져서 읽힌다.
                    // 그러나  IllegalArgumentException 경우 일때는 JPEGCodec으로 하여도 색이 깨지지 않는듯...?
                    bsrc = JPEGCodec.createJPEGDecoder(new FileInputStream(srcFile)).decodeAsBufferedImage();
                } catch (Exception e3) {
                    //LogHandler.error(" __JM__ DEBUG :: Exception = " + e3.getMessage());
                    e3.printStackTrace(); // 이 외 예외가 더 발생할지 지켜 봐야할듯 _ // __131203__JM__
                }

                File thumb = new File(uploadPath + fileName);
                File thumb_gray = new File(uploadPath + fileName + "_g");

                if (bsrc.getWidth() > bsrc.getHeight()) {
                    height = (bsrc.getHeight() * iThumbNailSize) / bsrc.getWidth();
                    width = iThumbNailSize;
                } else {
                    width = (bsrc.getWidth() * iThumbNailSize) / bsrc.getHeight();
                    height = iThumbNailSize;
                }
                bdest = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
                Graphics2D g = bdest.createGraphics();
                AffineTransform at = AffineTransform.getScaleInstance((double) width / bsrc.getWidth(), (double) height / bsrc.getHeight());
                g.drawRenderedImage(bsrc, at);
                ImageIO.write(bdest, "png", thumb);

                bgray = new BufferedImage(width, height, BufferedImage.TYPE_BYTE_GRAY);
                Graphics2D g2 = bgray.createGraphics();
                g2.drawRenderedImage(bsrc, at);
                ImageIO.write(bgray, "png", thumb_gray);

            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                // TODO - 원본 프로필이미지 삭제
            }
        }

        private void uploadFile() throws ServletException, IOException {
            HttpServletResponse response = oReqHelper.getResponseObject();
            HttpServletRequest request = oReqHelper.getRequestObject();

            if (!ServletFileUpload.isMultipartContent(request))
                throw new IllegalArgumentException("Plz..'multipart/form-data' enctype for your form.");

            ArrayList<JsonUserImage> files = new ArrayList<JsonUserImage>();
            try {
                DiskFileItemFactory oDiskItemFactory = new DiskFileItemFactory();

                ServletFileUpload oUploadFileHandler = new ServletFileUpload(oDiskItemFactory);
                List<FileItem> items = oUploadFileHandler.parseRequest(request);

                FileUploadInfo oFileUploadInfo = new FileUploadInfo();

                for (FileItem item : items) {
                    if (item.isFormField())
                        oFileUploadInfo.addParam(item.getFieldName(), item.getString());
                }

                StringBuffer sb = new StringBuffer();

                for (FileItem item : items) {
                    if (item.isFormField()) continue;

                    File oFile = new File(item.getName());
                    String sOriginFileName = oFile.getName();
                    String sExt = getExtention(sOriginFileName);
                    if (!isImage(sExt)) { // 이미지 파일인지 체크
                        System.out.println("이미지 파일이 아님=>" + sExt);
                        continue;
                    }
                    String userImageSaveName = String.format("%d", USER_IDX);    //썸네일은 무조건 png로 생성됨
                    String sFileSize = Long.toString(item.getSize());

                    // 원본파일 임시저장하는 부분
                    File file = new File(uploadPath + String.format("%d_ori.%s", USER_IDX, sExt)); // _ori 원본
                    item.write(file);
                    //
                    // 썸네일 생성하는 부분
                    makeNewThumbNail(file, userImageSaveName);
                    // 원본 삭제 (임시파일)
                    file.delete();

                    JsonUserImage userImage = new JsonUserImage();

                    userImage.setOwnerIdx(USER_IDX);
                    userImage.setName(String.format("%s.png", oUserSession.getUserName()));
                    userImage.setSize(sFileSize);
                    userImage.setUrl(sActionJspName + "?pAction=DownloadFile");
                    userImage.setDeleteUrl(sActionJspName + "?pAction=DeleteFile");
                    files.add(userImage);

                    sb.append(sOriginFileName);

                }

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
    }

    class FileUploadInfo {
        private Hashtable<String, String> oFileUploadInfo;

        public FileUploadInfo() {
            oFileUploadInfo = new Hashtable<String, String>();
        }

        public String getParam(String key, String defaultValue) {
            String sValue = defaultValue;

            try {
                if (oFileUploadInfo.containsKey(key)) {
                    sValue = oFileUploadInfo.get(key);

                    if (sValue == null || sValue.equals(""))
                        sValue = defaultValue;
                }
            } catch (Exception e) {
            }

            return sValue;
        }

        public String getParam(String key) {
            return getParam(key, "");
        }

        public void addParam(String key, String value) {
            try {
                oFileUploadInfo.put(key, value);
            } catch (Exception e) {
            }
        }
    }
%>