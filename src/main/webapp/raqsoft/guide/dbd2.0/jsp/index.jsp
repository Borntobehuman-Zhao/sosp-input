<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>目录</title>
<script src="../../js/j_query_yi_jiu_yi.js"></script>
<script src="../../../../js/bootstrap.min.js"></script>
<script src="../js/index.js"></script>
<link href="../css/folder.css" rel="stylesheet"/>
<link href="../css/DBD.css" rel="stylesheet"/>
<link href="../css/bootstrap/bootstrap.css" rel="stylesheet" media="screen">
<link href="../css/bootstrap/bootstrap-responsive.css" rel="stylesheet" media="screen">
</head>
<%
String cp = request.getContextPath();
String currFolderId = request.getParameter( "currFolderId" );
if(currFolderId == null) currFolderId = "0";
String currLevel = request.getParameter( "currLevel" );
if(currLevel == null) currLevel = "level1";
else{
	currLevel = "level"+currLevel;
}

String title = request.getParameter("title");
if (title == null) title = "Raqsoft DBD";
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
if (dataSource.length() == 0) {
//olap = "WEB-INF/files/olap/客户情况.olap";
	dataSource="DataLogic";
//fixedTable="ALL";
}
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
</script>
<body>
<div class="container-fluid" style="background-color:#efefef;">
	<nav class="navbar navbar-default" role="navigation">
			<ul class="nav navbar-nav">
				<li><div id="logopic">Dashboard</div></li>
				<li><div id='backbut' class="navFont-default2" onclick="javascript:goback();">返回
				<svg t="1579754746243" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="13997" id="mx_n_1579754746244" width="15" height="15"><path d="M425.856 886.263467a29.499733 29.499733 0 0 1-19.669333-7.466667L18.4832 534.135467a29.636267 29.636267 0 0 1 0-44.305067L406.186667 145.186133a29.5936 29.5936 0 0 1 31.761066-4.855466 29.636267 29.636267 0 0 1 17.527467 27.016533v215.415467a29.602133 29.602133 0 0 1-29.610667 29.6192 29.610667 29.610667 0 0 1-29.6192-29.6192V233.284267L82.7136 511.982933 396.245333 790.698667V641.237333a29.610667 29.610667 0 0 1 29.6192-29.6192 29.602133 29.602133 0 0 1 29.610667 29.6192v215.415467a29.6448 29.6448 0 0 1-29.6192 29.610667z" fill="#1296db" p-id="13998"></path><path d="M985.856 886.263467a29.627733 29.627733 0 0 1-27.477333-18.628267c-0.759467-1.672533-88.507733-196.795733-532.522667-196.795733-16.366933 0-29.6192-13.252267-29.6192-29.6192s13.243733-29.6192 29.6192-29.6192c295.185067 0 446.788267 82.0224 521.361067 149.0176-68.317867-343.287467-501.461333-348.2112-521.4208-348.2624a29.6192 29.6192 0 0 1 0.059733-59.2384c5.896533 0 589.610667 5.7856 589.610667 503.509333a29.678933 29.678933 0 0 1-29.610667 29.636267z" fill="#1296db" p-id="13999"></path></svg>
				</div>
				</li>
				<li><div id="cutBut" class="navFont-default2" onclick="javascript:copyFile();">剪切文件
				<svg t="1581668573624" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="2071" width="15" height="15"><path d="M494.3872 614.4l-67.05152 66.1504a61.44 61.44 0 0 0-18.10432 48.76288c0.24576 2.9696 0.36864 5.61152 0.36864 7.96672a143.36 143.36 0 1 1-143.36-143.36 102.4 102.4 0 0 1 9.48224 0.512 61.44 61.44 0 0 0 48.92672-17.42848L390.5536 512l-65.90464-65.00352a61.44 61.44 0 0 0-48.92672-17.408A102.4 102.4 0 0 1 266.24 430.08a143.36 143.36 0 1 1 143.36-143.36c0 2.3552-0.12288 4.99712-0.36864 7.96672a61.44 61.44 0 0 0 18.10432 48.78336l467.70176 461.25056a20.2752 20.2752 0 0 1 0 28.95872c-3.8912 3.85024-9.17504 6.00064-14.68416 6.00064h-123.12576a83.6608 83.6608 0 0 1-58.73664-24.00256L494.3872 614.4zM266.24 348.16a61.44 61.44 0 1 0 0-122.88 61.44 61.44 0 0 0 0 122.88z m0 327.68a61.44 61.44 0 1 0 0 122.88 61.44 61.44 0 0 0 0-122.88z m266.24-303.3088l169.984-165.13024A82.8416 82.8416 0 0 1 760.0128 184.32h120.7296c5.38624 0 10.56768 2.06848 14.39744 5.77536a19.2512 19.2512 0 0 1 0 27.8528L634.2656 471.04 532.48 372.5312z" p-id="2072" fill="#13227a"></path></svg>
				</div>
				</li>
				<li><div class="navFont-default2" onclick="javascript:pasteFile();">粘贴文件
				<svg t="1581668662584" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="3353" width="15" height="15"><path d="M469.12 80.64h128a32 32 0 0 0 32-32 32 32 0 0 0-32-32h-128a32 32 0 0 0-32 32 32 32 0 0 0 32 32zM276.48 174.08a32 32 0 0 0 32-32v-29.44a32 32 0 0 1 31.36-32 32 32 0 0 0 32-32 33.28 33.28 0 0 0-32.64-32 96.64 96.64 0 0 0-94.72 96v29.44a32 32 0 0 0 32 32zM727.68 80.64h128a32 32 0 0 0 32-32 32 32 0 0 0-32-32h-128a32 32 0 0 0-32 32 32 32 0 0 0 32 32zM976 571.52a32 32 0 0 0-32 32v128a32.64 32.64 0 0 0 32 32 32 32 0 0 0 32-32v-128a32 32 0 0 0-32-32zM912 794.88h-128a32.64 32.64 0 0 0-32 32 32 32 0 0 0 32 32h128a31.36 31.36 0 0 0 31.36-32 33.28 33.28 0 0 0-31.36-32zM1000.32 74.24A32 32 0 0 0 960 57.6a32.64 32.64 0 0 0-16.64 42.24 28.8 28.8 0 0 1 0 12.8v103.04a32.64 32.64 0 0 0 32 32 32 32 0 0 0 32-32V112.64a97.92 97.92 0 0 0-7.04-38.4zM976 312.96a32 32 0 0 0-32 32v128a32.64 32.64 0 0 0 32 32 32 32 0 0 0 32-32v-128a32 32 0 0 0-32-32z" fill="#323333" p-id="3354"></path><path d="M683.52 1006.08H112a96 96 0 0 1-96-96V259.84a96 96 0 0 1 96-96h571.52a96 96 0 0 1 96 96v650.24a96 96 0 0 1-96 96zM112 227.84a32 32 0 0 0-32 32v650.24a32 32 0 0 0 32 32h571.52a32 32 0 0 0 32-32V259.84a32 32 0 0 0-32-32z" fill="#323333" p-id="3355"></path><path d="M604.16 423.68H192a32 32 0 0 1-32-32 32 32 0 0 1 32-32h412.16a32 32 0 0 1 32 32 32.64 32.64 0 0 1-32 32zM604.16 616.96H192a32 32 0 0 1 0-64h412.16a32 32 0 0 1 0 64zM604.16 810.24H192a32 32 0 0 1-32-32 32 32 0 0 1 32-32h412.16a32.64 32.64 0 0 1 32 32 32 32 0 0 1-32 32z" fill="#323333" p-id="3356"></path></svg>
				</div>
				</li>
				<li>
				  	<div class="navFont-default2" onclick="javascript:toData(this);">打开编辑
				  		<svg t="1592470808131" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="1755" width="20" height="20"><path d="M301.056 759.808c-9.216 0-18.432-3.072-24.576-10.24-10.24-10.24-13.312-24.576-8.192-37.888l2.048-5.12c66.56-167.936 69.632-171.008 72.704-174.08l371.712-371.712c13.312-13.312 35.84-13.312 49.152 0l99.328 99.328c6.144 7.168 10.24 15.36 10.24 24.576 0 9.216-4.096 18.432-10.24 24.576L491.52 680.96c-3.072 3.072-6.144 6.144-175.104 73.728l-2.048 3.072c-4.096 2.048-9.216 2.048-13.312 2.048zM366.592 552.96c-3.072 5.12-15.36 32.768-67.584 164.864l-2.048 5.12c-1.024 2.048 0 3.072 1.024 5.12 1.024 1.024 3.072 2.048 5.12 1.024l4.096-2.048c109.568-44.032 156.672-63.488 165.888-68.608l370.688-370.688c1.024-1.024 1.024-2.048 1.024-3.072 0-1.024 0-2.048-1.024-3.072l-99.328-99.328c-2.048-2.048-4.096-2.048-6.144 0C422.912 496.64 374.784 545.792 366.592 552.96z m105.472 107.52c-1.024 0-1.024 0 0 0-1.024 0-1.024 0 0 0zM365.568 555.008z m488.448-254.976z" fill="#13227a" p-id="1756"></path><path d="M436.224 641.024c-4.096 0-8.192-1.024-11.264-4.096-6.144-6.144-6.144-15.36 0-21.504L757.76 282.624c6.144-6.144 15.36-6.144 21.504 0 6.144 6.144 6.144 15.36 0 21.504L447.488 635.904c-3.072 3.072-7.168 5.12-11.264 5.12z" fill="#13227a" p-id="1757"></path><path d="M482.304 687.104c-4.096 0-8.192-1.024-11.264-4.096L344.064 555.008c-6.144-6.144-6.144-15.36 0-21.504s15.36-6.144 21.504 0l128 128c6.144 6.144 6.144 15.36 0 21.504-3.072 2.048-7.168 4.096-11.264 4.096zM337.92 746.496c-4.096 0-8.192-1.024-11.264-4.096l-43.008-43.008c-6.144-6.144-6.144-15.36 0-21.504 6.144-6.144 15.36-6.144 21.504 0l43.008 43.008c6.144 6.144 6.144 15.36 0 21.504-2.048 3.072-6.144 4.096-10.24 4.096z" fill="#13227a" p-id="1758"></path><path d="M661.504 876.544H205.824c-34.816 0-59.392-25.6-59.392-59.392V364.544c0-15.36 6.144-52.224 63.488-52.224h264.192c8.192 0 15.36 7.168 15.36 15.36s-7.168 15.36-15.36 15.36H209.92c-32.768 0-32.768 13.312-32.768 21.504v452.608c0 17.408 11.264 28.672 28.672 28.672h455.68c8.192 0 18.432 0 18.432-28.672V549.888c0-8.192 7.168-15.36 15.36-15.36s15.36 7.168 15.36 15.36v267.264c1.024 52.224-30.72 59.392-49.152 59.392z" fill="#13227a" p-id="1759"></path></svg>
				  	</div>
				</li>
				<li><div class="navFont-default2" onclick="javascript:deleteFile();">删除
				<img src="../img/guide/13.png">
				</div>
				<li><div class="navFont-default2" id="message" onclick="javascript:deleteFile();">
				</div>
				</li>
			</ul>
	</nav>
</div>
<div class="container-fluid" style="height:500px;margin:10px">
 <div class="row-fluid" id="folderMain">
  </div>
</div>
<script src="../js/folder.js" type="text/javascript">
</script>
<script src="../js/folder-pc.js" type="text/javascript">
</script>
<script>
	var cp = "<%=cp%>";
	var currFolderId = "<%=currFolderId%>";
	var currLevel = "<%=currLevel%>"
	function init(){
		$.ajax({
			url:"<%=cp%>/servlet/dataSphereServlet?action=39",
			type:"post",
			dataType:"json",
			data:{},
			success:function(data){
				showFolder(data,currLevel,currFolderId);
				folderInfo.data = data;
				$('.folder,.file').click(chooseDiv);
			}
		});
		$('#backbut').css('cursor','no-drop');
		$('#cutBut').css('cursor','no-drop');
	}
	init();
</script>
</body>
</html>