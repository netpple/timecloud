<%@ include file="header.jsp"%>
<!-- 메인이미지 -->
 <script type="text/javascript">
    $(function() {
      $('#slides').slidesjs({
    	  width:967,
    	  height:327,
        play: {
          active: true,
          auto: true,
          interval: 5000,
          swap: true,
          effect: "slide"
        }
      });
    });
    
    //window.open('popup.jsp','popup','width=500,height=809');
  </script>

<div id="main_background">
</div>

<div id="slides">
	<img src="./img/main_1.png" border="0" />
	<img src="./img/main_2.png" border="0" />
	<img src="./img/main_3.png" border="0" />
	<img src="./img/main_4.png" border="0" />
</div>

<!-- /메인이미지 -->
<!-- 메인테이불 -->
<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td width="967" align="left" valign="top" style="padding-left: 20px;">
			<!-- 내용 -->
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="14"></td>
				</tr>
				<tr>
					<td width="320" valign="top">
						<!-- 공지사항 -->
						<table border="0" cellspacing="0" cellpadding="0">
							<tr height="30" valign="top">
								<td><a href="#"><img src="./img/main_title_notice.png"
										border="0" alt="공지사항"></a></td>
							</tr>
						</table> <!-- 타이틀 -->
						<table border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td height="38" valign="top"
									style="font-family: Gulim; color: #9c9c9c; line-height: 18px">
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="84" height="16" colspan="2"
												style="font-size: 12px; font-family: Gulim; color: #717171">
												<!-- 게시판 시작 --------------------------------------------------------->

												<table border="0" cellspacing="0" cellpadding="0"
													width="345" class='board_output'>
													<tr height="70" valign="top">
														<td>
															<table border='0' cellspacing='0' cellpadding='0'
																width='100%' id='output'>
																<tr class='board_output_3_tr' valign="middle">
																	<td><img src="./img/main_icon_notice.png"
																		align="absmiddle"> <a class='bd_out1'
																		style='word-break: break-all; overflow: auto;' href=''><strong>장터지기
																				제품 업그레이드.</strong></a></td>
																	<td align="right">[2013-02-16]</td>
																</tr>
																<tr class='board_output_3_tr' valign="middle">
																	<td><img src="./img/main_icon_notice.png"
																		align="absmiddle"> <a class='bd_out1'
																		style='word-break: break-all; overflow: auto;' href=''><strong>장터지기
																				제품 업그레이드.</strong></a></td>
																	<td align="right">[2013-02-16]</td>
																</tr>
																<tr class='board_output_3_tr' valign="middle">
																	<td><img src="./img/main_icon_notice.png"
																		align="absmiddle"> <a class='bd_out1'
																		style='word-break: break-all; overflow: auto;' href=''><strong>장터지기
																				제품 업그레이드.</strong></a></td>
																	<td align="right">[2013-02-16]</td>
																</tr>
															</table>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<table border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td height="97" valign="top">
									<img src="./img/main_product.png" border="0" alt="제품문의">
									<img src="./img/account.png" border="0" alt="계좌번호" style="margin-top:6px;">
								</td>
							</tr>
						</table>
					</td>
					<td width="376" valign="top" align="center">
						<table border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td><a href="#"><img src="./img/main_qna.png"
										border="0" alt=""></a></td>
							</tr>
							<tr height="130">
								<td><a href="#"><img src="./img/main_rma.png"
										border="0" alt=""></a></td>
							</tr>
						</table>
					</td>
					<td width="216" valign="middle"><img
						src="./img/main_price.png" border="0" usemap="#Map"/></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<map name="Map" id="Map">
  <area shape="rect" coords="0,8,220,151" href="order1.jsp" />
  <area shape="rect" coords="2,154,216,185" href="cs5.jsp" />
</map>

<%@include file="bottom.jsp"%>