<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/raqsoftReport.tld" prefix="report" %>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*" %>
<%@ page import="com.raqsoft.report.usermodel.Context"%>
<%@ page import="com.raqsoft.report.view.*"%>
<%@ page import="com.raqsoft.report.util.*"%>
<% 
	if(request.getProtocol().compareTo("HTTP/1.1")==0 ) response.setHeader("Cache-Control","no-cache");
	else response.setHeader("Pragma","no-cache");
	request.setCharacterEncoding( "UTF-8" );
	String appmap = request.getContextPath();
	String title = request.getParameter( "title" );
	if( title == null ) title = "手机版报表";
	String appRoot = request.getScheme() + "://" + request.getServerName()// + ":" + request.getServerPort()
		+ appmap;
%>

<html>
<head>
    <meta charset="utf-8">
	<meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1" />
	<title><%=title%></title>
</head>
<link rel="stylesheet" type="text/css" href="<%=appmap%><%=ReportConfig.raqsoftDir%>/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=appmap%><%=ReportConfig.raqsoftDir%>/easyui/themes/icon.css">
<script type="text/javascript" src="<%=appmap%><%=ReportConfig.raqsoftDir%>/easyui/jquery.min.js"></script>
<script type="text/javascript" src="<%=appmap%><%=ReportConfig.raqsoftDir%>/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=appmap%><%=ReportConfig.raqsoftDir%>/easyui/locale/easyui-lang-<%=ReportUtils2.getEasyuiLanguage(request)%>.js"></script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.6.0.js"></script>

<body style="margin:0px 3px">
<jsp:include page="echartjs.jsp" flush="false" />
<%
	String report = request.getParameter( "rpx" );
	if( report.lastIndexOf(".rpx") <= 0 ){
		report = report + ".rpx";
	}
	String match = request.getParameter( "match" );
	if (match==null || match.length()==0) match = "1";
	String isQuery = request.getParameter( "isQuery" );
	if( isQuery == null ) isQuery = "0";
	StringBuffer param = new StringBuffer();
	
	Enumeration paramNames = request.getParameterNames();
	if( paramNames != null ) {
		while( paramNames.hasMoreElements() ){
			String paramName = (String) paramNames.nextElement();
			if( "rpx".equals( paramName ) || "match".equals( paramName ) || "title".equals( paramName ) || "isQuery".equals( paramName ) ) continue;
			String paramValue = request.getParameter( paramName );
			if( paramValue != null ){
				param.append( paramName ).append( "=" ).append( paramValue ).append( ";" );
			}
		}
	}
%>
<div id=mengban style="background-color:white;position:absolute;z-index:999;width:100%;height:100%">
	<table width=100% height=100%>
		<tr><td width=100% style="text-align:center;vertical-align:middle"><img src="<%=appmap%><%=ReportConfig.raqsoftDir%>/images/loading.gif"><br><%=ServerMsg.getMessage(request,"jsp.loading")%></td></tr>
	</table>
</div>
<div id=reportArea class="easyui-layout" data-options="fit:true" style="display:none;width:100%;height:100%">
	<div id=reportContainer data-options="region:'center',border:false" style="text-align:center">
		<report:html name="report1" reportFileName="<%=report%>"
			funcBarLocation="no"
			generateParamForm="no"
			params="<%=param.toString()%>"
			needImportEasyui="no"
		/>
	</div>
	<!-- <div style="width:100%;bottom:41px;position:fixed">
		<img src="../../images/wechat.png" onclick="wxshare();">
	</div>
	<div style="width:100%;bottom:80px;left:100px;position:fixed">
		<img src="../../images/wechat.png" onclick="manuShare();">
	</div> -->
	<div data-options="region:'south',border:false" style="width:100%;height:41px;">
		<table width=100% cellspacing=0 cellpadding=0><tr>
			<td id=filterTd width=70 align=center><img src="filter.png" width=40 onclick="window.history.back()"></td>
			<td align=right>
				<img src="./previous.png" width=40 onclick="prevPage('report1')">
			</td>
			<td align=center width=70><span id="report1_currPage"></span>/<span id=totalPage></span></td>
			<td align=left><img src="./next.png" width=40 onclick="nextPage('report1')"></td>
		</tr></table>
	</div>
</div>
<script language="javascript">
	var report = "<%=report%>";
	var appRoot = "<%=appRoot%>";
	var ri = report.indexOf(".rpx");
	if(ri > 0){
		report = report.substring(0,ri);
	}
	try {
		document.getElementById( "totalPage" ).innerHTML = getPageCount( "report1" );
		document.getElementById( "report1_currPage" ).innerHTML = getCurrPage( "report1" );
		if( "<%=isQuery%>" != "1" ) document.getElementById( "filterTd" ).style.display = "none";
	}catch(e){}
	document.getElementById( "mengban" ).style.display = "none";
	document.getElementById( "reportArea" ).style.display = "";
	function matchReport() {
		reportMatchSize( document.getElementById( "reportContainer" ), document.getElementById( "report1_reportDiv" ), <%=match%> );
	}
	$(document).ready( function(){
		matchReport();
	});
	
	var finalShareUrlInPage = "";
	var ticketDatas = {};
	
	function wxshare(){
		console.log('call share');
		$.ajax({
			type:'post',
			url:appRoot+"/reportCenterServlet",
			data:{action:371,url:window.location.href.split('#')[0]},
			success:function(data){
				console.log('server get paramId:'+data);
				var finalShareUrl = appRoot+"/reportCenterServlet?action=372&wxshare=1&reportParamsId="+data;
				console.log('call server create tokens')
				$.ajax({
					url:appRoot+"/reportCenterServlet", 			
			        data:{action:373, shareurl:finalShareUrl},
			        type:'post',
			        success:function(data){
			        	console.log('server get tokens:'+data);
			        	data = eval("("+data+")");
			            if( data.error ){
			                alert( data.error.substring( 6 ) );
			                return;
			            }
			        	//上面返回应该包括以下config信息（包括appId）
			        	//第一步 从应用找有没有缓存的jsapi_ticket 7200秒 注意缓存 不能过多次的调用微信接口获取
			        	//若第一步为空 第二步 获取access_token:appid secret http
			        	//第三步 获取jsapi_ticket
			        	//https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=ACCESS_TOKEN&type=jsapi
			        	//第四步 拼接jsapi_ticket nonceStr timestamp url，最后用sha-1加密成一个串 作为signature
			        	finalShareUrlInPage = finalShareUrl;
			        	ticketDatas = data;
			        	console.log('config datas');
			        	console.log(ticketDatas);
			        	console.log(finalShareUrlInPage);
			            wx.config({
			    	        debug: true,
			    	        appId: ticketDatas.appid,
			    	        timestamp: ticketDatas.t,
			    	        nonceStr: ticketDatas.non,
			    	        signature: ticketDatas.sign,
			    	        jsApiList: ['updateAppMessageShareData']
			    	    });
			           //updateAppMessageShareData:fail, the permission value is offline verifying
			            
			            
			        	finalShareUrlInPage = finalShareUrl;
			        	var reportName = report;
			        	wx.error(function (res) {
				            console.log(res);
				        });
			            wx.ready(function () {
			            	alert('ready');
		            		wx.updateAppMessageShareData({
					            title: '报表浏览',
					            desc: reportName+"test",
					            link: finalShareUrl,
					            imgUrl: appRoot+"/raqsoft/img/chart.jpg"
					            
					        });
			    		});
			        },
			        error:function(xhr,type,errorThrown){//异常处理
			        	alert('query signature error');
			        }
			    });
				
			},
			error:function(){
				alert('get new url error');
			}
		});
	}
	
	function manuShare(){
		console.log('call manushare');
		var currpageUrl = location.href.split('#')[0];
		console.log(location.href.split('#')[0]);
		$.ajax({
			url:appRoot+"/reportCenterServlet", 			
	        data:{action:373, shareurl: currpageUrl },
	        type:'post',
	        success:function(data){
	        	console.log('server get tokens:'+data);
	        	data = eval("("+data+")");
	            if( data.error ){
	                alert( data.error.substring( 6 ) );
	                return;
	            }
	        	//上面返回应该包括以下config信息（包括appId）
	        	//第一步 从应用找有没有缓存的jsapi_ticket 7200秒 注意缓存 不能过多次的调用微信接口获取
	        	//若第一步为空 第二步 获取access_token:appid secret http
	        	//第三步 获取jsapi_ticket
	        	//https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=ACCESS_TOKEN&type=jsapi
	        	//第四步 拼接jsapi_ticket nonceStr timestamp url，最后用sha-1加密成一个串 作为signature
	        	console.log('config datas');
	        	console.log(data);
	            wx.config({
	    	        debug: true,
	    	        appId: data.appid,
	    	        timestamp: data.t,
	    	        nonceStr: data.non,
	    	        signature: data.sign,
	    	        jsApiList: ['updateAppMessageShareData']
	    	    });
	           
	        	wx.error(function (res) {
		            console.log(res);
		        });
	            wx.ready(function () {
	            	alert('ready');
            		wx.updateAppMessageShareData({
			            title: '报表浏览',
			            desc: reportName+"test2",
			            link: currpageUrl,
			            imgUrl: appRoot+"/raqsoft/img/chart.jpg"
			            
			        });
	    		});
	        },
	        error:function(xhr,type,errorThrown){//异常处理
	        	alert('query signature error');
	        }
	    });
	}
	
</script>

</body>
</html>
