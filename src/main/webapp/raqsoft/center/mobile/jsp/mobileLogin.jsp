<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.raqsoft.report.view.*" %>
<%@ page isELIgnored="false" %> 
<!DOCTYPE html>
<html class="ui-page-login">
<%
	String appmap = request.getContextPath();
	Object enableValidImg = request.getSession().getAttribute("enableValieImg");
	boolean pe = true;
	Object o = request.getAttribute("passEncode");
	if(o != null){
		pe = (Boolean)o;
	}
%>
<c:if test="${userObj ne null }">
	<script type="text/javascript">window.location = "<%=appmap %><%=ReportConfig.raqsoftDir%>/center/mobile/jsp/index.jsp"</script>
</c:if>
<script type="text/javascript">
var device = navigator.userAgent;
var isMobile = device.indexOf('Mobile') >= 0;
if(!isMobile){
	window.location = "<%=appmap%>/raqsoft/center/centerLogin.jsp"
}
</script>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="format-detection" content="telephone=no">
  <meta name="renderer" content="webkit">
  <meta http-equiv="Cache-Control" content="no-siteapp" />
  <link rel="stylesheet" href="../assets/css/amazeui.min.css"/>
  <script src="../../../easyui/jquery.min.js"></script>
  <script src="<%=appmap%><%=ReportConfig.raqsoftDir%>/center/layui/md5.js"></script>
  <script src="<%=appmap%><%=ReportConfig.raqsoftDir%>/center/js/login.js"></script>
  <style>
    .header {
      text-align: center;
    }
    .header h1 {
      font-size: 200%;
      color: #333;
      margin-top: 30px;
    }
    .header p {
      font-size: 14px;
    }
    .texts{
      border-top: 0px!important;
      border-left: 0px!important;
      border-right: 0px!important
    }
    .am-btn-lightred{
      color: #fff;
	  background-color: #f1493c;
	  border-color: #f1493c;
	  border-radius: 100px;
    }
  </style>
</head>
<body style="padding-left: 10px;">
	<div class="header">
	  <div class="am-g" style="">
	    <h1>登录报表中心</h1>
	  </div>
	  <hr />
	</div>
	<form method="post" class="am-form">
      <input class="texts" type="text" name="" id="userName" value="" placeholder="请输入用户名">
      <br>
      <input class="texts" type="password" name="" id="password" value="" placeholder="请输入密码">
      <input type="hidden" id="loginType" value="0">
      <br>
      <br />
      <div class="am-cf">
        <div id="vidiv" style="width:380px;margin-top:0px;">
	        <div id='vnInput' style="display: inline-block;width:30%"></div>
			<div id='vimg' style="display: inline-block;width:30%"></div>
		</div>
      </div>
      <div class="am-cf">
        <input type="button" name="" onclick="_submit();" value="登 录" class="am-btn am-btn-lightred am-btn-sm am-fl"  style="width:100%;margin-top:10px">
        </div>
    </form>
	<script>
		var enableValidImg = <%=enableValidImg %>;
		var vurl = "<%=appmap%>/reportCenterServlet";
		var src = "<%=appmap %><%=ReportConfig.raqsoftDir%>";
		function _submit(){
			var userBox = document.getElementById("userName");
			var passwordBox = document.getElementById("password");
			var loginType = document.getElementById("loginType");
			if(enableValidImg) var validNum = document.getElementById("validNum").value;
			var pe = <%=pe%>;
			var password = "";
			if(pe) password = hex_md5(passwordBox.value).toUpperCase();
			var loginInfo = {
				"userName": userBox.value,
				"p": password,
				"validNum":validNum,
				"isManager": loginType.value
			};
			ajaxlogin(loginInfo, function(err) {
				if (err) {
					if(err == 'manager' || err == 'user'){
						window.location='<%=appmap%>/raqsoft/center/mobile/jsp/mobileLogin.jsp';
					}else{
						alert(err);
					}
				}
			});
		}
		
		function ajaxlogin(loginInfo, callback){
			$.ajax({
				data:loginInfo,
				type:"post",
				async:false,
				url:"<%=appmap%>/reportCenterServlet?action=3",
				success:function(data){
					if(data.indexOf('manager')>=0 || data.indexOf('success')>=0){
						callback('manager');
					}else {
						callback(data);
					}
				}
			});
		}
	</script>
</body>
</html>