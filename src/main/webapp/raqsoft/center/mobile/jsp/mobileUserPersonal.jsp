<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.raqsoft.report.view.*" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%
	String contextPath = request.getContextPath();
%>
<script type="text/javascript" src="<%=contextPath%>/js/jquery.js"></script>
<script src="<%=contextPath%><%=ReportConfig.raqsoftDir%>/center/userPersonal.js"></script>
<script src="<%=contextPath%><%=ReportConfig.raqsoftDir%>/center/layui/layui.all.js"></script>
<link rel="stylesheet" href="<%=contextPath%><%=ReportConfig.raqsoftDir%>/center/layui/css/layui.css">
<script>
var params = '${userObj.reportParams}';
function form_submit(){
	var submiturl = form.action;
	submiturl += "&userId=${userObj.userId}";
	submiturl += "&email="+encodeURIComponent(form.email.value);
	submiturl += "&phone="+encodeURIComponent(form.phone.value);
	/* submiturl += "&reportMacro="+encodeURIComponent(form.reportMacro.value); */
	//submiturl += "&dqlMacro="+encodeURIComponent(form.dqlMacro.value);
	//var paramsJson = inputToJson2();
	//submiturl += "&reportParams="+encodeURIComponent(paramsJson);
	$.ajax({
		type:'post',
		data:[],
		url:submiturl,
		success:function(){
			var msg = "保存成功";
			if(hasNullParam){
				msg += ",没有设置名称的属性将被忽略"
			}
			layer.msg(msg);
		}
	});
}

</script>
<style type="text/css">
.layui-input, .layui-select{
	width:130px
}
.paramTr{
	border-top-style:solid;
	border-top-style: 1px
}
</style>
</head>
<body>
	<div align="center" class="layui" style="margin-top:20px">个人信息修改</div>
	<br>
	<div align="center">
	<div style="width:100%" class="layui-tab">
		  <!-- <ul class="layui-tab-title">
		    <li class="layui-this">个人</li>
		    <li class="reportParam">报表参数设置(<font id="count"></font>)</li>
		  </ul> -->
		  <div class="layui-tab-content">
		  <div class="layui-tab-item layui-show">
		   <form id=form method=post
				action="<%=contextPath%>/reportCenterServlet?action=53">
			<div align="center">
				<input type="hidden" value="${userObj.userId}" id="userId" name="userId"/>
				<TABLE align=center class="layui-table" style="table-layout: fixed; BORDER-COLLAPSE: collapse;width:350px">
					<tr class="">
						<td><span>用户名</span></td>
						<td>
							${userObj.userName}
						</td>
					</tr>
					<tr class="">
						<td><span>邮箱</span></td>
						<td>
							<input class="layui-input" type="text" lay-verify="email" name='email' id="email" value="${userObj.email}"/>
						</td>
					</tr>
					<tr class="">
						<td><span>电话</span></td>
						<td>
							<input class="layui-input" type="text" lay-verify="required|phone" name="phone" id="phone" value="${userObj.phone}"/>
						</td>
					</tr>
				</table>
			</div>
			</form>
			</div>
			</div>
			</div>
			<div class="" style="height:35px;width:100%">
			    <input type="button" class="layui-btn layui-btn-green" onclick="form_submit();" value="保存"/>
			 </div>
			</div>
</body>
</html>