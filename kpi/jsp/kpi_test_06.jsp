<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ include file="incCommon.jspf"%><%@ page import="java.util.*, java.text.DateFormat, java.text.SimpleDateFormat" %><%@ include file="incCommonUtil.jspf"%><%
	final String nowUrl = request.getRequestURI() ;
	String thisFilename = nowUrl.substring(nowUrl.lastIndexOf("/")+1) ;
	String thisFilenameNoExt = thisFilename.substring(0,thisFilename.lastIndexOf(".")) ;
	
	String[] mock = new String[]{"보상/손사","손사","1"
			,"1","0","0","0","0","0"
			,"0","0","0","0","0","0","0","0"
			,"0","0","0"
			} ;
	
	String[] mock1 = new String[]{"포상/휴가","휴가","2"
			,"3","0","1","0","0","0"
			,"0","0","1","0","0","0","0","0"
			,"0","2","0"
			} ;	
	
	Object[] ds = new Object[]{ mock, mock1 } ;
	
	// -- ds = null ;
%><input type='hidden' id='info_report' value='결함 조치현황[1차]<%=__INFO_DELIM__ + thisFilename %>' />				
<div width="100%" style='padding:0;margin:0'>
	<table class='table_data'>
		<tr>
			<th class='th' rowspan=2>서브시스템명</th>
			<th class='th' rowspan=2>업무명</th>
			<th class='th' rowspan=2>결함건수</th>
			<th class='th' colspan=6>결함심각도</th>
			<th class='th' colspan=8>진행상태</th>
			<th class='th' colspan=3>진행실적</th>
		</tr>
		<tr>
			<th class='th'>요구사항</td>
			<th class='th'>LEVEL E</td>
			<th class='th'>LEVEL D</td>
			<th class='th'>LEVEL C</td>
			<th class='th'>LEVEL B</td>
			<th class='th'>LEVEL A</td>
			<th class='th'>등록</td>
			<th class='th'>검토중</td>
			<th class='th'>기각</td>
			<th class='th'>구현중</td>
			<th class='th'>재조치중</td>
			<th class='th'>AL확인중</td>
			<th class='th'>등록자확인중</td>
			<th class='th'>완료</td>
			<th class='th'>계획</td>
			<th class='th'>실행</td>
			<th class='th'>달성율</td>
		</tr>
<%
	if(ds == null) {	// -- 데이터가 없을 경우, 여기서 끝
		out.println( "</table>"+ getNoData("조회된 내용이 없습니다.") +"</div>"  );	
		return ;		
	}

	double tmpD = -1.00f ;
	double[] totalD = {0,0,0
					  ,0,0,0,0,0,0
					  ,0,0,0,0,0,0,0,0
					  ,0,0,0} ;
	
	String align = "right" ; // -- 필드 정렬
	String[] row = null ;
	for (int j=0;j<ds.length;j++) {
		row = (String[])ds[j] ;
%>
		<tr>
<%
		for (int i=0;i<row.length;i++) {
			if( isNumber(row[i]) ) {
				tmpD = parseDouble(row[i]) ;
				totalD[i] += tmpD ;
				
				align="right" ;
			}
			else align="left" ;
%>		
 			<td class='td <%=align%>'><%=row[i] %></td>
<%
		}
%>
		</tr>
<%
	}
%>
		<tr>
<%
	String summary = "" ;
	for(int i=0;i<totalD.length;i++) {
		if(i==0) {
			summary = "합계" ;
			align= "" ;
		}
		else if(i==1) {
			summary = "" ;
		}
		else {
			summary = numberFormat( totalD[i] ) ;
			align="right" ;
		}		
%>		
			<th class='th <%=align%>'><%=summary %></td>
<%
	}
%>
		</tr>		
	</table>
</div>