<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ include file="incCommon.jspf"%><%@ page import="java.util.*, java.text.DateFormat, java.text.SimpleDateFormat" %><%@ include file="incCommonUtil.jspf"%><%
	final String nowUrl = request.getRequestURI() ;
	String thisFilename = nowUrl.substring(nowUrl.lastIndexOf("/")+1) ;
	String thisFilenameNoExt = thisFilename.substring(0,thisFilename.lastIndexOf(".")) ;
	
	// -- TODO - get dataset
	String[] mock = new String[]{"보상/손사","손사"
			,"1","1","-"
			,"1","1","-"
			,"1","1","-"
			,"0","0","-"
			,"0","0","-"
			,"0","0","-"
			,"0","0","-"
			,"0","0","-"
			,"0","0","-"
			,"0","0","-"
			,"0","0","-"
			,"0","0","-"
			,"0","0","-"
			} ;

	Object[] ds = new Object[]{ mock } ;
	
	// -- ds = null ;
%><input type='hidden' id='info_report' value='통합테스트 진척 변동현황[1차]<%=__INFO_DELIM__ + thisFilename %>' />				
<div width="100%" style='padding:0;margin:0'>
	<table class='table_data'>
		<tr>
			<th class='th' rowspan=3>서브시스템명</th>
			<th class='th' rowspan=3>업무명</th>
			<th class='th' rowspan=2 colspan=3>테스트케이스<br/>총건수</th>
			<th class='th' rowspan=2 colspan=3>1차<br/>대상케이스<br/>총건수</th>
			<th class='th' colspan=6>등록</th>
			<th class='th' colspan=12>개발자확인중</th>
			<th class='th' colspan=9>AL확인중</th>
			<th class='th' colspan=6>고객확인중</th>
		</tr>
		<tr>
			<th class='th' colspan=3>미확인</td>
			<th class='th' colspan=3>승인</td>

			<th class='th' colspan=3>미실시</td>
			<th class='th' colspan=3>정상</td>
			<th class='th' colspan=3>미흡</td>
			<th class='th' colspan=3>실패</td>
			
			<th class='th' colspan=3>미확인</td>
			<th class='th' colspan=3>승인</td>
			<th class='th' colspan=3>반려</td>

			<th class='th' colspan=3>미확인</td>
			<th class='th' colspan=3>승인</td>
		</tr>
		<tr>
			<th class='th'>전일</th>
			<th class='th'>당일</th>
			<th class='th'>증감</th>

			<th class='th'>전일</th>
			<th class='th'>당일</th>
			<th class='th'>증감</th>

			<th class='th'>전일</th>
			<th class='th'>당일</th>
			<th class='th'>증감</th>

			<th class='th'>전일</th>
			<th class='th'>당일</th>
			<th class='th'>증감</th>

			<th class='th'>전일</th>
			<th class='th'>당일</th>
			<th class='th'>증감</th>

			<th class='th'>전일</th>
			<th class='th'>당일</th>
			<th class='th'>증감</th>

			<th class='th'>전일</th>
			<th class='th'>당일</th>
			<th class='th'>증감</th>

			<th class='th'>전일</th>
			<th class='th'>당일</th>
			<th class='th'>증감</th>

			<th class='th'>전일</th>
			<th class='th'>당일</th>
			<th class='th'>증감</th>

			<th class='th'>전일</th>
			<th class='th'>당일</th>
			<th class='th'>증감</th>

			<th class='th'>전일</th>
			<th class='th'>당일</th>
			<th class='th'>증감</th>

			<th class='th'>전일</th>
			<th class='th'>당일</th>
			<th class='th'>증감</th>

			<th class='th'>전일</th>
			<th class='th'>당일</th>
			<th class='th'>증감</th>
	
		</tr>
<%
	if(ds == null) {	// -- 데이터가 없을 경우, 여기서 끝
		out.println( "</table>"+ getNoData("조회된 내용이 없습니다.") +"</div>"  );	
		return ;		
	}

	double tmpD = -1.00f ;
	double[] totalD = {0,0
					,0,0,0
					,0,0,0
					,0,0,0
					,0,0,0
					,0,0,0
					,0,0,0
					,0,0,0
					,0,0,0
					,0,0,0
					,0,0,0
					,0,0,0
					,0,0,0
					,0,0,0					
					} ;
	
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
			else if(i<2)align="left" ;
			else {
				align="right" ;
			}
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