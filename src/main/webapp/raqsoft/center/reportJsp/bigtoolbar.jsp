<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="com.raqsoft.report.view.*"%>
<%
	String appmap = request.getContextPath();
	String appRoot = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()+appmap;
	String ip = java.net.InetAddress.getLocalHost().getHostAddress();
	if(request.getProtocol().compareTo("HTTP/1.1")==0 ) response.setHeader("Cache-Control","no-cache");
	else response.setHeader("Pragma","no-cache");
	String mobile = request.getParameter("mobile");
%>
<style>
#wxqr {
  width:100px;
  height:100px;
  margin-top:15px;
  position:fixed;
} 
</style>
<script type="text/javascript" src="<%=appmap%><%=ReportConfig.raqsoftDir%>/center/js/qrcode.js"></script>
<div class="btnBar">
  <ul class="left">
    <!--<li class="borderRight submitLi" onClick="_submitTable( report1 );return false;" href="#"> <a title="提交" href="#" class="submit"></a></li>-->
    <li class="toggleBg borderRight">
      <ul class="fileOper">
       <li><a class="ICOhover" href="#" onClick="exportExcel('report1');return false;"><span title='<%=ServerMsg.getMessage(request,"jsp.e_excel")%>' class="excel"></span></a></li>
        <%
		if(mobile == null){
		%>
		<li><a class="ICOhover" href="#" onClick="flashPrintReport('report1');return false;"><span title='<%=ServerMsg.getMessage(request,"jsp.flashPrint")%>' class="printPreviewFlash"></span></a></li>
		<%} %>
       </ul>
    </li>
    <li class="toggleBg borderRight">
      <ul class="fileOper">
        <li><img src="../images/wechat.png" onclick="wxshare();"><div id="wxqr"></div></li>    
      </ul>
    </li>
	<%
	if(mobile == null){
	%>
    <li class="floatRight borderLeft">
      <ul class="fileOper">
         <Li><a class="ICOhover" href="#" onClick="try{toPage('report1',1);}catch(e){}return false;"><span title="首页" class="begin"></span></a></li>
        <li><a class="ICOhover" href="#" onClick="try{prevPage('report1');}catch(e){}return false;"><span title="上一页" class="pre"></span></a></li>
        <Li><a class="ICOhover" href="#" onClick="try{nextPage('report1');}catch(e){}return false;"><span title="下一页" class="next"></span></a></li>
        <li><a class="ICOhover" href="#" onClick="try{toPage('report1',getPageCount('report1'));}catch(e){}return false;"><span title="尾页" class="end"></span></a></li>    
      </ul>
    </li>
    <li class="floatRight">  <div style="display:inline-block; margin:6px 4px 6px 4px; float:left;font-size:14px"><span id="report1_loading" style="margin-right:10px"></span>  共<span id="report1_totalRecords"></span>条&nbsp;&nbsp;第<span id="report1_currPage"></span>页/共<span id="report1_totalPage"></span>页&nbsp;&nbsp;到<input type=text style="width:40px" onkeyup="if(event.keyCode==13)jumpToPage('report1',value)">页</div></li>
	<%} %>
  </ul>
</div>
<script>

var qrdisplayed = false;
var appRoot = '<%=appRoot%>';
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
				reporturl = appRoot+"/reportCenterServlet?action=372&isBig=1&wxshare=1&reportParamsId="+paramIndex;
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