<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/raqsoftAnalyse.tld" prefix="raqsoft" %>
<%@ page import="com.raqsoft.guide.resource.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>仪表盘</title>
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
boolean isOpenDOlap = false;
if(olap.length()>0) isOpenDOlap = true;
String dataSource = request.getParameter( "dataSource" );
if (dataSource == null) dataSource = "";
String ql = request.getParameter( "ql" );
if (ql == null) ql = "";
String dfxFile = request.getParameter( "dfxFile" );
if (dfxFile == null) dfxFile = "";
String dfxScript = request.getParameter( "dfxScript" );
if (dfxScript == null) dfxScript = "";
String dfxParams = request.getParameter( "dfxParams" );
if (dfxParams == null) dfxParams = "";
String inputFiles = request.getParameter( "inputFiles" );
if (inputFiles == null) inputFiles = "";
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
<script>
	var p_view = "<%=view%>";
	var p_olap = "<%=olap%>";
	var p_dataSource = "<%=dataSource%>";
	var p_ql = "<%=ql%>";
	var p_dfxFile = "<%=dfxFile%>";
	var p_dfxScript = "<%=dfxScript%>";
	var p_dfxParams = "<%=dfxParams%>";
	var p_inputFiles = "<%=inputFiles%>";
	var p_fixedTable = "<%=fixedTable%>";
	var p_dataFileType = "<%=dataFileType%>";
	var p_dct = "<%=dct%>";
	var p_vsb = "<%=vsb%>";
	var p_filter = "<%=filter%>";
	var p_sqlId = "<%=sqlId%>";
	var p_macro = "<%=macro%>";
	var data_jsp_name = "data";
</script>
</head>
<body style="overflow: hidden;">
<script>var contextPath = '<%=cp%>';</script>
<script src="../../js/j_query_yi_jiu_yi.js"></script>
<script src="../../../easyui/jquery.easyui.min.js"></script>
<script>
var easyuiapi = jQuery.noConflict(true);//与原jquery冲突，重定义$，本页面用easyuiapi代表easyui的$
var guideConf = {};
</script>
<script src="../../js/j_query_yi_jiu_yi.js"></script>
<script src="../../../../js/bootstrap.min.js"></script>
<script src="../../../../js/bootstrap-treeview.js"></script>
<script type="text/javascript" src="<%=guideDir %>/dbd2.0/js/olaptabs.js?v=<%=v %>"></script>
<link href="../css/bootstrap/bootstrap.css" rel="stylesheet" media="screen">
<link href="../css/bootstrap/bootstrap-responsive.css" rel="stylesheet" media="screen">
<link href="../css/bootstrap/bootstrap-treeview.css" rel="stylesheet" media="screen">
<link  rel="stylesheet" href="../css/DBD.css"/>
<link  rel="stylesheet" href="../css/style.css"/>
<link rel="stylesheet" type="text/css" href="../../../easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="../../../easyui/themes/icon.css">
<div style="height:100%;width:100%">
<div class="container-fluid" id="dataHeader" style="background-color:#f3f3f3;height:3.5%">
	<nav class="navbar" role="navigation">
		<ul class="nav navbar-nav">
			<li class="dropdown">
				<a class="navFont-default2" class="dropdown-toggle" data-toggle="dropdown">文件<b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li class="dropdown-submenu">
						<a href="#">打开olap文件</a>
						<ul class="dropdown-menu">
							<li><a href="javascript:open_self();">
							<svg t="1579756551115" class="icon" viewBox="0 0 1260 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="18622" width="15" height="15"><path d="M1058.848012 935.688021H88.993243l113.018307-453.124559h969.854769zM88.993243 88.839223h397.403905l52.566655 157.699962h554.052534v147.186632h-893.63312A88.837646 88.837646 0 0 0 115.802237 461.011134l-27.33466 109.338641zM1181.853983 394.251483V246.013518A88.311979 88.311979 0 0 0 1093.016337 157.701539h-490.972549l-31.014326-95.67131A88.311979 88.311979 0 0 0 486.922815 0.001577H88.993243A88.311979 88.311979 0 0 0 0.155598 88.839223V935.688021a88.837646 88.837646 0 0 0 0 10.513331v14.718663a87.260646 87.260646 0 0 0 26.808993 37.847991h5.782332a87.260646 87.260646 0 0 0 39.950657 14.718663h986.150432A88.837646 88.837646 0 0 0 1145.057325 946.201352l113.018307-453.124559a88.837646 88.837646 0 0 0-76.221649-98.82531z" fill="#5E5C5C" p-id="18623"></path></svg>
							打开到当前标签</a></li>
							<li><a href="javascript:open_tab();">
							<svg t="1579756551115" class="icon" viewBox="0 0 1260 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="18622" width="15" height="15"><path d="M1058.848012 935.688021H88.993243l113.018307-453.124559h969.854769zM88.993243 88.839223h397.403905l52.566655 157.699962h554.052534v147.186632h-893.63312A88.837646 88.837646 0 0 0 115.802237 461.011134l-27.33466 109.338641zM1181.853983 394.251483V246.013518A88.311979 88.311979 0 0 0 1093.016337 157.701539h-490.972549l-31.014326-95.67131A88.311979 88.311979 0 0 0 486.922815 0.001577H88.993243A88.311979 88.311979 0 0 0 0.155598 88.839223V935.688021a88.837646 88.837646 0 0 0 0 10.513331v14.718663a87.260646 87.260646 0 0 0 26.808993 37.847991h5.782332a87.260646 87.260646 0 0 0 39.950657 14.718663h986.150432A88.837646 88.837646 0 0 0 1145.057325 946.201352l113.018307-453.124559a88.837646 88.837646 0 0 0-76.221649-98.82531z" fill="#5E5C5C" p-id="18623"></path></svg>
							打开文件到新标签</a></li>
							<li><a href="javascript:open_blank();">
							<svg t="1592813140258" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="3470" width="15" height="15"><path d="M512 28.03712c-267.264 0-483.328 217.088-483.328 484.352s217.088 483.328 483.328 483.328 483.328-217.088 483.328-483.328-216.064-484.352-483.328-484.352z m-33.792 73.728v151.552H361.472c26.624-77.824 67.584-134.144 116.736-151.552z m67.584 0c50.176 17.408 90.112 74.752 116.736 151.552H545.792v-151.552z m-189.44 24.576c-24.576 34.816-46.08 77.824-62.464 126.976H186.368c44.032-56.32 102.4-100.352 169.984-126.976z m311.296 0c67.584 26.624 125.952 70.656 169.984 126.976H730.112c-16.384-49.152-37.888-92.16-62.464-126.976z m-525.312 193.536h132.096c-11.264 49.152-18.432 102.4-20.48 157.696H97.28c4.096-56.32 20.48-109.568 45.056-157.696z m198.656 0h137.216v157.696H321.536c2.048-55.296 8.192-108.544 19.456-157.696z m204.8 0h137.216c11.264 48.128 18.432 102.4 20.48 157.696H545.792v-157.696z m203.776 0h132.096c24.576 48.128 40.96 101.376 45.056 157.696H770.048c-2.048-55.296-9.216-108.544-20.48-157.696z m-652.288 225.28h156.672c2.048 55.296 9.216 108.544 20.48 157.696H142.336c-24.576-48.128-40.96-101.376-45.056-157.696z m224.256 0h156.672v157.696H340.992c-10.24-48.128-17.408-102.4-19.456-157.696z m224.256 0h156.672c-2.048 55.296-9.216 108.544-20.48 157.696H545.792v-157.696z m224.256 0h156.672c-4.096 56.32-20.48 109.568-45.056 157.696H749.568c11.264-49.152 18.432-101.376 20.48-157.696z m-584.704 225.28h107.52c16.384 49.152 37.888 92.16 62.464 128-66.56-27.648-124.928-71.68-169.984-128z m175.104 0h117.76v151.552c-50.176-17.408-90.112-73.728-117.76-151.552z m185.344 0h117.76c-27.648 77.824-67.584 134.144-117.76 151.552v-151.552z m185.344 0h107.52c-44.032 56.32-103.424 100.352-171.008 128 24.576-35.84 46.08-78.848 63.488-128z" fill="#5E5C5C" p-id="3471"></path></svg>
							打开文件到新页面</a></li>
						</ul>
					</li>
					<li class="dropdown-submenu">
						<a href="#">打开数据文件</a>
						<ul class="dropdown-menu">
							<li><a href="javascript:open2_append();">
							<svg t="1607786151391" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="5489" width="15" height="15"><path d="M256 85.333333a85.333333 85.333333 0 0 0-85.333333 85.333334v682.666666a85.333333 85.333333 0 0 0 85.333333 85.333334h512a85.333333 85.333333 0 0 0 85.333333-85.333334V341.333333l-256-256m-42.666666 64L789.333333 384H554.666667m-125.866667 94.72l120.746667 120.746667L640 509.013333V810.666667H338.346667l90.453333-90.453334-120.746667-120.746666" fill="#515151" p-id="5490"></path></svg>
							导入到当前页数据集</a></li>
							<li><a href="javascript:open2_self();">
							<svg t="1579756551115" class="icon" viewBox="0 0 1260 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="18622" width="15" height="15"><path d="M1058.848012 935.688021H88.993243l113.018307-453.124559h969.854769zM88.993243 88.839223h397.403905l52.566655 157.699962h554.052534v147.186632h-893.63312A88.837646 88.837646 0 0 0 115.802237 461.011134l-27.33466 109.338641zM1181.853983 394.251483V246.013518A88.311979 88.311979 0 0 0 1093.016337 157.701539h-490.972549l-31.014326-95.67131A88.311979 88.311979 0 0 0 486.922815 0.001577H88.993243A88.311979 88.311979 0 0 0 0.155598 88.839223V935.688021a88.837646 88.837646 0 0 0 0 10.513331v14.718663a87.260646 87.260646 0 0 0 26.808993 37.847991h5.782332a87.260646 87.260646 0 0 0 39.950657 14.718663h986.150432A88.837646 88.837646 0 0 0 1145.057325 946.201352l113.018307-453.124559a88.837646 88.837646 0 0 0-76.221649-98.82531z" fill="#5E5C5C" p-id="18623"></path></svg>
							打开到当前标签</a></li>
							<li><a href="javascript:open2_tab();">
							<svg t="1579756551115" class="icon" viewBox="0 0 1260 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="18622" width="15" height="15"><path d="M1058.848012 935.688021H88.993243l113.018307-453.124559h969.854769zM88.993243 88.839223h397.403905l52.566655 157.699962h554.052534v147.186632h-893.63312A88.837646 88.837646 0 0 0 115.802237 461.011134l-27.33466 109.338641zM1181.853983 394.251483V246.013518A88.311979 88.311979 0 0 0 1093.016337 157.701539h-490.972549l-31.014326-95.67131A88.311979 88.311979 0 0 0 486.922815 0.001577H88.993243A88.311979 88.311979 0 0 0 0.155598 88.839223V935.688021a88.837646 88.837646 0 0 0 0 10.513331v14.718663a87.260646 87.260646 0 0 0 26.808993 37.847991h5.782332a87.260646 87.260646 0 0 0 39.950657 14.718663h986.150432A88.837646 88.837646 0 0 0 1145.057325 946.201352l113.018307-453.124559a88.837646 88.837646 0 0 0-76.221649-98.82531z" fill="#5E5C5C" p-id="18623"></path></svg>
							打开文件到新标签</a></li>
							<li><a href="javascript:open2_blank();">
							<svg t="1592813140258" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="3470" width="15" height="15"><path d="M512 28.03712c-267.264 0-483.328 217.088-483.328 484.352s217.088 483.328 483.328 483.328 483.328-217.088 483.328-483.328-216.064-484.352-483.328-484.352z m-33.792 73.728v151.552H361.472c26.624-77.824 67.584-134.144 116.736-151.552z m67.584 0c50.176 17.408 90.112 74.752 116.736 151.552H545.792v-151.552z m-189.44 24.576c-24.576 34.816-46.08 77.824-62.464 126.976H186.368c44.032-56.32 102.4-100.352 169.984-126.976z m311.296 0c67.584 26.624 125.952 70.656 169.984 126.976H730.112c-16.384-49.152-37.888-92.16-62.464-126.976z m-525.312 193.536h132.096c-11.264 49.152-18.432 102.4-20.48 157.696H97.28c4.096-56.32 20.48-109.568 45.056-157.696z m198.656 0h137.216v157.696H321.536c2.048-55.296 8.192-108.544 19.456-157.696z m204.8 0h137.216c11.264 48.128 18.432 102.4 20.48 157.696H545.792v-157.696z m203.776 0h132.096c24.576 48.128 40.96 101.376 45.056 157.696H770.048c-2.048-55.296-9.216-108.544-20.48-157.696z m-652.288 225.28h156.672c2.048 55.296 9.216 108.544 20.48 157.696H142.336c-24.576-48.128-40.96-101.376-45.056-157.696z m224.256 0h156.672v157.696H340.992c-10.24-48.128-17.408-102.4-19.456-157.696z m224.256 0h156.672c-2.048 55.296-9.216 108.544-20.48 157.696H545.792v-157.696z m224.256 0h156.672c-4.096 56.32-20.48 109.568-45.056 157.696H749.568c11.264-49.152 18.432-101.376 20.48-157.696z m-584.704 225.28h107.52c16.384 49.152 37.888 92.16 62.464 128-66.56-27.648-124.928-71.68-169.984-128z m175.104 0h117.76v151.552c-50.176-17.408-90.112-73.728-117.76-151.552z m185.344 0h117.76c-27.648 77.824-67.584 134.144-117.76 151.552v-151.552z m185.344 0h107.52c-44.032 56.32-103.424 100.352-171.008 128 24.576-35.84 46.08-78.848 63.488-128z" fill="#5E5C5C" p-id="3471"></path></svg>
							打开文件到新页面</a></li>
						</ul>
					</li>
				</ul>
			</li>
			<li><div class="seperater"></div></li>
			<li id="olapTabHref"><div class="addOlapTab navFont-default2" onclick="addOlapTab();">
				<svg t="1592473315134" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="2639" width="20" height="20"><path d="M490.667 85.333l42.667 0 0 853.333-42.667 0 0-853.333z" p-id="2640"></path><path d="M85.333 490.667l853.333 0 0 42.667-853.333 0 0-42.667z" p-id="2641"></path></svg>
			</div></li>
		</ul>
	</nav>
</div>
 <div class="tabTop" id="tabTop">
 
 </div>
</div>
</body>
</html>