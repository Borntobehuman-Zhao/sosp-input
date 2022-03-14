<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.raqsoft.report.view.*" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
	String contextPath = request.getContextPath();
	String loginType = (String)(request.getSession().getAttribute("loginType"));
	if(!"supermanager".equals(loginType)){
%>
	<script>
		window.top.location = "./raqsoft/center/centerIndex.jsp";
	</script>
<%
	}
%>
<script type="text/javascript" src="<%=contextPath%>/js/jquery.js"></script>
<script type="text/javascript" src="<%=contextPath%><%=ReportConfig.raqsoftDir%>/center/js/tools.js"></script>
<script type="text/javascript" src="<%=contextPath%><%=ReportConfig.raqsoftDir%>/center/layui/layui.js"></script>
<link rel="stylesheet" href="<%=contextPath%><%=ReportConfig.raqsoftDir%>/center/layui/css/layui.css">
<title>settings</title>
<style type="text/css">
.show{
	display:block!important
}
</style>
<script>
	var settings_old = {};
	settings_old.lockTime = '${settings.lockTime}';
	settings_old.login_limit_check_interval = '${settings.login_limit_check_interval}';
	settings_old.login_fail_limit = '${settings.login_fail_limit}';
	
	settings_old.encoder = '${settings.encoder}';
	
	settings_old.userManger = '${settings.userManger}';
	settings_old.userDb = '${settings.userDb}';
	settings_old.user_table_name = '${settings.user_table_name}';
	settings_old.user_att_table_name = '${settings.user_att_table_name}';
	
	settings_old.sso_verify_url = '${settings.sso_verify_url}';
	settings_old.sso_login_url = '${settings.sso_login_url}';
	settings_old.sso_logout_url = '${settings.sso_logout_url}';
	settings_old.sso_cookie_name = "${settings.sso_cookie_name}";
	settings_old.sso_cookie_domain = '${settings.sso_cookie_domain}';
	settings_old.sso_cookie_path = '${settings.sso_cookie_path}';
	
	document.ready = function(){
		initCheckboxDom();
	}
	
	console.log(settings_old);
	function save(){
		var changedData = {};
		processCheckboxValue(changedData);
		if(form1.lockTime.value != settings_old.lockTime){
			changedData.lockTime = form1.lockTime.value;
		}
		if(form1.login_limit_check_interval.value != settings_old.login_limit_check_interval){
			changedData.login_limit_check_interval = form1.login_limit_check_interval.value;
		}
		if(form1.login_fail_limit.value != settings_old.login_fail_limit){
			changedData.login_fail_limit = form1.login_fail_limit.value;
		}
		if(form1.encoder.value != settings_old.encoder){
			changedData.encoder = form1.encoder.value;
		}
		if(form1.userManger.value != settings_old.userManger){
			changedData.userManger = form1.userManger.value;
		}
		if(form1.userDb.value != settings_old.userDb){
			changedData.userDb = form1.userDb.value;
		}
		if(form1.user_table_name.value != settings_old.user_table_name){
			changedData.user_table_name = form1.user_table_name.value;
		}
		if(form1.user_att_table_name.value != settings_old.user_att_table_name){
			changedData.user_att_table_name = form1.user_att_table_name.value;
		}
		if(form1.sso_verify_url.value != settings_old.sso_verify_url){
			changedData.sso_verify_url = form1.sso_verify_url.value;
		}
		if(form1.sso_login_url.value != settings_old.sso_login_url){
			changedData.sso_login_url = form1.sso_login_url.value;
		}
		if(form1.sso_logout_url.value != settings_old.sso_logout_url){
			changedData.sso_logout_url = form1.sso_logout_url.value;
		}
		if(form1.sso_cookie_name.value != settings_old.sso_cookie_name){
			changedData.sso_cookie_name = form1.sso_cookie_name.value;
		}
		if(form1.sso_cookie_path.value != settings_old.sso_cookie_path){
			changedData.sso_cookie_path = form1.sso_cookie_path.value;
		}
		if(form1.sso_cookie_domain.value != settings_old.sso_cookie_domain){
			changedData.sso_cookie_domain = form1.sso_cookie_domain.value;
		}
		
		console.log(changedData);
		$.ajax({
			data:changedData,
			type:'post',
			url:'./reportCenterServlet?action=89',
			success:function(result){
				console.log(result);
				alert("finished");
				window.location="./reportCenterServlet?action=88";
			}
		});
		
	}
	
	function processCheckboxValue(changedData){
		if(form1.pass_encode.checked && settings_old.pass_encode != form1.pass_encode.value){
			changedData.pass_encode = form1.pass_encode.value;
		}else if(!form1.pass_encode.checked && settings_old.pass_encode != "0"){
			changedData.pass_encode = "0";
		}
		
		if(form1.sso_enable.checked && settings_old.sso_enable != form1.sso_enable.value){
			changedData.sso_enable = form1.sso_enable.value;
		}else if(!form1.sso_enable.checked && settings_old.sso_enable != "0"){
			changedData.sso_enable = "0";
		}
	}
	
	function initCheckboxDom(){
		$(form1.pass_encode).click(function(){
			if(form1.pass_encode.checked) {
				$('.pass_encoder').attr("disabled",true);
			}else{
				$('.pass_encoder').removeAttr("disabled");
			}
		});
		
		$(form1.sso_enable).click(function(){
			if(form1.sso_enable.checked) {
				$('.sso').removeAttr("disabled");
			}else{
				$('.sso').attr("disabled",true);
			}
		});
		
		if('${settings.pass_encode}' == '1') {
			settings_old.pass_encode = "1";
			form1.pass_encode.checked = true;
			$('.pass_encoder').attr("disabled",true);
		}else{
			settings_old.pass_encode = "0";
		}
		if('${settings.sso_enable}' == '1') {
			settings_old.sso_enable = "1";
			form1.sso_enable.checked = true;
		}else{
			settings_old.sso_enable = "0";
			$('.sso').attr("disabled",true);
		}
	}
</script>
</head>
<body>
	<form class="layui-form" id=form1 name=form1 method=post action="">
		<div align="center">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 50px;">
			  <legend>锁定用户</legend>
			</fieldset>
			<TABLE align=center class="layui-table" style="table-layout: fixed; BORDER-COLLAPSE: collapse;width:650px">
				<tr class="">
					<td><span>锁定时长</span></td>
					<td>
					<div class="layui-form-item">
						<input class="layui-input" name="lockTime" type="text" value="${settings.lockTime}"/>
					</div>
					</td>
				</tr>
				<tr class="">
					<td><span>间隔时间</span></td>
					<td>
					<div class="layui-form-item">
						<input class="layui-input" name="login_limit_check_interval" type="text" value="${settings.login_limit_check_interval}"/>
					</div>
					</td>
				</tr>
				<tr class="">
					<td><span>间隔时间内登陆失败次数</span></td>
					<td>
					<div class="layui-form-item">
						<input class="layui-input" name="login_fail_limit" type="text" value="${settings.login_fail_limit}"/>
					</div>
					</td>
				</tr>
			</TABLE>
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 50px;display:none">
			  <legend>密码加密</legend>
			</fieldset>
			<TABLE align=center class="layui-table" style="table-layout: fixed; BORDER-COLLAPSE: collapse;width:650px;display:none">
				<tr class="">
					<td><span>是否加密登录时的密码（仅MD5可用）</span></td>
					<td>
					<div class="">
						<input class="show" name="pass_encode" type="checkbox" value="1"/>
					</div>
					</td>
				</tr>
				<tr class="">
					<td><span>密码记录加密方式（默认MD5）</span></td>
					<td>
					<div class="layui-form-item">
						<input class="layui-input pass_encoder" name="encoder" type="text" value="${settings.encoder}"/>
					</div>
					</td>
				</tr>
			</TABLE>
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 50px;">
			  <legend>用户管理</legend>
			</fieldset>
			<TABLE align=center class="layui-table" style="table-layout: fixed; BORDER-COLLAPSE: collapse;width:650px">
				<tr class="">
					<td><span>用户管理类全限定名</span></td>
					<td>
					<div class="layui-form-item">
						<input class="layui-input" name="userManger" type="text" value="${settings.userManger}"/>
					</div>
					</td>
				</tr>
				<tr class="">
					<td><span>数据库工厂或命名空间</span></td>
					<td>
					<div class="layui-form-item">
						<input class="layui-input" name="userDb" type="text" value="${settings.userDb}"/>
					</div>
					</td>
				</tr>
				<tr class="">
					<td><span>数据库用户表名</span></td>
					<td>
					<div class="layui-form-item">
						<input class="layui-input" name="user_table_name" type="text" value="${settings.user_table_name}"/>
					</div>
					</td>
				</tr>
				<tr class="">
					<td><span>数据库用户表从表名</span></td>
					<td>
					<div class="layui-form-item">
						<input class="layui-input" name="user_att_table_name" type="text" value="${settings.user_att_table_name}"/>
					</div>
					</td>
				</tr>
			</TABLE>
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 50px;">
			  <legend>单点登录</legend>
			</fieldset>
			<TABLE align=center class="layui-table" style="table-layout: fixed; BORDER-COLLAPSE: collapse;width:650px">
				<tr class="">
					<td><span>启用</span></td>
					<td>
					<div class="">
						<input class="show" name="sso_enable" type="checkbox" value="1"/>
					</div>
					</td>
				</tr>
				<tr class="">
					<td><span>校验url</span></td>
					<td>
					<div class="layui-form-item">
						<input class="layui-input sso" name="sso_verify_url" type="text" value="${settings.sso_verify_url}"/>
					</div>
					</td>
				</tr>
				<tr class="">
					<td><span>登录url</span></td>
					<td>
					<div class="layui-form-item">
						<input class="layui-input sso" name="sso_login_url" type="text" value="${settings.sso_login_url}"/>
					</div>
					</td>
				</tr>
				<tr class="">
					<td><span>登出url</span></td>
					<td>
					<div class="layui-form-item">
						<input class="layui-input sso" name="sso_logout_url" type="text" value="${settings.sso_logout_url}"/>
					</div>
					</td>
				</tr>
				<tr class="">
					<td><span>cookie名称</span></td>
					<td>
					<div class="layui-form-item">
						<input class="layui-input sso" name="sso_cookie_name" type="text" value="${settings.sso_cookie_name}"/>
					</div>
					</td>
				</tr>
				<tr class="">
					<td><span>cookie生效路径</span></td>
					<td>
					<div class="layui-form-item">
						<input class="layui-input sso" name="sso_cookie_path" type="text" value="${settings.sso_cookie_path}"/>
					</div>
					</td>
				</tr>
				<tr class="">
					<td><span>cookie作用域</span></td>
					<td>
					<div class="layui-form-item">
						<input class="layui-input sso" name="sso_cookie_domain" type="text" value="${settings.sso_cookie_domain}"/>
					</div>
					</td>
				</tr>
			</TABLE>
		</div>
	</form>
	<button type="button" style="position:fixed;top:10px;left:10px;border-radius: 50px" class="layui-btn layui-btn-lg layui-anim layui-anim-scaleSpring" onclick="save();return false;">保存</button>
</body>
</html>