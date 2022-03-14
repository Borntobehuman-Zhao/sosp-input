<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="com.raqsoft.report.view.*"%>
<%
	if(request.getProtocol().compareTo("HTTP/1.1")==0 ) response.setHeader("Cache-Control","no-cache");
	else response.setHeader("Pragma","no-cache");
	String appmap = request.getContextPath();
	String mobile = request.getParameter("mobile");
	String appRoot = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()+appmap;
	String ip = java.net.InetAddress.getLocalHost().getHostAddress();
%>
<script type="text/javascript" src="<%=appmap%><%=ReportConfig.raqsoftDir%>/pdfjs/toast/javascript/jquery.toastmessage.js"></script>
<script type="text/javascript" src="<%=appmap%><%=ReportConfig.raqsoftDir%>/center/js/qrcode.js"></script>
<link href="<%=appmap%><%=ReportConfig.raqsoftDir%>/pdfjs/toast/resources/css/jquery.toastmessage.css" type="text/css" rel="stylesheet" />
<style>
#wxqr {
  width:100px;
  height:100px;
  margin-top:15px;
  position:fixed;
} 
</style>
<div class="btnBar">
  <ul class="left">
    <li class="toggleBg borderRight">
      <ul class="fileOper">
        <li><a class="ICOhover" href="#" onClick="exportExcel('report1');return false;"><span title='<%=ServerMsg.getMessage(request,"jsp.e_excel")%>' class="excel"></span></a></li>
        <li><a class="ICOhover" href="#" onClick="exportPdf('report1');return false;"><span title='<%=ServerMsg.getMessage(request,"jsp.e_pdf")%>' class="pdf"></span></a></li>
		<li><a class="ICOhover" href="#" onClick="exportWord('report1');return false;"><span title='<%=ServerMsg.getMessage(request,"jsp.e_word")%>' class="word"></span></a></li>
		<li><a class="ICOhover" href="#" onClick="exportMht('report1');return false;"><span title='<%=ServerMsg.getMessage(request,"jsp.e_mht")%>' class="mht"></span></a></li>
       </ul>
    </li>
      <%
		if(mobile == null){
		%>
    <li class="toggleBg borderRight">
      <ul class="fileOper">
        <li><a class="ICOhover" href="#" onClick="printReport('report1');return false;"><span title='<%=ServerMsg.getMessage(request,"jsp.printPreview")%>' class="printPreviewApplet"></span></a></li>
		<li><a class="ICOhover" href="#" onClick="flashPrintReport('report1');return false;"><span title='<%=ServerMsg.getMessage(request,"jsp.flashPrint")%>' class="printPreviewFlash"></span></a></li>
		<li><a class="ICOhover" href="#" onClick="pdfPrintReport('report1');return false;"><span title='<%=ServerMsg.getMessage(request,"jsp.pdfPrint")%>' class="printPreviewPdf"></span></a></li>
		<li><a class="ICOhover" href="#" onClick="localPrintReport('report1');return false;"><span title='<%=ServerMsg.getMessage(request,"jsp.localPrintPreview")%>' class="printPreview"></span></a></li>
       </ul>
    </li>
    <li class="toggleBg borderRight">
      <ul class="fileOper">
		<li><a class="ICOhover" href="#" onClick="directPrintReport('report1');return false;"><span title='<%=ServerMsg.getMessage(request,"jsp.d_print")%>' class="printApplet"></span></a></li>
		<li><a class="ICOhover" href="#" onClick="directFlashPrintReport('report1');return false;"><span title='<%=ServerMsg.getMessage(request,"jsp.d_flashPrint")%>' class="printFlash"></span></a></li>
		<li><a class="ICOhover" href="#" onClick="directPdfPrintReport('report1');return false;"><span title='<%=ServerMsg.getMessage(request,"jsp.d_pdfPrint")%>' class="printPdf"></span></a></li>
		<li><a class="ICOhover" href="#" onClick="localDirectPrintReport('report1');return false;"><span title='<%=ServerMsg.getMessage(request,"jsp.d_localPrint")%>' class="print"></span></a></li>
		</ul>
    </li>
	<li class="toggleBg borderRight">
      <ul class="fileOper">
        <li><img src="../images/wechat.png" onclick="wxshare();"><div id="wxqr"></div></li>    
      </ul>
    </li>
    <li class="floatRight borderLeft">
      <ul class="fileOper">
         <Li><a class="ICOhover" href="#" onClick="try{toPage('report1',1);}catch(e){}return false;"><span title='<%=ServerMsg.getMessage(request,"jsp.firstPage")%>' class="begin"></span></a></li>
        <li><a class="ICOhover" href="#" onClick="try{prevPage('report1');}catch(e){}return false;"><span title='<%=ServerMsg.getMessage(request,"jsp.prevPage")%>' class="pre"></span></a></li>
        <Li><a class="ICOhover" href="#" onClick="try{nextPage('report1');}catch(e){}return false;"><span title='<%=ServerMsg.getMessage(request,"jsp.nextPage")%>' class="next"></span></a></li>
        <li><a class="ICOhover" href="#" onClick="try{toPage('report1',getPageCount('report1'));}catch(e){}return false;"><span title='<%=ServerMsg.getMessage(request,"jsp.lastPage")%>' class="end"></span></a></li>    
      </ul>
    </li>
    <li class="floatRight">  <div style="display:inline-block; margin:9px 4px 3px 4px; float:left; "><!--<%=ServerMsg.getMessage(request,"jsp.currPage1")%><span id="report1_currPage"></span><%=ServerMsg.getMessage(request,"jsp.currPage2")%>/<%=ServerMsg.getMessage(request,"jsp.totalPage1")%><span id="t_page_span"></span><%=ServerMsg.getMessage(request,"jsp.totalPage2")%>&nbsp;&nbsp;--></div></li>
    <%
	}
	%>
  </ul>

</div>
<script language=javascript>
	var myToast, flashToast;
	var qrdisplayed = false;
	var appRoot = '<%=appRoot%>';
	var raqsoftDir = '<%=ReportConfig.raqsoftDir%>';
	function showToast() {
		myToast = $().toastmessage('showToast', {
		    text     : '正在加载打印页......',
		    sticky   : true,
		    position : 'middle-center',
		    type:         'notice'
		});		
	}
	function closeToast() {
		$().toastmessage('removeToast', myToast);
	}
	function showFlashToast() {
		flashToast = $().toastmessage('showToast', {
		    text     : '正在打印......',
		    sticky   : true,
		    position : 'middle-center',
		    type:         'notice'
		});		
	}
	function closeFlashToast() {
		$().toastmessage('removeToast', flashToast);
	}
	
	function wxshare(){
		
		if(qrdisplayed) {
			try{
				$(wxqr).css('display','none');
			}catch(e){return;}
			qrdisplayed = false;
		}else{
			var reporturl = window.location.href;
			try{
				$(wxqr).css('display','');
			}catch(e){return;}
			qrdisplayed = true;
			if($('#wxqr').children().length > 0) {
				return;
			}
			var paramIndex = "none";
			//在应用短时间存一份param qrcode承载数据有限
			$.ajax({
				type:'post',
				url:appRoot+"/reportCenterServlet",
				data:{action:371,url:reporturl},
				success:function(data){
					paramIndex = data;
					reporturl = appRoot+"/reportCenterServlet?action=372&wxshare=1&reportParamsId="+paramIndex;
					if(window.location.host.indexOf("localhost") >= 0){
						reporturl = reporturl.replace("localhost","<%=ip%>");
					}
					new QRCode('wxqr',{
					    text: reporturl,
					    width: 128,
					    height: 128,
					    colorDark : "#000000",
					    colorLight : "#ffffff"
					});
				},
				error:function(){
					alert('error');
				}
			});
		}
		
	}
</script>
