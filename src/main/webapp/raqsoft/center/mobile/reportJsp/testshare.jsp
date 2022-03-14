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
	String refreshTik = request.getParameter("refresh");
	if( refreshTik == null ) refreshTik = "false";
	else refreshTik = "true";
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
	<div style="width:100%;bottom:80px;left:100px;position:fixed">
		<img src="../../images/wechat.png" onclick="manuShare();">
	</div>
	<div data-options="region:'south',border:false" style="width:100%;height:41px;">
		<table width=100% cellspacing=0 cellpadding=0><tr>
			<td id=filterTd width=70 align=center><img src="filter.png" width=40 onclick="window.history.back()"></td>
			<td align=right>
				<img src="previous.png" width=40 onclick="prevPage('report1')">
			</td>
			<td align=center width=70><span id="report1_currPage"></span>/<span id=totalPage></span></td>
			<td align=left><img src="next.png" width=40 onclick="nextPage('report1')"></td>
		</tr></table>
	</div>
</div>
<script language="javascript">
	var report = "test";
	var appRoot = "<%=appRoot%>";
	var refreshTik = <%=refreshTik%>;
	var ri = report.indexOf(".rpx");
	if(ri > 0){
		report = report.substring(0,ri);
	}
	try {
		document.getElementById( "totalPage" ).innerHTML = getPageCount( "report1" );
		document.getElementById( "report1_currPage" ).innerHTML = getCurrPage( "report1" );
	}catch(e){}
	
	var finalShareUrlInPage = "";
	var ticketDatas = {};
	
	function manuShare(){
		console.log('call manushare');
		var currpageUrl = location.href.split('#')[0];
		console.log(location.href.split('#')[0]);
		$.ajax({
			url:appRoot+"/reportCenterServlet", 			
	        data:{action:373, shareurl: currpageUrl, refresh: refreshTik },
	        type:'post',//HTTP请求类型
	        //timeout:30000,//超时时间设置为30秒；
	        success:function(data){//服务器返回响应，根据响应结果，分析是否登录成功；
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
			            desc: report,
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
