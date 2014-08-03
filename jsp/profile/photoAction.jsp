<%@page import="com.sun.image.codec.jpeg.JPEGCodec" %>
<%@page import="com.twobrain.common.util.JpegReader" %>
<%@page import="org.apache.commons.fileupload.FileItem" %>
<%@page import="org.apache.commons.fileupload.FileUploadException" %>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@page import="javax.imageio.IIOException" %>
<%@page import="javax.imageio.ImageIO" %>
<%@ page import="javax.servlet.ServletException" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="java.awt.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/include/incInit.jspf" %>
<%@ include file="../common/include/incSession.jspf" %>

<%@ page import="java.awt.geom.AffineTransform" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="java.awt.image.RasterFormatException" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.IOException" %>
<%
    //GetOutputStream 에러를 방지하기 위함 (jspWriter error) -> 서블렛으로 이동시 필요 없음
    out.clear();
    pageContext.pushBody();
    MultiPartRequestHelper mReq = new MultiPartRequestHelper(request, response);
    FileHandler oFileHandler = new FileHandler(mReq, oUserSession);
    String sMethod = req.getMethod();
    String sAction = req.getParam("pAction", "");
    String msg = "";
    if ("GET".equals(sMethod)) {
        if ("DeleteFile".equals(sAction)) {
            oFileHandler.deleteProfileImage();
            msg = "삭제되었습니다.";
        }
    } else if ("POST".equals(sMethod)) {
        // multipart request 여부
        if (!ServletFileUpload.isMultipartContent(request)) {
            out.print(String.format("<script>alert('%s');location.back();</script>", Cs.FAIL_MSG_1));
            return;
        }
        // 좌표이상 여부
        if (mReq.getIntParam("cropX") < 0 || mReq.getIntParam("cropY") < 0) {
            out.print(String.format("<script>alert('%s');location.back();</script>", "좌표정보이상"));
            return;
        } // 규격이상 여부
        else if (mReq.getIntParam("cropW") <= 80 || mReq.getIntParam("cropH") <= 80) {
            out.print(String.format("<script>alert('%s');location.back();</script>", "최소규격 80x80"));
            return;
        }

        oFileHandler.uploadFile();
        msg = "저장되었습니다.";
    }
//    if(1==1)return;
    // GetOutputStream 에러를 방지하기 위함 (jspWriter error) -> 서블렛으로 이동시 필요 없음
    out.clear();
//    out = pageContext.pushBody();
    out.print(String.format("<script>alert('%s');location.replace('view.jsp')</script>", msg));
%>

<%!
    public class FileHandler {
        private final String FILE_UPLOAD_BASE_REPOSITORY = Config.getProperty("init", "FILE_UPLOAD_BASE_REPOSITORY");    //업로드 위치
        final private int USER_IDX;

        private int iThumbNailSize = 100;

        private String uploadPath = ""; // 원본 저장 경로
        private MultiPartRequestHelper oReqHelper = null;
        private UserSession oUserSession = null;

        public FileHandler(MultiPartRequestHelper req, UserSession session) {
            this.oUserSession = session;
            this.USER_IDX = oUserSession.getUserIdx();
            this.oReqHelper = req;
            this.uploadPath = FILE_UPLOAD_BASE_REPOSITORY + "/profile/";
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

        // 삭제
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

        private void makeNewThumbNail(File file, String fileName) throws IOException {
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

                // crop
                BufferedImage clip = makeClip(bsrc);

                BufferedImage sourceImg = (clip != null) ? clip : bsrc; // bsrc
                // gen thumbnails
                File thumb = new File(uploadPath + fileName);
                File thumb_gray = new File(uploadPath + fileName + "_g");

                if (sourceImg.getWidth() > sourceImg.getHeight()) {
                    height = (sourceImg.getHeight() * iThumbNailSize) / sourceImg.getWidth();
                    width = iThumbNailSize;
                } else {
                    width = (sourceImg.getWidth() * iThumbNailSize) / sourceImg.getHeight();
                    height = iThumbNailSize;
                }
                bdest = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
                Graphics2D g = bdest.createGraphics();
                AffineTransform at = AffineTransform.getScaleInstance((double) width / sourceImg.getWidth(), (double) height / sourceImg.getHeight());
                g.drawRenderedImage(sourceImg, at);
                ImageIO.write(bdest, "png", thumb);

                bgray = new BufferedImage(width, height, BufferedImage.TYPE_BYTE_GRAY);
                Graphics2D g2 = bgray.createGraphics();
                g2.drawRenderedImage(sourceImg, at);
                ImageIO.write(bgray, "png", thumb_gray);

            } catch (Exception e) {
                e.printStackTrace();
            } finally {
            }
        }

        // clip
        private BufferedImage makeClip(BufferedImage img) {
            BufferedImage clipped = null;
            int clipX = oReqHelper.getIntParam("cropX"); // x좌표
            int clipY = oReqHelper.getIntParam("cropY"); // y좌표
            int cropW = oReqHelper.getIntParam("cropW"); // 너비
            int cropH = oReqHelper.getIntParam("cropH"); // 높이
            Dimension size = new Dimension(cropW, cropH);

            // create clip
            Rectangle clip = null;
            boolean isClipAreaAdjusted = false;

/**Checking for negative X Co-ordinate**/
            if (clipX < 0) {
                clipX = 0;
                isClipAreaAdjusted = true;
            }
/**Checking for negative Y Co-ordinate**/
            if (clipY < 0) {
                clipY = 0;
                isClipAreaAdjusted = true;
            }

/**Checking if the clip area lies outside the rectangle**/
            if ((size.width + clipX) <= img.getWidth()
                    && (size.height + clipY) <= img.getHeight()) {

/**
 * Setting up a clip rectangle when clip area
 * lies within the image.
 */

                clip = new Rectangle(size);
                clip.x = clipX;
                clip.y = clipY;
            } else {

/**
 * Checking if the width of the clip area lies outside the image.
 * If so, making the image width boundary as the clip width.
 */
                if ((size.width + clipX) > img.getWidth())
                    size.width = img.getWidth() - clipX;

/**
 * Checking if the height of the clip area lies outside the image.
 * If so, making the image height boundary as the clip height.
 */
                if ((size.height + clipY) > img.getHeight())
                    size.height = img.getHeight() - clipY;

/**Setting up the clip are based on our clip area size adjustment**/
                clip = new Rectangle(size);
                clip.x = clipX;
                clip.y = clipY;

                isClipAreaAdjusted = true;

            }
            if (isClipAreaAdjusted)
                System.out.println("Crop Area Lied Outside The Image."
                        + " Adjusted The Clip Rectangle\n");
            //

            try {
                int w = clip.width;
                int h = clip.height;

                System.out.println("Crop Width " + w);
                System.out.println("Crop Height " + h);
                System.out.println("Crop Location " + "(" + clip.x + "," + clip.y
                        + ")");

                clipped = img.getSubimage(clip.x, clip.y, w, h);

                System.out.println("Image Cropped. New Image Dimension: "
                        + clipped.getWidth() + "w X " + clipped.getHeight() + "h");
            } catch (RasterFormatException rfe) {
                System.out.println("Raster format error: " + rfe.getMessage());
                return null;
            }

            return clipped;
        }

        // 업로드 구현
        private void uploadFile() throws ServletException, IOException {
            HttpServletRequest request = oReqHelper.getRequest();

            try {
//                DiskFileItemFactory oDiskItemFactory = new DiskFileItemFactory();

//                ServletFileUpload oUploadFileHandler = new ServletFileUpload(oDiskItemFactory);
                List<FileItem> items = oReqHelper.getFileItems(); //oUploadFileHandler.parseRequest(request);

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

                    // 원본파일 임시저장하는 부분
                    File file = new File(uploadPath + String.format("%d_ori.%s", USER_IDX, sExt)); // _ori 원본
                    item.write(file);
                    //
                    // 썸네일 생성하는 부분
                    makeNewThumbNail(file, userImageSaveName);
                    // 원본 삭제 (임시파일)
                    file.delete();
                }

            } catch (FileUploadException e) {
                throw new RuntimeException(e);
            } catch (Exception e) {
                throw new RuntimeException(e);
            } finally {
            }
        }

        // 확장자 구하기
        private String getExtention(String filename) {
            String suffix = "";
            int pos = filename.lastIndexOf('.');
            if (pos > 0 && pos < filename.length() - 1) {
                suffix = filename.substring(pos + 1);
            }
            return suffix.toLowerCase();
        }
    }
%>