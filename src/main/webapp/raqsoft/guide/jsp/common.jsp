<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/raqsoftReport.tld" prefix="report" %>
<%@ page import="com.raqsoft.report.view.*" %>
<%@ page import="com.raqsoft.report.util.*" %>
<%@ page import="com.raqsoft.report.model.*" %>
<%@ page import="com.raqsoft.report.usermodel.*" %>
<%@ page import="com.raqsoft.guide.web.dl.*" %>
<%@ page import="com.raqsoft.guide.resource.*" %>
<%@ page import="com.raqsoft.guide.*" %>
<%@ page import="com.raqsoft.guide.web.*" %>
<%@ page import="com.raqsoft.common.*" %>
<%@ page import="java.sql.*" %>
<%
String jsv = request.getParameter("jsv");
String cp = request.getContextPath();
String title = request.getParameter("title");
if (title == null) title = "Raqsoft Query/Analyse";
String guideDir = cp + "/raqsoft/guide/";
String v = ""+System.currentTimeMillis();

%>
<script>
</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<head>
	<title><%=title %></title>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge;" /><!-- 强制以IE8模式运行 -->
	<link rel="stylesheet" href="<%=guideDir %>css/style.css" type="text/css">
	<link rel="stylesheet" href="<%=guideDir %>js/chosen_v1.5.1/chosen.css" type="text/css">
	<link rel="stylesheet" href="<%=guideDir %>js/jquery-powerFloat/css/powerFloat.css" type="text/css">
	<link rel="stylesheet" href="<%=guideDir %>js/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
	<style>
		#feedback { font-size: 1.4em; }
		#dimItemsDiv .ui-selecting { background: #FECA40; }
		#dimItemsDiv { list-style-type: none; margin: 0; padding: 0; }
		#dimItemsDiv li { margin: 1px; padding: 3px 10px 3px 10px; float: left; height: 22px; font-size: 12pt; text-align: center; }
		#table {table-layout:fixed;}
		#td {white-space:nowrap;overflow:hidden;word-break:keep-all;}

	</style>



	<script type="text/javascript" src="<%=guideDir %>js/j_query_yi_jiu_yi.js?v=<%=v %>"></script>
	<script type="text/javascript" src="<%=guideDir %>js/jquery-ui-1.10.1.custom.min.js"></script>
	<script type="text/javascript" src="<%=guideDir %>js/common.js?v=<%=v %>"></script>
	<script type="text/javascript" src="<%=guideDir %>js/artDialog/jquery.artDialog.source.js?skin=twitter"></script>
	<script type="text/javascript" src="<%=guideDir %>js/jquery-ui-timepicker-addon.js"></script>
	<script language=javascript>
		//menu/jquery.js
		var contextPath = '<%=cp%>';
		var guideConf = {};
		guideConf.guideDir = "<%=guideDir %>";	
		
	//具体的数据结构定义请参考raqsoft/guide/js/raqsoftApi.js里的queryApi的定义，里面有详细注释
		var consts = {
			relaPath : 'raqsoft/guide/',
			imgFolder : '/img/dl/',
			color1 : '#373636',//大部分字体颜色
			color2 : '#FFFFFF',
			color3 : '#F0F2F4',//弹出窗口按钮区域背景色
			color4 : '#91A3CA',//弹出窗口中确定按钮的边框
			color5 : '#0E399B',//弹出窗口中确定按钮的字色
			color6 : '#0E399B',//弹出窗口中取消按钮的边框
			color7 : '#DFE5EB',//设置条件弹出窗口表头背景色
			color8 : '#BFC2C6',//表格线颜色
			color9 : '#494A4B',//表头字颜色
			color10 : '#BBBEC3',//区域边框色
			color11 : '#D1DCED',//查询按钮背景色
			color12 : '#DDDDDD',//右侧字段列表中，字段之间的边框线
			color13 : '#FFFFDD',//拖拽字段允许落选区域的背景色。
			color14 : '#FFEE8F',//拖拽字段落选区域的背景色。
			color15 : '#BCD4EC',//'#456685',//弹出窗口标题背景色
			color16 : '#BFBDC4',//BY,ON关系箭头颜色
			color17 : '#E9E9E9',//选中字段行的背景色
			color18 : '#FBF8FB',//不同表区之间的间隔背景色。
			color19 : '#A8EDF3',//结果集表头中，on字段的背景色。
			color20 : '#D9D9D9',//操作表头格子背景色
			color21 : '#E5E6E8',//操作格子背景色
			color22 : '#373636',//文本框，下拉框里面的字体颜色
			color23 : '#373636',//资源区字段字体颜色
			color24 : '#',
			img1 : 'split_h.png',
			img2 : 'split_v.png',
			img3 : 'banner_bg.jpg',
			img4 : 'banner_left.jpg',
			img5 : 'banner_right.png',
			img6 : 'tr.png',
			img7 : 'tab.png',
			img8 : 'tab-1.png',
			img9 : 'tab-2.png',
			img10 : 'tab-3.png',
			img11 : 'up2.png',
			img12 : 'down2.png',
			img13 : 'tab-split.png',
			img14 : 'item.png',
			img15 : 'open.png',
			img16 : 'close.png',
			img17 : 'blank.png',
			img18 : 'fk.png',
			img19 : 'pk.png',
			img20 : 'copy.png',
			img21 : 'delete.png',
			img22 : 'result_dim.png',
			img23 : 'result_field.png',
			img24 : 'calc_field.png',
			img25 : 'open_locator.png',
			img26 : 'item-dim.png',
			img27 : 'item-subtable.png',
			img28 : 'tab-4.png',
			img29 : ''
		}
			
	</script>
	<script type="text/javascript" src="<%=guideDir %>js/json2.js"></script>
	<script type="text/javascript" src="<%=guideDir %>js/jquery.cookie.js"></script>
	<!-- 
	<script type="text/javascript" src="<%=guideDir %>js/chosen_v1.5.1/chosen.jquery.min.js"></script>
	<script type="text/javascript" src="<%=guideDir %>js/jquery.layout.js"></script>
	<script type="text/javascript" src="<%=guideDir %>js/dqlApi.js?v=<%=v %>"></script>
	<script type="text/javascript" src="<%=guideDir %>js/vue.min.js?v=<%=v %>"></script>
	<script type="text/javascript" src="<%=guideDir %>js/jquery.bgiframe.js"></script>
	<script type="text/javascript" src="<%=guideDir %>js/jquery.tools.min.js"></script>

<link rel="stylesheet" type="text/css" href="<%=cp %>/raqsoft/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=cp %>/raqsoft/easyui/themes/icon.css">
<script type="text/javascript" src="<%=cp %>/raqsoft/easyui/jquery.min.js"></script>
<script type="text/javascript" src="<%=cp %>/raqsoft/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=cp %>/raqsoft/easyui/locale/easyui-lang-zh_CN.js"></script>
	<script language=javascript src="<%=cp %>/reportServlet?action=10&file=%2Fcom%2Fraqsoft%2Freport%2Fview%2Fhtml%2FparamForm.js" charset="UTF-8"></script>
	<script language=javascript src="<%=cp %>/reportServlet?action=10&file=%2Fcom%2Fraqsoft%2Freport%2Fview%2Fhtml%2Ftree.js" charset="UTF-8"></script>

	-->
	<script type="text/javascript" src="<%=guideDir %>js/commonQuery.js?v=<%=v %>"></script>
	<script type="text/javascript" src="<%=guideDir %>js/ztree/js/jquery.ztree.all-3.5.min.js"></script>
	<script type="text/javascript" src="<%=guideDir %>js/ztree/js/jquery.ztree.exhide-3.5.min.js"></script>

</head>
<body style="margin:0;padding:0;overflow:hidden;">
	<div id='bodyDiv' style='width:100%;height:calc(100% - 25px);padding:10px;'>
		<div style="display:none;">
			<iframe id='hiddenFrame' name='hiddenFrame' height="100px" width="100px"></iframe>
			<form id=downloadForm method=post ACTION="<%=cp%>/servlet/dataSphereServlet?action=11" target=hiddenFrame>
				<input type=hidden name=path id=path value="">
				<input type=hidden name=content id=content value="">
				<input type=hidden name=mode id=mode value="">
			</form>
			<form id=reportForm method=post ACTION="" target="">
				<input type=hidden name="queryJSON" id="queryJSON" value="">
				<input type=hidden name=params id=params value="">
			</form>
		</div>

		<div class='mainPanel' style="border:0px;width:100%;height:100%;overflow:auto;position:;">
				<div id="sourceArea" style="width:150px;float:left;overflow-x:auto;height:100%;">
					<div id="groups" style='border:1px solid #A5ACB5;overflow-y:hidden;background-color:#F8F8F8;padding:0;margin:0;'>
						
					</div>
					<div class='' style="background-color:#F8F8F8;" id='fields'>
						<!--
						<select id="OPNFUN11_arg" name="OPNFUN11_arg" class="easyui-combobox" style="text-align:left;vertical-align:middle;padding-left:0px;font-family:Dialog;font-size:12px;color:rgba(0,0,0,1.0);font-weight:normal;font-style:normal;text-decoration:none;background-color:transparent;white-space:nowrap;overflow:hidden;word-break:keep-all;;width:208px;height:23px" value="" canEmpty="1" el="全部" data-options="editable:false,valueField:'v',textField:'d',readonly:false,data:[{v:'',d:'全部'},{v:'0',d:'未开通'},{v:'1',d:'已开通'}]" onclick="_hideDropDown()"></select>
						-->
					</div>
				</div>
				<div id="tableDiv" style="float:right;width:calc(100% - 150px);height:100%;">
					<input style="float:left;" type="button" value="查询" id="queryBut">
					<div style="float:right;">&nbsp;</div>
				</div>
		</div>
	</div>


</body>
</html>

	