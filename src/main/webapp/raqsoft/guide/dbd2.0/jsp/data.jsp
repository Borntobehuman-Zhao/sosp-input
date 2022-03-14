<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/raqsoftAnalyse.tld" prefix="raqsoft" %>
<%@ page import="com.raqsoft.guide.resource.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>仪表板</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%
String cp = request.getContextPath();
String title = request.getParameter("title");
if (title == null) title = "Raqsoft Query/Analyse";
String guideDir = cp + "/raqsoft/guide/";//request.getParameter("guideDir");
String v = ""+System.currentTimeMillis();

request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=utf8");
String view = request.getParameter( "view" );
if (view == null) view = "source";
String olap = request.getParameter( "olap" );
if (olap == null) olap = "";
String isOpenDOlap = "false";
if(olap.length()>0) isOpenDOlap = "true";
String dataSource = request.getParameter( "dataSource" );
if (dataSource == null) dataSource = "";
String ql = request.getParameter( "ql" );
if (ql == null) ql = "";
String dfxFile = request.getParameter( "dfxFile" );
if (dfxFile == null) dfxFile = "";
if(dfxFile.length()>0) isOpenDOlap = "dataFile";
String dfxScript = request.getParameter( "dfxScript" );
if (dfxScript == null) dfxScript = "";
if(dfxScript.length()>0) isOpenDOlap = "dataFile";
String dfxParams = request.getParameter( "dfxParams" );
if (dfxParams == null) dfxParams = "";
String inputFiles = request.getParameter( "inputFiles" );
if (inputFiles == null) inputFiles = "";
if(inputFiles.length()>0) isOpenDOlap = "dataFile";
String fixedTable = request.getParameter( "fixedTable" );
if (fixedTable == null) fixedTable = "";
String dataFileType = request.getParameter("dataFileType");
if(dataFileType==null) dataFileType = "text";
String dct = request.getParameter("dct");
if(dct==null) dct="";

dct = dct.replaceAll("\\\\", "/");
String vsb = request.getParameter("vsb");
if(vsb==null) vsb = "";
vsb = vsb.replaceAll("\\\\", "/");
String filter = request.getParameter( "filter" );
if (filter == null) filter = "default";
String sqlId = request.getParameter( "sqlId" );
if (sqlId == null) sqlId = "";
String macro = request.getParameter( "macro" );
if (macro == null) macro = "";
macro = macro.replaceAll("\\\\", "/");
String dataFolderOnServer = "/WEB-INF/files/data/";
String resultRpxPrefixOnServer = "/WEB-INF/files/resultRpx/";
/* if (dataSource.length() == 0) {
	dataSource="DataLogic";
} */
%>
<style type="text/css">

.topHeader{
	margin-bottom: 0px!important;
	border-bottom: none!important;
	border-width:0px!important;
}

.topHeader2{
	height:57px;
    background-image: -webkit-linear-gradient(#475375, #475375, #475375);
    background-image: -o-linear-gradient(#475375, #475375, #475375);
    background-image: linear-gradient(#475375, #475375, #475375);
    background-repeat: no-repeat;
	background-color: #475375!important;
}

.topHeader2>ul>li>a{
	font-size:12px;
	color:white;
}

.navbar-nav2>li>a{
	padding-top: 0px!important;
	padding-bottom: 0px!important;
	padding-right: 20px!important;
	padding-left: 20px!important;
	float: left;
}

.navbar-collapse2{
	padding-left:10px;
	padding-right:10px;
	height:24px!important;
	width:70%!important;
	position: absolute!important;
}

#dataHeader{
	padding:0px!important;
	position:fixed;
	z-index: 2;
	width:100%;
}

a{
    text-align: center;
}

.headerText>svg{
position:relative; top:4px;
}
.bottom{
    position: fixed;
    bottom: 0;
    width: 35%;
    height:300px;
    text-align: center;
    background-color: rgba(255,255,255,0.9);
	box-shadow: 0 0 10px rgba(189,189,189,.4);
}
.bottom2{
    position: fixed;
    bottom: 0;
    width: 400px;
    height:auto;
    text-align: center;
    background-color: rgba(255,255,255,0.9);
	box-shadow: 0 0 10px rgba(189,189,189,.4);
}
.block{
    bottom: 0;
    height:90%;
    width:30%;
    text-align: center;
    padding-top:10px;
    margin-left:20px;
    z-index: 10000;
}
.blockP{
	display: grid;
}

.propSubTitle{
	color:white;
	padding-left:10px;
	font-size: 16px;
	margin-bottom:10px;
	margin-top:20px;
}

.cw{
	color:white;
}

.accordion-group2{
    border-width: thin;
    border-color: #e5e5e5;
    border-style: solid;
}

#modelReportFields>table, #gridTable>table{
	background-color:white;
}

.ztree, #items{
	background-color: white;
}

.control-label2{
	width: 50%;
	color:white;
	font-weight: 100!important;
	cursor: auto!important;
}

.w80{
	width: 80%;
}

.form-group {
    margin-bottom: 1px!important;
    margin-left: 0px!important;
    margin-right: 0px!important;
}

ul.nav-tabs>li>a{
	color:white;
}

.nav-tabs>li.active>a{
	background-color: #dcdeff!important;
}

.box{
	margin:0px!important;
	height:100%!important;
}

.divCell{
	height:100%!important;
}

.gridster>ul>li{
	margin:1px;
}

ul.multiselect-container>li>a{
	text-align: left!important;
}

.box-icon1>a{
	height:22px;
}

</style>
</head>
<body style="overflow: hidden;">
<script>
var contextPath = '<%=cp%>';
var guideDir = '<%=guideDir%>';
</script>
<script src="../../js/j_query_yi_jiu_yi.js"></script>
<script src="../../../easyui/jquery.easyui.min.js"></script>
<script>
var easyuiapi = jQuery.noConflict(true);//与原jquery冲突，重定义$，本页面用easyuiapi代表easyui的$
</script>

<script src="../../js/j_query_yi_jiu_yi.js"></script>
<script src="../../../../js/bootstrap.min.js"></script>
<script src="../../../../js/bootstrap-treeview.js"></script>
<script type="text/javascript" src="../js/gridster/jquery.dsmorse-gridster.js"></script>
<script src="../js/bootstrap-colorpicker.js"></script>
<script src="../js/bootstrap-toggle.min.js"></script>
<script src="../js/bootstrap-multiselect.js"></script>
<link href="../js/gridster/jquery.dsmorse-gridster.min.css"  rel="stylesheet"/>
<link href="../css/bootstrap/bootstrap.css" rel="stylesheet" media="screen">
<link href="../css/bootstrap/bootstrap-cerulean.min.css" type="text/css" rel="stylesheet">
<link href="../css/bootstrap/bootstrap-responsive.css" rel="stylesheet" media="screen">
<link href="../css/bootstrap/bootstrap-toggle.min.css" rel="stylesheet">
<link href="../css/bootstrap/bootstrap-multiselect.css" rel="stylesheet">
<link href="../css/animate.css" rel="stylesheet">
<link href="../css/charisma-app.css" rel="stylesheet">
<link href="../css/bootstrap/bootstrap-treeview.css" rel="stylesheet" media="screen">
<link href="../css/bootstrap/bootstrap-colorpicker.css" type="text/css" rel="stylesheet">
<link  rel="stylesheet" href="../css/DBD.css"/>
<link  rel="stylesheet" href="../css/style.css"/>
<link rel="stylesheet" type="text/css" href="../../../easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="../../../easyui/themes/icon.css">
<link rel="stylesheet" href="<%=guideDir %>js/jquery-powerFloat/css/powerFloat.css" type="text/css">
<link rel="stylesheet" href="<%=guideDir %>js/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<link rel="stylesheet" href="<%=guideDir %>js/chosen_v1.5.1/chosen.css" type="text/css">
<link rel="stylesheet" href="<%=guideDir %>asset/layui/css/layui.css">


<!-- <script src="../js/gridstrap.js-0.7.3/jquery-3.2.1.js"></script>
<script src="../js/gridstrap.js-0.7.3/dist/jquery.gridstrap.min.js"></script>
<link rel="stylesheet" href="../js/gridstrap.js-0.7.3/dist/jquery.gridstrap.min.css">  -->
<script type="text/javascript">
$(function(){
	setTimeout(function(){
	$('.rg-overlay').find('span').css('box-sizing','initial');
	$('.milestone').css('line-height','20px');
	$('.ruler').css('box-sizing','initial');
	$('.ruler.h').remove();
	$('.rg-overlay').find('.menu-btn').remove();
	},500);
	
});
</script>
<raqsoft:dashboard
	dataSource="<%=dataSource %>"
	olap="<%=olap %>"
  	fixedTable="<%=fixedTable %>"
	ql="<%=ql %>"
  	dfxFile="<%=dfxFile %>"
  	dfxScript="<%=dfxScript %>"
  	dfxParams="<%=dfxParams %>"
  	inputFiles="<%=inputFiles %>"
  	dataFileType="<%=dataFileType %>"
></raqsoft:dashboard>
<script type="text/javascript" src="<%=guideDir %>/dbd2.0/js/dashboard.js"></script>
<script type="text/javascript" src="<%=guideDir %>/dbd2.0/js/dataUi.js?v=<%=v %>"></script>
<script type="text/javascript" src="<%=guideDir %>/dbd2.0/js/editors.js?v=<%=v %>"></script> 
<script type="text/javascript" src="<%=guideDir %>/dbd2.0/js/viewStyle.js?v=<%=v %>"></script>
<script type="text/javascript" src="<%=guideDir %>/dbd2.0/js/common_d2.js?v=<%=v %>"></script>
<script type="text/javascript" src="<%=guideDir %>/dbd2.0/js/dqlApi_d2.js"></script>
<script type="text/javascript" src="<%=guideDir %>/dbd2.0/js/where_d2.js?v=<%=v %>"></script>
<script type="text/javascript" src="<%=guideDir %>/js/query_common.js?v=<%=v %>"></script>
<script type="text/javascript" src="<%=guideDir %>/dbd2.0/js/query_d2.js"></script>
<script type="text/javascript" src="<%=guideDir %>/dbd2.0/js/dqlreport_d2.js"></script>
<script type="text/javascript" src="<%=guideDir %>/dbd2.0/js/raqsoftApi_d2.js?v=<%=v %>"></script> 
<script type="text/javascript" src="<%=guideDir %>js/jquery-ui-1.10.1.custom.min.js"></script>
<script type="text/javascript" src="<%=guideDir %>js/jquery-powerFloat/js/jquery-powerFloat.js?v=<%=v %>"></script>
<script type="text/javascript" src="<%=guideDir %>js/artDialog/jquery.artDialog.source.js?skin=blue"></script>
<script type="text/javascript" src="<%=guideDir %>asset/layui/layui.all.js"></script>
<script type="text/javascript" src="<%=guideDir %>js/ztree/js/jquery.ztree.all-3.5.min.js"></script>
<script type="text/javascript" src="<%=guideDir %>js/ztree/js/jquery.ztree.exhide-3.5.min.js"></script>
<script type="text/javascript" src="<%=guideDir %>js/chosen_v1.5.1/chosen.jquery.min.js"></script>
<div class="container-fluid" id="dataHeader">
	<nav class="navbar navbar-inner fadeOutBottomLeft topHeader" role="navigation">
		<ul class="collapse navbar-collapse nav navbar-nav top-menu">
			<li><a class="headerText" href="javascript:saveOlap();">
				<svg t="1594380893453" class="icon" viewBox="0 0 1029 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="2104" width="19" height="19"><path d="M1020.417841 183.287144L825.886697 0 742.90001 1.094549H0v1022.905451h1024.199009V266.074823l-3.781168-82.787679zM125.475075 63.782334h683.893888l90.151006 84.976776 1.492566 241.49723h-66.667962V196.720241H764.193956v193.536099H659.316296V133.037411h-125.375571v257.218929H125.475075V63.782334z m0 892.156642v-441.799631h776.333496l2.786123 441.799631h-779.119619z" p-id="2105" fill="#ffffff"></path></svg>
					保存</a></li>
			<li><a class="headerText" href="javascript:preview();">
				<svg t="1594381028362" class="icon" viewBox="0 0 1028 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="5642" width="19" height="19"><path d="M989.143969 0H34.871595C15.646693 0 0.007782 15.638911 0.007782 34.863813v954.272374c0 19.224903 15.638911 34.863813 34.863813 34.863813h631.533074c19.224903 0 34.863813-15.638911 34.863813-34.863813s-15.638911-34.863813-34.863813-34.863813H69.735409V69.727626h884.544747v596.669261c0 19.224903 15.638911 34.863813 34.863813 34.863813s34.863813-15.638911 34.863813-34.863813V34.863813c0-19.224903-15.638911-34.863813-34.863813-34.863813z" p-id="5643" fill="#ffffff"></path><path d="M495.771206 398.642802c6.175875-6.175875 12.650584-11.953307 19.324514-17.232685-26.197665 9.562646-50.701946 24.803113-71.719845 45.821011-76.999222 76.999222-76.999222 202.010895 0 279.010117 23.308949 23.308949 51.000778 39.545525 80.286382 48.709728-9.761868-7.072374-19.125292-15.140856-27.891051-23.906615-91.741634-91.841245-91.741634-240.659922 0-332.401556z" p-id="5644" fill="#ffffff"></path><path d="M801.775875 737.319844c-6.275486-6.275486-13.248249-11.15642-20.420233-14.642801 31.676265-43.629572 50.403113-97.220233 50.403113-155.293385 0-146.029572-118.337743-264.267704-264.267704-264.267705S303.123735 421.453696 303.123735 567.383658 421.461479 831.750973 567.39144 831.750973c58.073152 0 111.663813-18.726848 155.293385-50.403113 3.486381 7.171984 8.367315 14.144747 14.642801 20.420233l198.823347 198.922958c23.308949 23.308949 56.877821 27.891051 74.60856 10.160311 17.83035-17.730739 13.248249-51.299611-10.0607-74.60856L801.775875 737.319844z m-234.384435 45.223347c-29.086381 0-57.176654-5.677821-83.772763-16.933852-25.6-10.857588-48.610117-26.297276-68.333074-46.119845-19.722957-19.822568-35.262257-42.832685-46.119844-68.333074-11.256031-26.496498-16.933852-54.686381-16.933852-83.772762s5.677821-57.176654 16.933852-83.772763c10.857588-25.6 26.297276-48.610117 46.119844-68.333074 19.822568-19.822568 42.832685-35.262257 68.333074-46.119844 26.596109-11.256031 54.686381-16.933852 83.772763-16.933852s57.176654 5.677821 83.772762 16.933852c25.6 10.857588 48.610117 26.297276 68.333074 46.119844 19.822568 19.822568 35.262257 42.832685 46.119845 68.333074 11.256031 26.496498 16.933852 54.686381 16.933852 83.772763s-5.677821 57.176654-16.933852 83.772762c-10.857588 25.6-26.297276 48.610117-46.119845 68.333074-19.822568 19.822568-42.832685 35.262257-68.333074 46.119845-26.496498 11.256031-54.686381 16.933852-83.772762 16.933852z" p-id="5645" fill="#ffffff"></path></svg>
				预览</a></li>
			<li>
				<a class="headerText" href="javascript:manageDataSet();">
				<svg t="1594380554625" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="1917" width="20" height="20"><path d="M226.6 402.8L8.2 280.9 512 0l503.7 280.9-218.3 121.9 217.9 124-185.1 105.3 185.1 105.4L512 1024 8.8 737.5l185.1-105.3L8.8 526.8l217.8-124zM725.2 443L512 561.9 298.8 443l-147.2 83.7L512 731.9l360.4-205.2c0 0.1-147.2-83.7-147.2-83.7zM265.3 672.8l-113.7 64.7L512 942.7l360.4-205.2-113.7-64.7L512 813.3 265.3 672.8z" p-id="1918" fill="#ffffff"></path></svg>
				数据集</a>
			</li>
			<li><a class="headerText" id="sysparams" class="" href="javascript:showSysparams();">
				
				<svg t="1614768447072" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="20099" width="20" height="20"><path d="M917 160H107c-23.75 0-43 19.25-43 43v618c0 23.75 19.25 43 43 43h810c23.75 0 43-19.25 43-43V203c0-23.75-19.25-43-43-43z m-43 618H150V356h724v422zM150 270v-24h724v24H150z" fill="#ffffff" p-id="20100" data-spm-anchor-id="a313x.7781069.0.i56" class="selected"></path><path d="M372.51 738.64c-28.35 0-49.25-5.61-62.68-16.83-13.44-11.22-20.15-29.16-20.15-53.81v-61c0-5.67-0.55-10.29-1.66-13.87-1.11-3.57-2.72-6.29-4.81-8.14-2.1-1.85-4.81-3.08-8.14-3.7-3.33-0.61-7.21-0.92-11.65-0.92v-38.83c4.44 0 8.32-0.31 11.65-0.92 3.33-0.61 6.04-1.85 8.14-3.7 2.09-1.85 3.7-4.5 4.81-7.95 1.11-3.45 1.66-8.01 1.66-13.68v-61.02c0-24.9 6.78-42.9 20.34-53.99 13.56-11.09 34.39-16.64 62.5-16.64v38.83c-6.41 0-11.53 0.43-15.35 1.29-3.83 0.87-6.72 2.53-8.69 4.99-1.98 2.47-3.33 5.73-4.07 9.8-0.74 4.07-1.11 9.31-1.11 15.72v61.02c0 14.79-3.21 25.52-9.61 32.17-6.41 6.66-15.66 11.22-27.73 13.68 12.08 2.47 21.32 7.03 27.73 13.68 6.41 6.66 9.61 17.38 9.61 32.17v61.02c0 6.66 0.37 12.08 1.11 16.27 0.74 4.19 2.22 7.45 4.44 9.8 2.22 2.34 5.23 3.88 9.06 4.62 3.82 0.74 8.69 1.11 14.61 1.11v38.83zM651.49 699.82c5.92 0 10.79-0.37 14.61-1.11 3.83-0.74 6.84-2.28 9.06-4.62 2.22-2.35 3.7-5.61 4.44-9.8 0.74-4.19 1.11-9.61 1.11-16.27V607c0-14.79 3.21-25.52 9.61-32.17 6.41-6.66 15.66-11.22 27.73-13.68-12.08-2.46-21.32-7.03-27.73-13.68-6.41-6.66-9.61-17.38-9.61-32.17v-61.02c0-6.41-0.37-11.65-1.11-15.72-0.74-4.07-2.09-7.33-4.07-9.8-1.97-2.46-4.87-4.13-8.69-4.99-3.82-0.86-8.93-1.29-15.35-1.29v-38.83c28.1 0 48.94 5.55 62.5 16.64 13.56 11.09 20.34 29.09 20.34 53.99v61.02c0 5.67 0.55 10.23 1.66 13.68 1.11 3.46 2.72 6.1 4.81 7.95 2.1 1.85 4.81 3.09 8.14 3.7 3.33 0.62 7.21 0.92 11.65 0.92v38.83c-4.44 0-8.32 0.31-11.65 0.92-3.33 0.62-6.04 1.85-8.14 3.7-2.09 1.85-3.7 4.56-4.81 8.14-1.11 3.58-1.66 8.2-1.66 13.87v61.02c0 24.65-6.71 42.58-20.15 53.81-13.43 11.22-34.33 16.83-62.68 16.83v-38.85z" fill="#ffffff" p-id="20101" data-spm-anchor-id="a313x.7781069.0.i57" class="selected"></path><path d="M436.92 671.14c-17.57 0-30.52-3.48-38.84-10.43-8.33-6.95-12.49-18.07-12.49-33.34v-37.81c0-3.51-0.34-6.38-1.03-8.59s-1.68-3.9-2.98-5.04c-1.3-1.15-2.98-1.91-5.04-2.29-2.06-0.38-4.47-0.57-7.22-0.57V549c2.75 0 5.16-0.19 7.22-0.57 2.06-0.38 3.74-1.15 5.04-2.29 1.3-1.15 2.29-2.79 2.98-4.93 0.69-2.14 1.03-4.96 1.03-8.48v-37.81c0-15.43 4.2-26.58 12.6-33.46 8.4-6.88 21.31-10.31 38.73-10.31v24.06c-3.97 0-7.14 0.27-9.51 0.8-2.37 0.54-4.16 1.57-5.39 3.09-1.22 1.53-2.06 3.55-2.52 6.07-0.46 2.52-0.69 5.77-0.69 9.74v37.81c0 9.17-1.99 15.81-5.96 19.94-3.97 4.12-9.7 6.95-17.19 8.48 7.48 1.53 13.21 4.35 17.19 8.48 3.97 4.13 5.96 10.77 5.96 19.94v37.81c0 4.12 0.23 7.48 0.69 10.08 0.46 2.6 1.37 4.62 2.75 6.07 1.37 1.45 3.24 2.41 5.61 2.86 2.37 0.46 5.39 0.69 9.05 0.69v24.07zM587.08 647.08c3.67 0 6.69-0.23 9.05-0.69 2.37-0.46 4.24-1.41 5.61-2.86 1.38-1.45 2.29-3.48 2.75-6.07 0.46-2.6 0.69-5.96 0.69-10.08v-37.81c0-9.17 1.99-15.81 5.96-19.94 3.97-4.12 9.7-6.95 17.19-8.48-7.48-1.53-13.21-4.35-17.19-8.48-3.97-4.13-5.96-10.77-5.96-19.94v-37.81c0-3.97-0.23-7.22-0.69-9.74-0.46-2.52-1.3-4.54-2.52-6.07-1.22-1.53-3.01-2.56-5.39-3.09-2.37-0.53-5.54-0.8-9.51-0.8v-24.06c17.42 0 30.33 3.44 38.73 10.31 8.4 6.88 12.6 18.03 12.6 33.46v37.81c0 3.52 0.34 6.34 1.03 8.48 0.69 2.14 1.68 3.78 2.98 4.93s2.98 1.91 5.04 2.29c2.06 0.38 4.47 0.57 7.22 0.57v24.06c-2.75 0-5.16 0.19-7.22 0.57-2.06 0.38-3.74 1.15-5.04 2.29-1.3 1.15-2.29 2.83-2.98 5.04-0.69 2.22-1.03 5.08-1.03 8.59v37.81c0 15.28-4.16 26.39-12.49 33.34-8.33 6.95-21.27 10.43-38.84 10.43v-24.06z" fill="#ffffff" p-id="20102" data-spm-anchor-id="a313x.7781069.0.i58" class="selected"></path></svg>
				<!-- <svg t="1594381404891" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="11707" width="16" height="16"><path d="M556.8 960H166.4c-25.6 0-51.2-12.8-70.4-25.6-19.2-19.2-32-44.8-32-70.4v-115.2c6.4-19.2 12.8-38.4 32-51.2 12.8-6.4 19.2-12.8 32-12.8s25.6 6.4 44.8 12.8H192c12.8 6.4 19.2 6.4 32 6.4s25.6 0 32-6.4c12.8-6.4 19.2-12.8 25.6-19.2 6.4-6.4 12.8-19.2 19.2-25.6 6.4-12.8 6.4-19.2 6.4-32s0-25.6-6.4-32c-6.4-12.8-12.8-19.2-19.2-25.6s-19.2-12.8-25.6-19.2c-12.8-6.4-19.2-6.4-32-6.4s-19.2 0-32 6.4h-6.4-6.4c-6.4 6.4-19.2 6.4-25.6 12.8-12.8 6.4-25.6 6.4-38.4 6.4-19.2 0-32-12.8-38.4-25.6-6.4-12.8-12.8-25.6-12.8-44.8V390.4c0-25.6 12.8-51.2 32-70.4 19.2-19.2 44.8-32 70.4-32h83.2c-6.4-19.2-6.4-32-6.4-51.2 0-25.6 6.4-51.2 12.8-70.4l38.4-57.6c19.2-19.2 38.4-32 57.6-38.4 25.6-12.8 44.8-12.8 70.4-12.8s51.2 6.4 70.4 12.8l57.6 38.4c19.2 19.2 32 38.4 38.4 57.6 12.8 25.6 12.8 44.8 12.8 70.4 0 19.2 0 38.4-6.4 51.2h25.6c25.6 0 51.2 12.8 70.4 32 19.2 19.2 25.6 44.8 25.6 70.4v19.2c0 12.8-12.8 32-38.4 32-25.6 0-32-12.8-38.4-25.6v-25.6c0-6.4 0-12.8-6.4-19.2-6.4-6.4-6.4-6.4-19.2-6.4H441.6l51.2-64c19.2-19.2 25.6-38.4 25.6-64 0-12.8 0-32-6.4-44.8-6.4-12.8-12.8-25.6-25.6-32-12.8-12.8-19.2-19.2-32-25.6-12.8-6.4-25.6-6.4-44.8-6.4-12.8 0-25.6 0-44.8 6.4-12.8 6.4-25.6 12.8-32 25.6-12.8 12.8-19.2 19.2-25.6 32-6.4 12.8-6.4 25.6-6.4 44.8 0 12.8 0 25.6 6.4 38.4 6.4 12.8 12.8 25.6 19.2 32l51.2 64H153.6c-6.4 0-12.8 0-19.2 6.4-6.4 6.4-6.4 12.8-6.4 19.2v89.6s6.4 0 6.4-6.4c6.4 0 6.4-6.4 12.8-6.4 19.2-6.4 38.4-12.8 64-12.8 19.2 0 44.8 6.4 64 12.8 19.2 6.4 38.4 19.2 51.2 32 12.8 12.8 25.6 32 32 51.2 6.4 19.2 12.8 38.4 12.8 64 0 19.2-6.4 44.8-12.8 64-6.4 19.2-19.2 38.4-32 51.2-12.8 12.8-32 25.6-51.2 32-19.2 6.4-38.4 12.8-64 12.8-19.2 0-44.8-6.4-64-12.8-6.4 0-12.8-6.4-19.2-6.4v96c0 6.4 0 12.8 6.4 19.2 6.4 6.4 12.8 6.4 19.2 6.4h396.8c19.2 6.4 25.6 19.2 25.6 38.4 6.4 25.6 0 32-19.2 38.4z m204.8-76.8c-6.4-6.4-25.6-19.2-32-19.2-6.4 0-25.6 12.8-32 19.2-6.4 6.4-19.2 12.8-25.6 12.8-6.4 0-12.8 0-12.8-6.4l-51.2-25.6c-12.8-12.8-19.2-25.6-12.8-44.8 0 0 6.4-6.4 6.4-12.8 0-12.8-6.4-19.2-12.8-25.6-6.4-6.4-19.2-12.8-25.6-12.8-12.8 0-25.6-12.8-32-32 0 0-6.4-25.6-6.4-44.8 0-19.2 6.4-44.8 6.4-44.8 6.4-19.2 12.8-32 32-32s38.4-19.2 38.4-38.4c0-6.4-6.4-12.8-6.4-12.8-6.4-19.2 0-38.4 12.8-44.8l57.6-32c6.4 0 12.8-6.4 12.8-6.4 12.8 0 19.2 6.4 25.6 12.8 6.4 6.4 25.6 19.2 32 19.2 6.4 0 25.6-12.8 32-19.2 6.4-6.4 19.2-12.8 25.6-12.8 6.4 0 12.8 0 12.8 6.4l51.2 25.6c12.8 12.8 19.2 25.6 12.8 44.8 0 0-6.4 6.4-6.4 12.8 0 19.2 19.2 38.4 38.4 38.4 12.8 0 25.6 12.8 32 32 0 0 6.4 25.6 6.4 44.8 0 19.2-6.4 44.8-6.4 44.8-6.4 19.2-12.8 32-32 32-12.8 0-19.2 6.4-25.6 12.8s-12.8 19.2-12.8 25.6c0 6.4 6.4 12.8 6.4 12.8 6.4 19.2 0 38.4-12.8 44.8l-57.6 32c-6.4 0-12.8 6.4-12.8 6.4-12.8 0-19.2-6.4-25.6-12.8z m-38.4-70.4c19.2 0 32 6.4 51.2 19.2 6.4 6.4 12.8 6.4 12.8 12.8l32-19.2c0-6.4 0-12.8-6.4-25.6 0-44.8 32-83.2 76.8-89.6v-19.2-19.2c-44.8-6.4-76.8-44.8-76.8-89.6 0-6.4 0-19.2 6.4-25.6l-32-19.2-12.8 12.8c-19.2 12.8-32 19.2-51.2 19.2s-32-6.4-51.2-19.2c-6.4-6.4-12.8-6.4-12.8-12.8l-32 19.2c0 6.4 6.4 12.8 6.4 25.6 0 44.8-32 83.2-76.8 89.6v38.4c44.8 6.4 76.8 44.8 76.8 89.6 0 6.4 0 19.2-6.4 25.6l25.6 12.8 12.8-12.8c25.6-6.4 44.8-12.8 57.6-12.8z m0-38.4c-44.8 0-83.2-38.4-83.2-83.2 0-44.8 38.4-83.2 83.2-83.2 44.8 0 83.2 38.4 83.2 83.2 6.4 44.8-32 83.2-83.2 83.2z m0-115.2c-6.4 0-19.2 6.4-25.6 6.4-6.4 6.4-6.4 12.8-6.4 25.6 0 19.2 12.8 32 32 32s32-12.8 32-32-12.8-32-32-32z" fill="#ffffff" p-id="11708"></path></svg> -->
				共享参数</a>
			</li>
		</ul>
	</nav>
	
	<nav class="navbar2 navbar-inner2 topHeader2" role="navigation">
		<ul class="collapse navbar-collapse2 navbar-collapse nav navbar-nav2 top-menu">
			<li><a title="网格报表" class="headerText" href="javascript:go('report','define');">
			<svg t="1614768022722" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="9376" width="24" height="24"><path d="M984 610.6H714.72V328a40 40 0 0 0-80 0v282.6H404.14V328a40 40 0 0 0-80 0v282.6H40a40 40 0 0 0 0 80h284.14V984a40 40 0 0 0 80 0V690.6h230.58V984a40 40 0 0 0 80 0V690.6H984a40 40 0 0 0 0-80z" fill="#FF9041" p-id="9377"></path><path d="M924 0H100A100.12 100.12 0 0 0 0 100v824a100.12 100.12 0 0 0 100 100h824a100.12 100.12 0 0 0 100-100V100a100.12 100.12 0 0 0-100-100zM100 80h824a20.26 20.26 0 0 1 20 20v188H80V100a20.26 20.26 0 0 1 20-20z m824 864H100a20.26 20.26 0 0 1-20-20V368h864v556a20.26 20.26 0 0 1-20 20z" fill="#3390FF" p-id="9378"></path></svg>
			<br/>
			网格报表
			</a>
			</li>
			<li><a title="统计图" class="headerText" href="javascript:go('report','choose');">
			<svg t="1614767660023" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="1148" width="24" height="24"><path d="M599.978667 509.013333h271.36a64.426667 64.426667 0 0 1 63.061333 76.245334 426.666667 426.666667 0 0 1-753.664 189.525333 426.666667 426.666667 0 0 1 257.365333-685.482667 64.512 64.512 0 0 1 76.544 63.061334v271.36a85.333333 85.333333 0 0 0 85.333334 85.333333z" fill="#1296db" p-id="1149" data-spm-anchor-id="a313x.7781069.0.i0" class=""></path><path d="M840.576 183.082667a343.978667 343.978667 0 0 1 92.501333 166.954666 64 64 0 0 1-62.848 77.525334H681.386667a85.333333 85.333333 0 0 1-85.333334-85.333334V153.472a64 64 0 0 1 77.568-62.848A343.978667 343.978667 0 0 1 840.533333 183.04z" fill="#e2ad23" p-id="1150" data-spm-anchor-id="a313x.7781069.0.i1" class=""></path></svg>		
			<br/>
			统计图
			</a></li>
			<li>
				<a title="参数控件" class="headerText" href="javascript:go('editor',null);">
				<!-- <svg t="1614768394065" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="19409" width="24" height="24"><path d="M64 128m32 0l832 0q32 0 32 32l0 0q0 32-32 32l-832 0q-32 0-32-32l0 0q0-32 32-32Z" fill="#1296db" p-id="19410" data-spm-anchor-id="a313x.7781069.0.i48" class=""></path><path d="M192 64m32 0l0 0q32 0 32 32l0 128q0 32-32 32l0 0q-32 0-32-32l0-128q0-32 32-32Z" fill="#e2ad23" p-id="19411" data-spm-anchor-id="a313x.7781069.0.i50" class="selected"></path><path d="M64 384m32 0l832 0q32 0 32 32l0 0q0 32-32 32l-832 0q-32 0-32-32l0 0q0-32 32-32Z" fill="#1296db" p-id="19412" data-spm-anchor-id="a313x.7781069.0.i47" class=""></path><path d="M576 320m32 0l0 0q32 0 32 32l0 128q0 32-32 32l0 0q-32 0-32-32l0-128q0-32 32-32Z" fill="#e2ad23" p-id="19413" data-spm-anchor-id="a313x.7781069.0.i49" class="selected"></path><path d="M64 640m32 0l416 0q32 0 32 32l0 0q0 32-32 32l-416 0q-32 0-32-32l0 0q0-32 32-32Z" fill="#1296db" p-id="19414" data-spm-anchor-id="a313x.7781069.0.i46" class=""></path><path d="M320 576m32 0l0 0q32 0 32 32l0 128q0 32-32 32l0 0q-32 0-32-32l0-128q0-32 32-32Z" fill="#e2ad23" p-id="19415" data-spm-anchor-id="a313x.7781069.0.i51" class="selected"></path><path d="M755 842a80 80 0 1 1 80-80 80.09 80.09 0 0 1-80 80z m0-96a16 16 0 1 0 16 16 16 16 0 0 0-16-16z" fill="#e2ad23" p-id="19416" data-spm-anchor-id="a313x.7781069.0.i45" class=""></path><path d="M802.17 960a32 32 0 0 1-31.71-27.65 15.61 15.61 0 0 0-30.92 0 32 32 0 0 1-40.44 26.44 205.13 205.13 0 0 1-86.52-50 32 32 0 0 1 2.64-48.22 15.62 15.62 0 0 0-15.47-26.78 32 32 0 0 1-43.12-21.84 205.52 205.52 0 0 1 0-99.88 32 32 0 0 1 43.12-21.84 15.62 15.62 0 0 0 15.47-26.78 32 32 0 0 1-2.64-48.22 205.13 205.13 0 0 1 86.52-50 32 32 0 0 1 40.44 26.44 15.61 15.61 0 0 0 30.92 0 32 32 0 0 1 40.44-26.44 205.13 205.13 0 0 1 86.52 50 32 32 0 0 1-2.64 48.22 15.62 15.62 0 0 0 15.47 26.78 32 32 0 0 1 43.12 21.84 205.52 205.52 0 0 1 0 99.88 32 32 0 0 1-43.12 21.84 15.62 15.62 0 0 0-15.47 26.78 32 32 0 0 1 2.64 48.22 205.13 205.13 0 0 1-86.52 50 32.15 32.15 0 0 1-8.73 1.21zM755 854.9a79.84 79.84 0 0 1 63.92 32.27 140.2 140.2 0 0 0 12.51-7.25 79.45 79.45 0 0 1 63.91-110.69q0.2-3.62 0.19-7.23t-0.19-7.23a79.45 79.45 0 0 1-63.91-110.69 140.2 140.2 0 0 0-12.51-7.25 79.44 79.44 0 0 1-127.84 0 142.58 142.58 0 0 0-12.51 7.24 79.46 79.46 0 0 1-63.91 110.7q-0.2 3.62-0.19 7.23t0.19 7.23a79.46 79.46 0 0 1 63.91 110.7 142.58 142.58 0 0 0 12.51 7.24A79.84 79.84 0 0 1 755 854.9z" fill="#e2ad23" p-id="19417" data-spm-anchor-id="a313x.7781069.0.i44" class=""></path></svg> -->
				<!-- <svg t="1614768155941" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="15329" data-spm-anchor-id="a313x.7781069.0.i38" width="24" height="24"><path d="M917 160H107c-23.75 0-43 19.25-43 43v618c0 23.75 19.25 43 43 43h810c23.75 0 43-19.25 43-43V203c0-23.75-19.25-43-43-43z m-43 618H150V356h724v422zM150 270v-24h724v24H150z" fill="#1296db" p-id="15330" data-spm-anchor-id="a313x.7781069.0.i39" class="selected"></path><path d="M372.51 738.64c-28.35 0-49.25-5.61-62.68-16.83-13.44-11.22-20.15-29.16-20.15-53.81v-61c0-5.67-0.55-10.29-1.66-13.87-1.11-3.57-2.72-6.29-4.81-8.14-2.1-1.85-4.81-3.08-8.14-3.7-3.33-0.61-7.21-0.92-11.65-0.92v-38.83c4.44 0 8.32-0.31 11.65-0.92 3.33-0.61 6.04-1.85 8.14-3.7 2.09-1.85 3.7-4.5 4.81-7.95 1.11-3.45 1.66-8.01 1.66-13.68v-61.02c0-24.9 6.78-42.9 20.34-53.99 13.56-11.09 34.39-16.64 62.5-16.64v38.83c-6.41 0-11.53 0.43-15.35 1.29-3.83 0.87-6.72 2.53-8.69 4.99-1.98 2.47-3.33 5.73-4.07 9.8-0.74 4.07-1.11 9.31-1.11 15.72v61.02c0 14.79-3.21 25.52-9.61 32.17-6.41 6.66-15.66 11.22-27.73 13.68 12.08 2.47 21.32 7.03 27.73 13.68 6.41 6.66 9.61 17.38 9.61 32.17v61.02c0 6.66 0.37 12.08 1.11 16.27 0.74 4.19 2.22 7.45 4.44 9.8 2.22 2.34 5.23 3.88 9.06 4.62 3.82 0.74 8.69 1.11 14.61 1.11v38.83zM651.49 699.82c5.92 0 10.79-0.37 14.61-1.11 3.83-0.74 6.84-2.28 9.06-4.62 2.22-2.35 3.7-5.61 4.44-9.8 0.74-4.19 1.11-9.61 1.11-16.27V607c0-14.79 3.21-25.52 9.61-32.17 6.41-6.66 15.66-11.22 27.73-13.68-12.08-2.46-21.32-7.03-27.73-13.68-6.41-6.66-9.61-17.38-9.61-32.17v-61.02c0-6.41-0.37-11.65-1.11-15.72-0.74-4.07-2.09-7.33-4.07-9.8-1.97-2.46-4.87-4.13-8.69-4.99-3.82-0.86-8.93-1.29-15.35-1.29v-38.83c28.1 0 48.94 5.55 62.5 16.64 13.56 11.09 20.34 29.09 20.34 53.99v61.02c0 5.67 0.55 10.23 1.66 13.68 1.11 3.46 2.72 6.1 4.81 7.95 2.1 1.85 4.81 3.09 8.14 3.7 3.33 0.62 7.21 0.92 11.65 0.92v38.83c-4.44 0-8.32 0.31-11.65 0.92-3.33 0.62-6.04 1.85-8.14 3.7-2.09 1.85-3.7 4.56-4.81 8.14-1.11 3.58-1.66 8.2-1.66 13.87v61.02c0 24.65-6.71 42.58-20.15 53.81-13.43 11.22-34.33 16.83-62.68 16.83v-38.85z" fill="#e2ad23" p-id="15331" data-spm-anchor-id="a313x.7781069.0.i36" class=""></path><path d="M436.92 671.14c-17.57 0-30.52-3.48-38.84-10.43-8.33-6.95-12.49-18.07-12.49-33.34v-37.81c0-3.51-0.34-6.38-1.03-8.59s-1.68-3.9-2.98-5.04c-1.3-1.15-2.98-1.91-5.04-2.29-2.06-0.38-4.47-0.57-7.22-0.57V549c2.75 0 5.16-0.19 7.22-0.57 2.06-0.38 3.74-1.15 5.04-2.29 1.3-1.15 2.29-2.79 2.98-4.93 0.69-2.14 1.03-4.96 1.03-8.48v-37.81c0-15.43 4.2-26.58 12.6-33.46 8.4-6.88 21.31-10.31 38.73-10.31v24.06c-3.97 0-7.14 0.27-9.51 0.8-2.37 0.54-4.16 1.57-5.39 3.09-1.22 1.53-2.06 3.55-2.52 6.07-0.46 2.52-0.69 5.77-0.69 9.74v37.81c0 9.17-1.99 15.81-5.96 19.94-3.97 4.12-9.7 6.95-17.19 8.48 7.48 1.53 13.21 4.35 17.19 8.48 3.97 4.13 5.96 10.77 5.96 19.94v37.81c0 4.12 0.23 7.48 0.69 10.08 0.46 2.6 1.37 4.62 2.75 6.07 1.37 1.45 3.24 2.41 5.61 2.86 2.37 0.46 5.39 0.69 9.05 0.69v24.07zM587.08 647.08c3.67 0 6.69-0.23 9.05-0.69 2.37-0.46 4.24-1.41 5.61-2.86 1.38-1.45 2.29-3.48 2.75-6.07 0.46-2.6 0.69-5.96 0.69-10.08v-37.81c0-9.17 1.99-15.81 5.96-19.94 3.97-4.12 9.7-6.95 17.19-8.48-7.48-1.53-13.21-4.35-17.19-8.48-3.97-4.13-5.96-10.77-5.96-19.94v-37.81c0-3.97-0.23-7.22-0.69-9.74-0.46-2.52-1.3-4.54-2.52-6.07-1.22-1.53-3.01-2.56-5.39-3.09-2.37-0.53-5.54-0.8-9.51-0.8v-24.06c17.42 0 30.33 3.44 38.73 10.31 8.4 6.88 12.6 18.03 12.6 33.46v37.81c0 3.52 0.34 6.34 1.03 8.48 0.69 2.14 1.68 3.78 2.98 4.93s2.98 1.91 5.04 2.29c2.06 0.38 4.47 0.57 7.22 0.57v24.06c-2.75 0-5.16 0.19-7.22 0.57-2.06 0.38-3.74 1.15-5.04 2.29-1.3 1.15-2.29 2.83-2.98 5.04-0.69 2.22-1.03 5.08-1.03 8.59v37.81c0 15.28-4.16 26.39-12.49 33.34-8.33 6.95-21.27 10.43-38.84 10.43v-24.06z" fill="#e2ad23" p-id="15332" data-spm-anchor-id="a313x.7781069.0.i37" class=""></path></svg> -->
				<svg t="1614769525403" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="40334" data-spm-anchor-id="a313x.7781069.0.i102" width="24" height="24"><path d="M960 128H64a32 32 0 0 0-32 32v416a32 32 0 0 0 32 32h896a32 32 0 0 0 32-32V160a32 32 0 0 0-32-32z m-32 416H96V192h832v352zM896 647.264a32 32 0 0 0-32 32V832H160v-152.736a32 32 0 1 0-64 0V864a32 32 0 0 0 32 32h768a32 32 0 0 0 32-32v-184.736a32 32 0 0 0-32-32z" p-id="40335" data-spm-anchor-id="a313x.7781069.0.i103" class="" fill="#1296db"></path><path d="M685.92 470.368a31.904 31.904 0 0 0 45.728 0l123.232-126.016a31.968 31.968 0 1 0-45.76-44.736l-100.352 102.624-100.384-102.624a32 32 0 0 0-45.76 44.736l123.296 126.016z" p-id="40336" data-spm-anchor-id="a313x.7781069.0.i104" class="selected" fill="#e2ad23"></path></svg>				
				<br/>
				参数控件
				</a>
			</li>
			<li><a title="参数表单" class="headerText" id="sysparams" class="" href="javascript:go('paramFormTop',null);">
			<!-- <svg t="1614768743452" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="26638" data-spm-anchor-id="a313x.7781069.0.i69" width="24" height="24"><path d="M480 832c-51.8 0-102.1-10.2-149.5-30.2-45.7-19.3-86.8-47-122-82.3-35.3-35.3-62.9-76.3-82.3-122C106.2 550.1 96 499.8 96 448s10.2-102.1 30.2-149.5c19.3-45.7 47-86.8 82.3-122 35.3-35.3 76.3-62.9 122-82.3C377.9 74.2 428.2 64 480 64s102.1 10.2 149.5 30.2c45.7 19.3 86.8 47 122 82.3 35.3 35.3 62.9 76.3 82.3 122 20 47.4 30.2 97.7 30.2 149.5s-10.2 102.1-30.2 149.5c-19.3 45.7-47 86.8-82.3 122-35.3 35.3-76.3 62.9-122 82.3-47.4 20-97.7 30.2-149.5 30.2z m0-704c-176.4 0-320 143.6-320 320s143.6 320 320 320 320-143.6 320-320-143.6-320-320-320z" fill="#1296db" p-id="26639" data-spm-anchor-id="a313x.7781069.0.i72" class="selected"></path><path d="M892 960c-8.8 0-17.7-3.6-24-10.8l-184-208c-11.7-13.2-10.5-33.5 2.8-45.2s33.5-10.5 45.2 2.8l184 208c11.7 13.2 10.5 33.5-2.8 45.2-6.1 5.4-13.7 8-21.2 8z" fill="#1296db" p-id="26640" data-spm-anchor-id="a313x.7781069.0.i71" class="selected"></path><path d="M272 592c-17.7 0-32-14.3-32-32V448c0-17.7 14.3-32 32-32s32 14.3 32 32v112c0 17.7-14.3 32-32 32zM376 592c-17.7 0-32-14.3-32-32V288c0-17.7 14.3-32 32-32s32 14.3 32 32v272c0 17.7-14.3 32-32 32zM480 592c-17.7 0-32-14.3-32-32V368c0-17.7 14.3-32 32-32s32 14.3 32 32v192c0 17.7-14.3 32-32 32zM584 592c-17.7 0-32-14.3-32-32V448c0-17.7 14.3-32 32-32s32 14.3 32 32v112c0 17.7-14.3 32-32 32zM688 592c-17.7 0-32-14.3-32-32v-48c0-17.7 14.3-32 32-32s32 14.3 32 32v48c0 17.7-14.3 32-32 32z" fill="#e2ad23" p-id="26641" data-spm-anchor-id="a313x.7781069.0.i70" class=""></path></svg> -->
			<svg t="1614769192315" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="32463" width="24" height="24"><path d="M930.46 337.73H94.54c-34.57 0-62.69-28.12-62.69-62.69V107.85c0-34.57 28.12-62.69 62.69-62.69h835.92c34.57 0 62.69 28.12 62.69 62.69v167.18c0 34.58-28.12 62.7-62.69 62.7zM94.54 86.95c-11.52 0-20.9 9.38-20.9 20.9v167.18c0 11.52 9.38 20.9 20.9 20.9h835.92c11.53 0 20.9-9.38 20.9-20.9V107.85c0-11.52-9.37-20.9-20.9-20.9H94.54z" fill="#e2ad23" p-id="32464" data-spm-anchor-id="a313x.7781069.0.i86" class="selected"></path><path d="M825.97 254.14c-6.57 0-12.78-3.09-16.71-8.36l-62.69-83.59c-6.94-9.23-5.06-22.34 4.18-29.26 9.2-6.96 22.33-5.05 29.24 4.17l45.98 61.31 45.98-61.31c6.94-9.21 20.02-11.11 29.24-4.17 9.24 6.92 11.12 20.02 4.18 29.26l-62.69 83.59a20.862 20.862 0 0 1-16.71 8.36zM522.95 212.34H188.58c-11.54 0-20.9-9.36-20.9-20.9s9.36-20.9 20.9-20.9h334.37c11.55 0 20.9 9.36 20.9 20.9s-9.35 20.9-20.9 20.9zM930.46 645.97H470.7c-11.54 0-20.9-9.35-20.9-20.9s9.36-20.9 20.9-20.9h459.76c11.55 0 20.9 9.35 20.9 20.9s-9.35 20.9-20.9 20.9zM930.46 980.34H94.54c-11.54 0-20.9-9.35-20.9-20.9 0-11.55 9.36-20.9 20.9-20.9h835.92c11.55 0 20.9 9.35 20.9 20.9 0 11.55-9.35 20.9-20.9 20.9zM209.48 750.46c-69.14 0-125.39-56.24-125.39-125.39s56.24-125.39 125.39-125.39 125.39 56.24 125.39 125.39-56.25 125.39-125.39 125.39z m0-208.98c-46.09 0-83.59 37.49-83.59 83.59s37.5 83.59 83.59 83.59 83.59-37.49 83.59-83.59-37.5-83.59-83.59-83.59z" fill="#1296db" p-id="32465" data-spm-anchor-id="a313x.7781069.0.i85" class=""></path></svg>
			<br/>
			参数表单
			</a></li>
			<!-- <li><a title="留白" class="headerText" id="sysparams" class="" href="javascript:createBlank();">
			<svg t="1614769695242" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="45401" data-spm-anchor-id="a313x.7781069.0.i114" width="24" height="24"><path d="M512 0C229.218 0 0 229.218 0 512s229.218 512 512 512 512-229.218 512-512S794.782 0 512 0zM512 944c-238.594 0-432-193.406-432-432S273.406 80 512 80s432 193.406 432 432S750.594 944 512 944z" p-id="45402" data-spm-anchor-id="a313x.7781069.0.i116" class="selected" fill="#1296db"></path><path d="M544 320 704 320 704 480 768 480 768 256 544 256Z" p-id="45403" data-spm-anchor-id="a313x.7781069.0.i115" class="" fill="#e2ad23"></path><path d="M320 480 320 320 480 320 480 256 256 256 256 480Z" p-id="45404" data-spm-anchor-id="a313x.7781069.0.i113" class="" fill="#e2ad23"></path><path d="M480 704 320 704 320 544 256 544 256 768 480 768Z" p-id="45405" data-spm-anchor-id="a313x.7781069.0.i112" class="" fill="#e2ad23"></path><path d="M704 544 704 704 544 704 544 768 768 768 768 544Z" p-id="45406" data-spm-anchor-id="a313x.7781069.0.i111" class="" fill="#e2ad23"></path></svg>
			<br/>
			留白
			</a></li> -->
			<!-- <li style="float:right;width:30%;">
			</li> -->
		</ul>
		<div id="propertiesTitle" style="padding-left:10px;font-size:20px;background-color: #232545;left:70%;width:30%;color:white;height: 57px;float: right;line-height: 57px">页面</div>
	</nav>
</div>
<div class="out" style="width:70%;">
	<div style="width:100%;height: 100%;overflow-y: scroll;">
	      <div class="main container-fluid row-fluid gridster">
	     	<ul id="contents" class="dtable" style="width:100%;height:100%">
	     	
	     	
	      	</ul>
	    </div>
	</div>
</div>

<div class="out east" id="propertiesOut" style="padding-left:10px;padding-right:10px;width:30%;left:70%;background-color: #646d97;overflow-y: scroll;">
	<div id="propertiesContents">
		<div class="dbd-west-part" id="dbd-west-top" style="z-index:3;">
			<div id="pageStyles">
				<div class="propSubTitle">页面底色</div>
				<input id="page_bg" type="text" value="" autocomplete="off"/>
				<br/><span style="color:white" id="color"></span>
				<script>showColorBoard(0, $('#page_bg'));</script>
				
				<div class="propSubTitle">背景图片</div>
				
				<div class="label">背景图上传</div><button type="button" class="btn" onclick="chooseImage(0);return false;">上传图片</button>
				<div id="pageImageSelectOut" class="imageList"></div>
				<div class="propSubTitle">清空背景</div>
				<br/><button type="button" class="btn" onclick="defaultBG(0);return false;">清空背景色和图片</button>
			</div>
			
		</div>
		<div class="dbd-west-part" id="dbd-west-report" style="z-index:3;display:none">
			<ul class="nav nav-tabs">
			    <li class="active"><a href="#data" data-toggle="tab">数据</a></li>
			    <li><a href="#areaStyles" data-toggle="tab">
			    <svg t="1594381151738" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="5926" width="16" height="16"><path d="M106.096424 807.407299c1.399953 1.099963 3.599879 0.199993 3.799872-1.599946 0.29999-3.099896 0.59998-6.299788 0.699977-9.49968 0.499983-10.699639 1.899936-21.399279 4.299855-31.998921 0.199993-0.89997-0.199993-1.899936-0.89997-2.399919-11.499612-7.799737-19.199353-23.999191-18.299383-40.898622 1.19996-21.699269 13.799535-49.298339 27.699066-61.397931 11.499612-9.899666 29.399009-9.299687 43.598531 0.199994 0.999966 0.699976 2.299922 0.499983 2.999899-0.399987 7.299754-8.499714 15.299484-16.89943 23.899195-25.099154 36.598767-34.798827 71.597587-54.198173 75.497455-56.298103l19.099357-10.399649c0.699976-0.399987 1.099963-1.099963 1.199959-1.899936 1.299956-16.299451 7.799737-31.198949 18.899363-42.598565 15.899464-16.299451 39.098682-23.499208 63.697853-19.699336 5.199825 0.799973 10.39965 2.099929 15.599475 3.899869 1.499949 0.499983 3.099896-0.699976 3.099895-2.299923-0.799973-25.099154 11.999596-42.198578 19.59934-52.298237l1.399953-1.899936c0.099997-0.099997 0.099997-0.199993 0.199993-0.199993l1.599946-1.699943C461.884434 399.221056 539.981802 321.223684 619.979106 243.126316c1.499949-1.499949 0.399987-4.099862-1.699943-3.999865-18.499377 1.19996-40.398639-4.199858-57.298069-15.399481-25.699134-17.099424-45.898453-46.798423-44.698493-66.097772 1.299956-19.399346 32.098918-43.898521 68.397695-54.398167 36.398773-10.599643 71.49759-2.899902 77.997371 17.099424 6.499781 20.099323 12.699572 47.998382 14.099525 62.2979v0.099997c0.199993 1.999933 2.499916 2.899902 3.899868 1.499949 69.197668-66.897745 134.295474-128.49567 176.194062-165.994406 1.399953-1.19996 0.89997-3.399885-0.899969-3.999865-127.795693-38.398706-311.889489 4.899835-493.783359 81.89724C92.696876 210.427418-38.298709 451.519293 9.79967 652.312526c15.899464 66.297766 49.198342 117.596037 96.296754 155.094773z m235.292071-588.080181c16.799434-12.999562 48.498366-14.999494 70.297631-4.599845 21.799265 10.499646 39.798659 31.898925 40.198645 47.698393 0.199993 15.699471-13.599542 33.098885-30.598969 38.598699-17.099424 5.499815-38.698696 9.49968-48.198375 8.699707-9.49968-0.799973-27.399077-16.199454-39.798659-33.998854-12.399582-17.899397-8.699707-43.398537 8.099727-56.3981z m-171.894207 74.597486c0.499983-0.29999 1.099963-0.499983 1.599946-0.399986l7.799737 0.999966 8.099727 0.999966c0.399987 0.099997 0.799973 0.199993 1.099963 0.499984 30.898959 23.999191 55.298136 53.798187 54.098177 66.697752-1.099963 12.999562-12.799569 28.899026-25.899127 35.398807-13.099559 6.499781-35.398807 5.499815-49.498332-2.199926-14.299518-7.699741-25.899127-29.499006-25.899127-48.298372 0-18.599373 12.799569-42.398571 28.599036-53.698191z m-91.39692 183.9938c11.099626-18.39938 33.998854-28.099053 50.498298-21.599272s25.999124 40.298642 20.899296 74.997472c-5.199825 34.698831-20.699302 61.097941-34.398841 58.598025-13.899532-2.499916-32.398908-21.099289-41.198611-41.498601-8.799703-20.399313-6.899767-52.098244 4.199858-70.497624zM830.772002 444.119543c-2.499916-2.599912-4.699842-5.099828-6.699774-7.599744-0.999966-1.19996-2.799906-1.19996-3.699876 0.099996-10.09966 13.799535-20.099323 27.399077-29.998989 40.698629-0.799973 1.099963-0.499983 2.699909 0.699977 3.399885 14.299518 8.29972 25.199151 19.999326 30.798962 34.498838 18.499377 47.798389-25.299147 109.096323-97.796704 136.995383-29.798996 11.499612-59.797985 15.499478-85.997102 12.999562-0.59998-0.099997-1.099963 0.099997-1.599946 0.399986-12.999562 9.19969-29.998989 18.09939-51.098278 19.59934-1.699943 0.099997-2.699909 1.899936-1.899936 3.399885 6.199791 11.699606 9.79967 23.899195 10.799636 35.89879 0.099997 0.999966 0.699976 1.799939 1.599946 1.999933 17.49941 5.599811 29.299013 15.599474 23.199218 31.398942-1.099963 2.799906 0 0-5.499814 10.399649l-5.399818 10.299653s0 0.099997-0.099997 0.099997c-7.899734 18.299383-24.499174 34.098851-37.198746 35.698797-11.299619 1.299956-28.299046-1.099963-39.898656-5.399818-1.599946-0.59998-3.199892 0.59998-3.099895 2.299922 1.099963 21.999259-1.799939 43.098548-8.8997 62.89788-0.59998 1.599946 0.799973 3.299889 2.499915 3.099896 3.999865-0.59998 8.099727-1.19996 12.199589-1.79994C817.272457 832.00647 1003.966165 645.912742 1019.26565 585.114791c6.299788-25.099154 12.999562-56.798086-27.999057-99.496647-40.898622-42.398571-109.296317 11.599609-160.494591-41.498601z" p-id="5927" fill="#ffffff"></path><path d="M288.390281 613.213844s-132.695528 72.09757-137.795356 184.993765c-5.199825 112.896195-112.996192 194.993428-148.894982 205.293082-35.89879 10.299653 524.082338 33.498871 484.383675-206.993024-0.099997-0.499983-0.29999-0.999966-0.699976-1.299956l-196.993361-181.993867zM534.98197 689.811263c20.399313 19.799333 25.599137 47.698393 11.59961 62.097907-14.099525 14.499511-41.998585 10.09966-62.497894-9.699673l-135.295441-128.995653c-20.399313-19.799333-25.599137-47.698393-11.599609-62.097907 14.099525-14.499511 41.998585-10.09966 62.497894 9.699673l135.29544 128.995653z m469.284185-678.377138c-36.598767-24.799164-69.497658-2.599912-83.797176 5.499814-0.099997 0-0.099997 0.099997-0.099997 0.099997-42.698561 28.699033-345.888343 323.389101-477.783898 459.584511l-0.199993 0.199994c-16.099457 21.499275-26.899093 38.398706 50.698292 115.896094 65.497793 65.497793 96.096761 61.297934 129.195645 32.998888 0.099997 0 0.099997-0.099997 0.199994-0.099997 55.398133-55.49813 290.690203-383.487076 377.587275-508.58286 14.199521-20.499309 43.498534-78.897341 4.199858-105.596441z" p-id="5928" fill="#ffffff"></path></svg>
			    样式</a></li>
			</ul>
			<div id="myTabContent" class="tab-content">
   				<div class="tab-pane fade in active" id="data">
   					<div class="propSubTitle">数据集</div>
					<p class="">
			    	<ul class="nav nav-pills nav-stacked">
			    		<li>
			    			<button type="button" class="btn btn-primary" onclick="manageDataSet();return false;">数据集配置</button>
			    			<button type="button" class="btn btn-primary" onclick="dsParameterButtonEvent();return false;">数据集参数</button>
			    		</li>
			    		<li>
			    			<select id="selectDs" style="width:50%;padding:4px;margin-bottom:0px">
								<option value="">选择报表数据集</option>
							</select>
			    		</li>
					</ul>
					</p>
					<div style="display:flex">
						<div style="width:50%">
							<div style="text-align: center;">
								<div class="propSubTitle">拖拽字段
								<a id='acfBut' style='font-weight: bolder;font-size:15px;float:right;cursor: no-drop'>
								<img src="../img/guide/9.png" title="添加计算字段">
								</a>
								</div>
								
								<div id='contentDiv' class="ztree">
									<p>请选择数据集</p>
								</div>
								
								<div id="items" style="width:220px;overflow: auto;max-height: 400px;display:none">
									<p>请选择数据集</p>
								</div>
					   		 </div>
						</div>
						<div style="width:50%">
							<div class="propSubTitle" style="text-align: center;">图表内容</div>
						    	<div style="cursor:pointer;" id="allReportStyles" class="allReportStyles">
								
								</div>
								<div id="modelReportFields">
								
								</div>
						   		<div id='gridTable' class="gridTable">
								</div>
							</div>
					</div>
 				</div>
 				<div class="tab-pane" id="areaStyles">
 					<!-- <div class="propSubTitle">高度</div>
					<input type="text" style="float:left;" class="resetHeight" id="areaHeight" placeholder="重设高度">
					
					<button id="submit" style="float:left;" onclick="submitAreaSize();">应用</button> 
					<br/>
					-->
					
					<div class="propSubTitle">边框</div>
					<table>
				    	<tr><td class="cw">边框宽度:</td><td class="cw"><input style="width:56px" type="text" id="setBorderWidth"/>px</td></tr>
				    	<tr><td class="cw">边框颜色:</td><td><input id="border_bg" type="text" value="" autocomplete="off"/></td></tr>
		    		</table>
		    		
		    		<div class="propSubTitle">标题栏</div>
		    		<button type="button" class="btn" onclick="switchShowTitle();return false;">隐藏标题</button><span class="hideTitle checkMark cw" style="display:none">&nbsp;√</span>
		    		
		    		<div class="propSubTitle">背景</div>
		    		<div class="label">底色</div>
					<input id="area_bg" type="text" value="" autocomplete="off"/>
					<br/>
					<div class="label">背景图上传</div><button type="button" class="btn" onclick="chooseImage(1);return false;">上传图片</button>
					<div id="reportImageSelectOut" class="imageList"></div>
					<br/><br/>
					<div class="label">清空背景</div>
					<button type="button" class="btn" onclick="defaultBG(1);return false;">清空背景色和图片</button>
 				</div>
 				<!-- tab end -->
			</div>
			
			
     </div>
	     <div class="side dbd-west-part" id="dbd-west-editor" style="z-index:3;display:none">
	     
	     	<ul class="nav nav-tabs">
			    <li class="active"><a href="#t1" data-toggle="tab">配置</a></li>
			    <li><a href="#t2" data-toggle="tab">
			    <svg t="1594381151738" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="5926" width="16" height="16"><path d="M106.096424 807.407299c1.399953 1.099963 3.599879 0.199993 3.799872-1.599946 0.29999-3.099896 0.59998-6.299788 0.699977-9.49968 0.499983-10.699639 1.899936-21.399279 4.299855-31.998921 0.199993-0.89997-0.199993-1.899936-0.89997-2.399919-11.499612-7.799737-19.199353-23.999191-18.299383-40.898622 1.19996-21.699269 13.799535-49.298339 27.699066-61.397931 11.499612-9.899666 29.399009-9.299687 43.598531 0.199994 0.999966 0.699976 2.299922 0.499983 2.999899-0.399987 7.299754-8.499714 15.299484-16.89943 23.899195-25.099154 36.598767-34.798827 71.597587-54.198173 75.497455-56.298103l19.099357-10.399649c0.699976-0.399987 1.099963-1.099963 1.199959-1.899936 1.299956-16.299451 7.799737-31.198949 18.899363-42.598565 15.899464-16.299451 39.098682-23.499208 63.697853-19.699336 5.199825 0.799973 10.39965 2.099929 15.599475 3.899869 1.499949 0.499983 3.099896-0.699976 3.099895-2.299923-0.799973-25.099154 11.999596-42.198578 19.59934-52.298237l1.399953-1.899936c0.099997-0.099997 0.099997-0.199993 0.199993-0.199993l1.599946-1.699943C461.884434 399.221056 539.981802 321.223684 619.979106 243.126316c1.499949-1.499949 0.399987-4.099862-1.699943-3.999865-18.499377 1.19996-40.398639-4.199858-57.298069-15.399481-25.699134-17.099424-45.898453-46.798423-44.698493-66.097772 1.299956-19.399346 32.098918-43.898521 68.397695-54.398167 36.398773-10.599643 71.49759-2.899902 77.997371 17.099424 6.499781 20.099323 12.699572 47.998382 14.099525 62.2979v0.099997c0.199993 1.999933 2.499916 2.899902 3.899868 1.499949 69.197668-66.897745 134.295474-128.49567 176.194062-165.994406 1.399953-1.19996 0.89997-3.399885-0.899969-3.999865-127.795693-38.398706-311.889489 4.899835-493.783359 81.89724C92.696876 210.427418-38.298709 451.519293 9.79967 652.312526c15.899464 66.297766 49.198342 117.596037 96.296754 155.094773z m235.292071-588.080181c16.799434-12.999562 48.498366-14.999494 70.297631-4.599845 21.799265 10.499646 39.798659 31.898925 40.198645 47.698393 0.199993 15.699471-13.599542 33.098885-30.598969 38.598699-17.099424 5.499815-38.698696 9.49968-48.198375 8.699707-9.49968-0.799973-27.399077-16.199454-39.798659-33.998854-12.399582-17.899397-8.699707-43.398537 8.099727-56.3981z m-171.894207 74.597486c0.499983-0.29999 1.099963-0.499983 1.599946-0.399986l7.799737 0.999966 8.099727 0.999966c0.399987 0.099997 0.799973 0.199993 1.099963 0.499984 30.898959 23.999191 55.298136 53.798187 54.098177 66.697752-1.099963 12.999562-12.799569 28.899026-25.899127 35.398807-13.099559 6.499781-35.398807 5.499815-49.498332-2.199926-14.299518-7.699741-25.899127-29.499006-25.899127-48.298372 0-18.599373 12.799569-42.398571 28.599036-53.698191z m-91.39692 183.9938c11.099626-18.39938 33.998854-28.099053 50.498298-21.599272s25.999124 40.298642 20.899296 74.997472c-5.199825 34.698831-20.699302 61.097941-34.398841 58.598025-13.899532-2.499916-32.398908-21.099289-41.198611-41.498601-8.799703-20.399313-6.899767-52.098244 4.199858-70.497624zM830.772002 444.119543c-2.499916-2.599912-4.699842-5.099828-6.699774-7.599744-0.999966-1.19996-2.799906-1.19996-3.699876 0.099996-10.09966 13.799535-20.099323 27.399077-29.998989 40.698629-0.799973 1.099963-0.499983 2.699909 0.699977 3.399885 14.299518 8.29972 25.199151 19.999326 30.798962 34.498838 18.499377 47.798389-25.299147 109.096323-97.796704 136.995383-29.798996 11.499612-59.797985 15.499478-85.997102 12.999562-0.59998-0.099997-1.099963 0.099997-1.599946 0.399986-12.999562 9.19969-29.998989 18.09939-51.098278 19.59934-1.699943 0.099997-2.699909 1.899936-1.899936 3.399885 6.199791 11.699606 9.79967 23.899195 10.799636 35.89879 0.099997 0.999966 0.699976 1.799939 1.599946 1.999933 17.49941 5.599811 29.299013 15.599474 23.199218 31.398942-1.099963 2.799906 0 0-5.499814 10.399649l-5.399818 10.299653s0 0.099997-0.099997 0.099997c-7.899734 18.299383-24.499174 34.098851-37.198746 35.698797-11.299619 1.299956-28.299046-1.099963-39.898656-5.399818-1.599946-0.59998-3.199892 0.59998-3.099895 2.299922 1.099963 21.999259-1.799939 43.098548-8.8997 62.89788-0.59998 1.599946 0.799973 3.299889 2.499915 3.099896 3.999865-0.59998 8.099727-1.19996 12.199589-1.79994C817.272457 832.00647 1003.966165 645.912742 1019.26565 585.114791c6.299788-25.099154 12.999562-56.798086-27.999057-99.496647-40.898622-42.398571-109.296317 11.599609-160.494591-41.498601z" p-id="5927" fill="#ffffff"></path><path d="M288.390281 613.213844s-132.695528 72.09757-137.795356 184.993765c-5.199825 112.896195-112.996192 194.993428-148.894982 205.293082-35.89879 10.299653 524.082338 33.498871 484.383675-206.993024-0.099997-0.499983-0.29999-0.999966-0.699976-1.299956l-196.993361-181.993867zM534.98197 689.811263c20.399313 19.799333 25.599137 47.698393 11.59961 62.097907-14.099525 14.499511-41.998585 10.09966-62.497894-9.699673l-135.295441-128.995653c-20.399313-19.799333-25.599137-47.698393-11.599609-62.097907 14.099525-14.499511 41.998585-10.09966 62.497894 9.699673l135.29544 128.995653z m469.284185-678.377138c-36.598767-24.799164-69.497658-2.599912-83.797176 5.499814-0.099997 0-0.099997 0.099997-0.099997 0.099997-42.698561 28.699033-345.888343 323.389101-477.783898 459.584511l-0.199993 0.199994c-16.099457 21.499275-26.899093 38.398706 50.698292 115.896094 65.497793 65.497793 96.096761 61.297934 129.195645 32.998888 0.099997 0 0.099997-0.099997 0.199994-0.099997 55.398133-55.49813 290.690203-383.487076 377.587275-508.58286 14.199521-20.499309 43.498534-78.897341 4.199858-105.596441z" p-id="5928" fill="#ffffff"></path></svg>
			    样式</a></li>
			</ul>
			<div id="myTabContent" class="tab-content">
	 			<div class="tab-pane fade in active" id="t1">
	 				<div style="display:flex">
			     		<div style="width:50%">
			     			<div class="propSubTitle">增加参数控件</div>
							<div class="container-fluid">
							<div class="accordion" id="accordion2">
								<div class="accordion-group2">
									<div class="accordion-heading">
										<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseTwo">
											数字
										</a>
									</div>
									<div id="collapseTwo" class="accordion-body collapse">
										<div class="accordion-inner">
											<ul style="list-style: none">
											<li>
												<div class="addEditorButton addEditorButton-normal" type="slider"><img class="editor_icon" src="../img/guide/dashboard/slider.png"/>&nbsp;滑块</div>
											</li>
											<li>
												<div class="addEditorButton addEditorButton-normal" type="spinner"><img class="editor_icon" src="../img/guide/dashboard/spinner.png"/>&nbsp;微调器</div>
											</li>
											</ul>	
										</div>
									</div>
								</div>
								<div class="accordion-group2">
									<div class="accordion-heading">
										<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseOne">
											通用
										</a>
									</div>
									<div id="collapseOne" class="accordion-body collapse" style="height: 0px; ">
										<div class="accordion-inner">
											<div class="addEditorButton addEditorButton-normal" type="input"><img class="editor_icon" src="../img/guide/dashboard/textbox.png"/>&nbsp;编辑器</div>
										</div>
									</div>
								</div>
								<div class="accordion-group2">
									<div class="accordion-heading">
										<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseThree">
											时间
										</a>
									</div>
									<div id="collapseThree" class="accordion-body collapse">
										<div class="accordion-inner">
											<ul style="list-style: none">
											<li>
												<div class="addEditorButton addEditorButton-normal" type="date"><img class="editor_icon" src="../img/guide/dashboard/date.png"/>&nbsp;日期</div>
											</li>
											<li>
												<div class="addEditorButton addEditorButton-normal" type="datetime"><img class="editor_icon" src="../img/guide/dashboard/date_time.png"/>&nbsp;日期时间</div>
											</li>
											</ul>
										</div>
									</div>
								</div>
								<div class="accordion-group2">
									<div class="accordion-heading">
										<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseFour">
											字段选择
										</a>
									</div>
									<div id="collapseFour" class="accordion-body collapse">
										<div class="accordion-inner">
											<ul style="list-style: none">
											<li>
											<div class="addEditorButton addEditorButton-normal" type="downdrawer"><img class="editor_icon" src="../img/guide/dashboard/ddw.png"/>&nbsp;值下拉</div>
											</li>
											</ul>
										</div>
									</div>
								</div>
							</div>
						</div>
			     			
			     		</div>
			     		<div style="width:50%" id="dbd-west-editor-detail">
			     			
			     		</div>
			   		</div>
	 			</div>
	 			<div class="tab-pane" id="t2">
	 				<div>
	 					<!-- <div class="propSubTitle">高度</div>
						<input type="text" style="float:left;" class="resetHeight" id="eAreaHeight" placeholder="重设高度">
						
						<button id="submit" style="float:left;" onclick="submitEditorAndPFAreaSize();">应用</button>
						
						<br/> -->
						<div class="propSubTitle">边框</div>
						<table>
					    	<tr><td class="cw">边框宽度:</td><td class="cw"><input style="width:56px" type="text" id="setBorderWidth2"/>px</td></tr>
					    	<tr><td class="cw">边框颜色:</td><td><input id="border_bg2" type="text" value="" autocomplete="off"/></td></tr>
			    		</table>
			    		
			    		<div class="propSubTitle">标题栏</div>
			    		<button type="button" class="btn" onclick="switchShowTitle();return false;">隐藏标题</button><span class="hideTitle checkMark cw" style="display:none">&nbsp;√</span>
			    		
			    		<div class="propSubTitle">背景</div>
			    		<div class="label">底色</div>
						<input id="area_bg2" type="text" value="" autocomplete="off"/>
						<br/>
						<div class="label">背景图上传</div><button type="button" class="btn" onclick="chooseImage(1);return false;">上传图片</button>
						<div id="editorImageSelectOut" class="imageList"></div>
						<br/><br/>
						<div class="label">清空背景</div>
						<button type="button" class="btn" onclick="defaultBG(1);return false;">清空背景色和图片</button>
					</div>
	 			</div>
	  		</div>
	     
	     	<script>
		     	function submitAreaSize(heightInput){
		     		if(heightInput == null) heightInput = $('#areaHeight');
					if(heightInput.val() != null && heightInput.val().length > 0){
						var height = NaN;
						try{
							height = parseInt(heightInput.val());
						}catch(e){
							height = NaN;
						}
						if(!isNaN(height)){
							var area = controlUtil.getAreaByReport(currArea.attr('confname'))
							area.height = height+'px';
							currArea.parent().css('height',height);
						}
					}
					redefineFrameHeight(currArea.attr('confname'));
				}
		     	
		     	function submitEditorAndPFAreaSize(){
		     		submitAreaSize($('#eAreaHeight'));
		     	}
	     	</script>
	     		
	    	</div>
	</div>
</div>


</div>

<!-- buttons -->
<div style="display:none;">
	<iframe id='hiddenFrame' name='hiddenFrame' height="100px" width="100px"></iframe>
	<form id=downloadForm method=post ACTION="<%=cp%>/servlet/dataSphereServlet?action=11" target=hiddenFrame>
		<input type=hidden name=path id=path value="">
		<input type=hidden name=content id=content value="">
		<input type=hidden name=mode id=mode value="">
	</form>
</div>
<div id="confFieldFloat" style="display:none;background-color:#F3F3F3;border: 1px solid #CCC;">
	<div seq="17" style="margin:2px 5px;" onclick="aly.confField.aggr('')"><img src="<%=guideDir %>img/guide/42.png" aggr='' style="vertical-align:-4px;visibility:hidden;"/><%=GuideMessage.get(request).getMessage("guide.web18")%></div>
	<div seq="15" style="margin:2px 5px;" onclick="aly.confField.aggr('sum')"><img src="<%=guideDir %>img/guide/42.png" aggr='sum' style="vertical-align:-4px;visibility:hidden;"/><%=GuideMessage.get(request).getMessage("guide.web19")%></div>
	<div seq="14" style="margin:2px 5px" onclick="aly.confField.aggr('count')"><img src="<%=guideDir %>img/guide/42.png" aggr='count' style="vertical-align:-4px;visibility:hidden;" /><%=GuideMessage.get(request).getMessage("guide.web20")%></div>
	<div seq="13" style="margin:2px 5px;" onclick="aly.confField.aggr('max')"><img src="<%=guideDir %>img/guide/42.png" aggr='max' style="vertical-align:-4px;visibility:hidden;" /><%=GuideMessage.get(request).getMessage("guide.web21")%></div>
	<div seq="12" style="margin:2px 5px;" onclick="aly.confField.aggr('min')"><img src="<%=guideDir %>img/guide/42.png" aggr='min' style="vertical-align:-4px;visibility:hidden;" /><%=GuideMessage.get(request).getMessage("guide.web22")%></div>
	<div seq="11" style="margin:2px 5px;" onclick="aly.confField.aggr('avg')"><img src="<%=guideDir %>img/guide/42.png" aggr='avg' style="vertical-align:-4px;visibility:hidden;" /><%=GuideMessage.get(request).getMessage("guide.web23")%></div>
	<div seq="10" style="margin:2px 5px;" onclick="aly.confField.aggr('countd')"><img src="<%=guideDir %>img/guide/42.png" aggr='countd' style="vertical-align:-4px;visibility:hidden;" /><%=GuideMessage.get(request).getMessage("guide.web24")%></div>
	<span seq="9" style="font-size:1px;display:block;width:100%;border-top:1px solid #AAA;margin:3px 0;"></span>
	<div seq="1" style="margin:2px 5px;" onclick="aly.confField.order(1)"><img src="<%=guideDir %>img/guide/42.png"  order="1" style="vertical-align:-4px;visibility:hidden;"/><%=GuideMessage.get(request).getMessage("guide.web25")%></div>
	<div seq="2" style="margin:2px 5px" onclick="aly.confField.order(2)"><img src="<%=guideDir %>img/guide/42.png"  order="2" style="vertical-align:-4px;visibility:hidden;" /><%=GuideMessage.get(request).getMessage("guide.web26")%></div>
	<div seq="3" style="margin:2px 5px;" onclick="aly.confField.order(0)"><img src="<%=guideDir %>img/guide/42.png" style="vertical-align:-4px;visibility:hidden;" order="0"/><%=GuideMessage.get(request).getMessage("guide.web27")%></div>
	<span seq="4" style="font-size:1px;display:block;width:100%;border-top:1px solid #AAA;margin:3px 0;"></span>
	<div seq="5" style="margin:2px 5px;" onclick="aly.confField.edit()"><img src="<%=guideDir %>img/guide/48.png" style="vertical-align:-3px;" /><%=GuideMessage.get(request).getMessage("guide.web28")%></div>
	<div seq="16" style="margin:2px 5px;" onclick="aly.confField.where(1)"><img src="<%=guideDir %>img/guide/7.png" style="vertical-align:-3px;" /><%=GuideMessage.get(request).getMessage("guide.web29")%></div>
	<div seq="19" style="margin:2px 5px;" onclick="aly.confField.where(2)"><img src="<%=guideDir %>img/guide/49.png" style="vertical-align:-3px;" /><%=GuideMessage.get(request).getMessage("guide.web30")%></div>
	<div seq="20" style="margin:2px 5px;" onclick="aly.confField.rela()"><img src="<%=guideDir %>img/guide/16.png" style="vertical-align:-3px;" /><%=GuideMessage.get(request).getMessage("guide.web31")%></div>
	<div seq="6" style="margin:2px 5px;" onclick="aly.confField.format()"><img src="<%=guideDir %>img/guide/50.png" style="vertical-align:-3px;padding-right:1px;width:15px;height:16px;" /><%=GuideMessage.get(request).getMessage("guide.web32")%></div>
	<div seq="18" style="margin:2px 5px;" onclick="aly.confField.editStyle()"><img src="<%=guideDir %>img/guide/51.png" style="vertical-align:-3px;padding-right:1px;width:15px;height:16px;" /><%=GuideMessage.get(request).getMessage("guide.web33")%></div>
	<span seq="7" style="font-size:1px;display:block;width:100%;border-top:1px solid #AAA;margin:3px 0;"></span>
	<div seq="8" style="color:red;margin:2px 5px;" onclick="aly.confField.del()"><img src="<%=guideDir %>img/guide/13.png" style="vertical-align:-3px;" /><%=GuideMessage.get(request).getMessage("guide.web34")%></div>
	<div seq="21" style="color:red;margin:2px 5px;" onclick="aly.paramDel()"><img src="<%=guideDir %>img/guide/13.png" style="vertical-align:-3px;" /><%=GuideMessage.get(request).getMessage("guide.web34")%></div>
	<div seq="22" style="margin:2px 5px;" onclick="aly.confField.params_where(1)"><img src="<%=guideDir %>img/guide/7.png" style="vertical-align:-3px;" /><%=GuideMessage.get(request).getMessage("guide.web29")%></div>
</div>
<div id="calcFieldFloat" style="display:none;background-color:#F3F3F3;border: 1px solid #CCC;">
	<div seq="1" style="margin:2px 5px;" onclick="aly.calcField.edit()"><img src="<%=guideDir %>img/guide/31.png" style="vertical-align:-3px;" /><%=GuideMessage.get(request).getMessage("guide.web28")%></div>
	<div seq="2" style="color:red;margin:2px 5px;" onclick="aly.calcField.del()"><img src="<%=guideDir %>img/guide/13.png" style="vertical-align:-3px;" /><%=GuideMessage.get(request).getMessage("guide.web34")%></div>
</div>
</body>
<script>
var previewDbd = false;
var finalView = false;
guideConf.openDOlap = "<%=isOpenDOlap%>";
var olapFile = "<%=olap.replaceAll("\\r", "").replaceAll("\\n", "")%>";
if (guideConf.guideDir == '') guideConf.guideDir = "/raqsoft/guide/";
if (guideConf.guideDir.substring(guideConf.guideDir.length-1) != '/') guideConf.guideDir = guideConf.guideDir+"/";
var selfUrl = window.location.href;
if (selfUrl.indexOf('?')>=0) selfUrl = selfUrl.substring(0,selfUrl.indexOf('?'));

if (guideConf.grpxSourcePage=='') guideConf.grpxSourcePage = selfUrl;
else guideConf.grpxSourcePage = "<%=cp%>/"+guideConf.grpxSourcePage;
guideConf.grpxSourcePage = guideConf.grpxSourcePage.replaceAll("//","/");

if (guideConf.grpxDataPage=='') guideConf.grpxDataPage = selfUrl;
else guideConf.grpxDataPage = "<%=cp%>/"+guideConf.grpxDataPage;
guideConf.grpxDataPage = guideConf.grpxDataPage.replaceAll("//","/");

if (guideConf.grpxReportPage=='') guideConf.grpxReportPage = selfUrl;
else guideConf.grpxReportPage = "<%=cp%>/"+guideConf.grpxReportPage;
guideConf.grpxReportPage = guideConf.grpxReportPage.replaceAll("//","/");

if (guideConf.simplePage=='') guideConf.simplePage = selfUrl;
else guideConf.simplePage = "<%=cp%>/"+guideConf.simplePage;
guideConf.simplePage = guideConf.simplePage.replaceAll("//","/");

if (guideConf.reportPage=='') guideConf.reportPage = selfUrl;
else guideConf.reportPage = "<%=cp%>/"+guideConf.reportPage;
guideConf.reportPage = guideConf.reportPage.replaceAll("//","/");

guideConf.dct="<%=dct%>";
guideConf.vsb="<%=vsb%>";
guideConf.defaultWidth = 25;
guideConf.defaultHeight = 8;
guideConf.reSort = "yes";
guideConf.params = {};
guideConf.fileDataFolderOnServer = "WEB-INF/files/fileData/";
guideConf.queryType = "all";
guideConf.dataPage = "raqsoft/guide/jsp/data.jsp";
guideConf.filter="default";
guideConf.scanRow=100;//自动判断序表字段的数据类型时，扫描多少行数据
guideConf.autoReloadDimDataOnServer = 'yes';
var existFileDatas = [];

guideConf.reportPage = "showReport_d.jsp";
var sqlDatasets = [
	{
		sqlId:"sqlId1"
		,dataSource:"DataLogic" //如果服务器管理这些，js里就不用定义
		,sql:"" //如果服务器管理这些，js里就不用定义
		,fields:null
	}
]
/* 这些参数可以控制页面的初始状态 */
guideConf.sqlId="<%=sqlId%>";

$('#contentDiv').css('height',parseInt($('.side').css('height'))/3+"px");
$('#confFieldFloat').find('div').css('cursor','pointer');
$('.outerSelection').mouseover(function(e){$(e.target).css('background-color','opera');});
$('.outerSelection').mouseout(function(e){$(e.target).css('background-color','');});
$('#analyseConf4').css('height',parseInt($('.side').css('height'))/3+"px");
$('.tab-pane.in').append($('#util'));
/* $('a[data-toggle="tab"]').on('shown.bs.tab',function(e){
	var tabContentId = $(e.target).attr('href');
	if(tabContentId == '#choose') {
		createRpxType = 2;
		$('#allReportStyles').before($('#util'));
	} else {
		createRpxType = 1;
		$('#gridTable').before($('#util'));
	}
	if(currDiv) {
		if(checkHasReport(currDiv)) divTableControl.changeChoosedDiv(currDiv);
	}
}); */


//gridster
var gridster;
var widthUnit = (1/(defaultDivWidth))*parseInt($("#contents").css('width'))-divide-1;

function refreshGS(){
	gridsterNotExsit = false;
	gridster = $("#contents").gridster({
        widget_margins: [divide, divide],
        widget_base_dimensions: [ widthUnit , defaultDivHeight],
        helper:'clone',
        resize:{
        	enabled:true,
        	stop:function(e, ui, widget){
        		var newHeight = parseInt($(widget[0]).css('height')) - rmbarHeight;
        		redefineFrameHeight($(widget[0]).find('.singleArea').attr("confname"));
        		closeReportMengBan();
        	},
        	start:function(e, ui, widget){
        		//$(widget[0]).find('.divCell');
        		console.log(ui);
        		activeReportMengBan();
        	}
        }
	}).data('gridster');
}

</script>
</html>