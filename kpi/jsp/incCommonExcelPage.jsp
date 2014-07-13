<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.*" %>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="com.sds.cello.stat.api.IStatQueryHandler" %>
<%@ page import="com.sds.acube.ikm.util.SnaUtil" %>

<%@ include file="incCommon.jspf"%>

<!-- 
	2012.02.01
	Excel Button 공통 화면
 -->
 
 <%
 	//--엑셀Page URL
 	String excelUrl = "";
 	if(request.getParameter("excelUrl") != null) excelUrl = request.getParameter("excelUrl");
 %>
 
					<table border="0" cellpadding="0" cellspacing="0">
              			<tr>
                			<td class="cello_bu02_l"></td>
				 			<td class="cello_bu02"><img src="images/main/bullet_excel.gif"></td>
                			<td class="cello_bu02"><a href="javascript:getExcelUrl('<%=excelUrl%>');">Excel</a></td>
	               			<td class="cello_bu02_r"></td>
              			</tr>
            		</table>
