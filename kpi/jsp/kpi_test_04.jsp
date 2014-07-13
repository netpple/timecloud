<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ include file="incCommon.jspf"%><%@ page import="java.util.*, java.text.DateFormat, java.text.SimpleDateFormat" %><%@ include file="incCommonUtil.jspf"%><%
	final String nowUrl = request.getRequestURI() ;
	String thisFilename = nowUrl.substring(nowUrl.lastIndexOf("/")+1) ;
	String thisFilenameNoExt = thisFilename.substring(0,thisFilename.lastIndexOf(".")) ;
	
	// -- TODO - get dataset
	String[] mock = new String[]{"보상/손사","손사","1","1"
			,"1","0"
			,"0","0","0","0"
			,"0","0","0"
			,"0","0"
			,"0.00","0.00","0.00"
			,"0.00","0.00","0.00"
			} ;
	
	Object[] ds = new Object[]{ mock } ;
	
	// -- ds = null ;
%><input type='hidden' id='info_report' value='통합테스트 진척현황[1차]<%=__INFO_DELIM__ + thisFilename %>' />				
<div width="100%" style='padding:0;margin:0'>
	<table class='table_data'>
		<tr>
			<th class='th' rowspan=2>서브시스템명</th>
			<th class='th' rowspan=2>업무명</th>
			<th class='th' rowspan=2>테스트케이스<br/>총건수</th>
			<th class='th' rowspan=2>1차<br/>대상케이스<br/>총건수</th>
			<th class='th' colspan=2>등록</th>
			<th class='th' colspan=4>개발자확인중</th>
			<th class='th' colspan=3>AL확인중</th>
			<th class='th' colspan=2>고객확인중</th>
			<th class='th' colspan=3>테스트실시율</th>
			<th class='th' colspan=3>테스트성공율</th>
		</tr>
		<tr>
			<th class='th'>확인중</td>
			<th class='th'>승인</td>
			<th class='th'>미실시</td>
			<th class='th'>실패</td>
			<th class='th'>미흡</td>
			<th class='th'>정상</td>
			<th class='th'>확인중</td>
			<th class='th'>승인</td>
			<th class='th'>반려</td>
			<th class='th'>확인중</td>
			<th class='th'>승인</td>
			<th class='th'>개발자</td>
			<th class='th'>PL</td>
			<th class='th'>고객</td>
			<th class='th'>개발자</td>
			<th class='th'>PL</td>
			<th class='th'>고객</td>
		</tr>
<%
	if(ds == null) {	// -- 데이터가 없을 경우, 여기서 끝
		out.println( "</table>"+ getNoData("조회된 내용이 없습니다.") +"</div>"  );	
		return ;		
	}

	double tmpD = -1.00f ;
	double[] totalD = {0,0,0,0,0,0,0,0,0,0
					  ,0,0,0,0,0,0,0,0,0,0,0} ;
	
	String align = "right" ; // -- 필드 정렬
	String[] row = null ;
	for (int j=0;j<ds.length;j++) {
		row = (String[])ds[j] ;
%>
	<tr>
<%
		for (int i=0;i<mock.length;i++) {
			if( isNumber(mock[i]) ) {
				tmpD = parseDouble(mock[i]) ;
				totalD[i] += tmpD ;
				
				align="right" ;
			}
			else align="left" ;
%>		
 			<td class='td <%=align%>'><%=mock[i] %></td>
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
		else if(i>1 && i<15) {
			summary = numberFormat(totalD[i]) ;
			align="right" ;
		}
		else {
			summary = parseDoubleString(totalD[i]) ;
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