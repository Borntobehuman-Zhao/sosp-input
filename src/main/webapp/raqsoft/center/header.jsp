<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.raqsoft.report.view.*" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%
	String appmap = request.getContextPath();
	String loginType = (String)(request.getSession().getAttribute("loginType"));
	String no_email = (String)session.getAttribute("no_email");
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>header</title>
<script src="<%=appmap %>/js/jquery.js"></script>
<script src="<%=appmap %><%=ReportConfig.raqsoftDir%>/center/layui/layui.all.js"></script>
<link rel="stylesheet" href="<%=appmap %><%=ReportConfig.raqsoftDir%>/center/layui/css/layui.css">
<style type="text/css">
a:link {text-decoration:none;}
a:visited {text-decoration:none;}
</style>
<script type="text/javascript">
	var device = navigator.userAgent;
	var isMobile = device.indexOf('Mobile') >= 0;
	var currReport = "";
	var fieldCurrNode = null;
	//var currModule = null;
	if(isMobile){
		window.location = "<%=appmap %><%=ReportConfig.raqsoftDir%>/center/mobile/jsp/index.jsp"
	}
	<% 
		if(request.getProtocol().compareTo("HTTP/1.1")==0 ) response.setHeader("Cache-Control","no-cache");
		else response.setHeader("Pragma","no-cache");
		request.setCharacterEncoding( "UTF-8" );
		appmap = request.getContextPath();
	%>
	function logout(silent){
		if(silent){
			$.ajax({
				url:"<%=appmap%>/reportCenterServlet?action=5",
				data:{},
				type:"post"
			});
		} else {
			window.top.location="<%=appmap%>/reportCenterServlet?action=5";
		}
	}
	
	function noLeftLayout(url){
		var leftF = window.top.document.getElementById("leftF");
		var showPropF = window.top.document.getElementById("showProp");
		leftF.style.display = "none";
		$('#props').css("left","0px");
		showPropF.setAttribute( "src", url );
	}
	
	function showReportList(ifShowTreeNodeComp){//超管  管理员  用户
		var leftF = window.top.document.getElementById("leftF");
		var showPropF = window.top.document.getElementById("showProp");
		var showNodeType = "no";
		leftF.style.display="";
		$('.layui-side').css("width","300px");
		$('#leftF').css("width","300px");
		$('#props').css("left","300px");
		leftF.setAttribute("src", "<%=appmap %><%=ReportConfig.raqsoftDir%>/center/tree.jsp?showReportContent="+loginType+"&ifShowTreeNodeComp="+ifShowTreeNodeComp);
	}

	function _reportManage(){//超管  管理员  用户
		noLeftLayout("<%=appmap%>/reportCenterServlet?action=24&fileType=report");
	}
	
	<%-- function _roleManage(){//超管  管理员
		var leftF = window.top.document.getElementById("leftF");
		var showPropF = window.top.document.getElementById("showProp");
		leftF.style.display = "";
		$('.layui-side').css("width","600px");
		$('#leftF').css("width","600px");
		$('#props').css("left","600px");
		leftF.setAttribute( "src", "<%=appmap%>/reportCenterServlet?action=34" );
		showPropF.setAttribute("src", "<%=appmap%>/reportCenterServlet?action=35&userAction=32" + "&roleId");
	} --%>
	function _roleManage(){//超管  管理员
		noLeftLayout("<%=appmap%>/reportCenterServlet?action=34");
	}
	
	
	function _userManage(){//超管  管理员
		if("supermanager" != loginType && "normalManager" != loginType){
			return;
		}
		noLeftLayout("<%=appmap%>/reportCenterServlet?action=16");
	}
	
	function _fileManage(){//超管  管理员
		noLeftLayout("<%=appmap%>/reportCenterServlet?action=39&fileType=all");
	}
	
	function _schedule(){//超管  管理员
		noLeftLayout("<%=appmap%>/reportCenterServlet?action=62");
	}
	
	function _modifyPwd(){//超管
		noLeftLayout("<%=appmap%>/reportCenterServlet?action=31&isManager=yes");
	}
	
	function _personal(){//超管  管理员  用户
		noLeftLayout("<%=appmap%>/reportCenterServlet?action=61");
	}
	
	function _settings(){//超管
		if("supermanager" != loginType ){
			return;
		}
		noLeftLayout("<%=appmap%>/reportCenterServlet?action=88");
	}
	
	//以下6个方法从index移植
	function showJsp(url,name){
		currReport=name;
	    document.getElementById("showProp").src = encodeURI(url); 
	    showLoading();
	}
	
	/* function doSearch( value ) {
		if( value == "" ) {
			alert( "请输入搜索内容" );
			return;
		}
		var searchUrl = encodeURI( "reportJsp/showReport.jsp?rpx=/search/search.rpx&search=" + value );
		document.getElementById("showProp").src = searchUrl;
	} */
	
	function readme(){
		if(fieldCurrNode == null){
			alert("请选择一个节点！");
			return;
		}
		var type = fieldCurrNode.getAttribute("type");
		if(type == "2" 
			|| type == "3"
			|| type == "4" ){
			alert("这个节点不是报表！")
			return;
		}
		document.getElementById("showProp").src = encodeURI("./reportJsp/showReport.jsp?rpx=/search/readme.rpx&search="+currReport); 
	}
	
	function show(name){
		currReport=name;
	    document.getElementById("showProp").src = encodeURI("/demo/reportJsp/showReport.jsp?rpx="+name); 
	    showLoading();
	}
	
	
	function showLoading() {
		var mban = document.getElementById( "mengban" );
		if(mban == null) return;
		var ww = document.getElementById( "sidebar" ).offsetWidth;
		var hh = document.getElementById( "headerbar" ).offsetHeight;
		mban.style.left = ww + "px";
		mban.style.top = hh + "px";
		mban.style.width = document.body.clientWidth - ww + "px";
		mban.style.height = document.getElementById( "mainDiv" ).offsetHeight + "px";
		mban.style.display = "";
	}
	
	
	function hideLoading() {
		var mban = document.getElementById( "mengban" );
		if(mban == null) return;
		mban.style.display = "none";
	}		
	
	function noEmail(f){
		var uls = document.getElementsByTagName("UL");
		var ul = uls[0];
		var i = 0;
		while(i<2){
			var personalLi = $(ul).find("li")[5+i];
			if(f){
				$(personalLi).find("a").append("<span class='noemailSpan' style='color:red'>*</span>");
				$(personalLi).css("display","inline-flex").attr("title","尽快填写邮箱，便于找回密码");
			}else{
				$(personalLi).css("background-color","").attr("title","");
				$(personalLi).find('.noemailSpan').remove();
				if(i == 0 ) $(personalLi).find("a").html("用户个人信息");
				if(i == 1 ) $(personalLi).find("a").html("管理员信息");
			}
			i++;
		}
	}
	var loginType = '<%=loginType%>';
	function initbtn(){
		$(".user").hide();
		$(".visitor").hide();
		$(".manager").hide();
		$(".supermanager").hide();
		$(".normalmanager").hide();
		$('.useronly').hide();
		if("user" == loginType){
			$('.user').show();
			$('.useronly').show();
		}
		if("normalManager" == loginType || "supermanager" == loginType){		
			$('.manager').show();
			$('.useronly').hide();
		}
		if("normalManager" == loginType ){
			$(".normalmanager").show();
			$('.useronly').hide();
		}
		if("supermanager" == loginType ){
			$(".supermanager").show();
			$('.useronly').hide();
		}
		if("visitor" == loginType){
			$('.visitor').show();
			$('.useronly').hide();
		}
		currModule = $('#1')[0];
		$('.layui-this').removeClass('layui-this');
	}
	
	$(function(){
		initbtn();
		/* $('.headbtn').bind("mouseenter",function(event){
			$(event.target.parentNode).addClass('layui-this');
		});
		$('.headbtn').bind("mouseleave",function(event){
			if(currModule.id != event.target.parentNode.id)
				$(event.target.parentNode).removeClass('layui-this');
		});
		$('.headbtn').bind("click",function(event){
			currModule = event.target.parentNode;
			$('.headbtn').removeClass("layui-this");
			$(event.target.parentNode).addClass("layui-this");
		}); */
		layui.use('element', function(){
			  var element = layui.element;
		});
	});
	

	function showRightSideMengban(){
		//$('#props').hide();
		$('#rightSideMengban').show();
	}

	function hideRightSideMengban(){
		//$('#props').show();
		$('#rightSideMengban').hide();
	}
</script>

</head>
<body>
<div class="layui-layout layui-layout-admin">
<div class="layui-header layui-bg-black">
<div class="layui-logo" style="background-color: #2F4046"><img src="<%=appmap %><%=ReportConfig.raqsoftDir%>/center/images/logo3.png"/></div>
 <ul class="layui-nav layui-layout-left">
  <li id="1" class="headbtn layui-this layui-nav-item user manager"><a href="javascript:showReportList(1);">节点显示</a></li>
  <li id="2" class="headbtn layui-nav-item manager"><a href="javascript:_roleManage();hideRightSideMengban();">机构管理</a></li>
  <li id="3" class="headbtn layui-nav-item manager"><a href="javascript:_userManage();hideRightSideMengban();">用户管理</a></li>
  <c:if test='${sessionScope.role.showReportOperButton or sessionScope.loginType eq "supermanager"}'>
	  <li id="4" class="headbtn layui-nav-item user manager"><a href="javascript:_reportManage();hideRightSideMengban();">报表管理</a></li>
  </c:if>
  <c:if test='${sessionScope.role.showFileOperButton or sessionScope.loginType eq "supermanager"}'>
	  <li id="5" class="headbtn layui-nav-item user manager"><a href="javascript:_fileManage();hideRightSideMengban();">查询分析管理</a></li>
  </c:if>
  <li id="6" class="headbtn layui-nav-item useronly"><a href="javascript:_personal();hideRightSideMengban();">用户个人信息</a></li>
  <li id="7" class="headbtn layui-nav-item manager supermanager"><a href="javascript:_personal();hideRightSideMengban();">管理员信息</a></li>
  <li id="8" class="headbtn layui-nav-item supermanager manager"><a href="javascript:_schedule();hideRightSideMengban();">任务</a></li>
  <li id="9" class="headbtn layui-nav-item supermanager"><a href="javascript:_modifyPwd();hideRightSideMengban();">密码管理</a></li>
  <li id="10" class="headbtn layui-nav-item supermanager"><a href="javascript:_settings();hideRightSideMengban();">设置</a></li>
  <li id="11" class="headbtn layui-nav-item visitor"><a href="javascript:readme();hideRightSideMengban();">报表说明</a></li>
</ul>
<ul class="layui-nav layui-layout-right">
	<li class="layui-nav-item user manager visitor" style="color: yellow;">
	       当前用户:<span class="manager">&nbsp;管理员:&nbsp;</span>
	       <span class="visitor">&nbsp;访客:&nbsp;</span>
	      <span class="visitor user manager">&nbsp;${userObj.userName}</span>
    </li>
	<li class="layui-nav-item user normalmanager"><a href="javascript:_modifyPwd();">个人密码</a></li>
    <li class="layui-nav-item user manager visitor"><a href="javascript:logout();">退出</a></li>
</div>
</div>
</body>

<%if("yes".equals(no_email)){ %>
<script type="text/javascript">
	noEmail(true);
</script>
<%} %>
</html>