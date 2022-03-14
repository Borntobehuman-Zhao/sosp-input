<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.raqsoft.guide.web.dl.*" %>
<%@ page import="com.raqsoft.guide.resource.*" %>
<%@ taglib uri="/WEB-INF/raqsoftCommonQuery.tld" prefix="raqsoft" %>
<%

//ConfigUtil.executeDql("DataLogic","list table");
//ConfigUtil.executeDql("DataLogic","list dim");
//ConfigUtil.executeDql("DataLogic","list field of 订单 depth 3");
//ConfigUtil.executeDql("DataLogic","list field of 订单 dim 市  depth 3");
//ConfigUtil.executeDql("DataLogic","list field of 订单 dim 省  depth 3");

request.setCharacterEncoding("UTF-8");
String cp = request.getContextPath();
String qyx = request.getParameter( "qyx" );
if (qyx == null) qyx = "";
String dataSource = request.getParameter( "dataSource" );
if (dataSource == null) dataSource = "";
String fixedTable = request.getParameter( "fixedTable" );
if (fixedTable == null) fixedTable = "";
String outerCondition = request.getParameter( "outerCondition" );
if (outerCondition == null) outerCondition = "";
String showToolBar = request.getParameter("showToolBar");
if(showToolBar==null) showToolBar = "yes";
String showSubTable = request.getParameter("showSubTable");
if(showSubTable==null) showSubTable = "yes";

if (dataSource.length()==0 && qyx.length() == 0) dataSource = "DataLogic"; 
//fixedTable="订单";
//System.out.println("outerCondition : " + outerCondition);
//outerCondition="[{\"table\":\"雇员\",\"exp\":\"${T}.雇员='${param1}'\"},{\"table\":\"省\",\"exp\":\"${T}.名称='天津'\"}]";
//outerCondition = "[{\"table\":\"雇员\",\"exp\":\"${T}.雇员=${param1}\"}]";
//outerCondition="[{\"table\":\"省\",\"exp\":\"${T}.名称='辽宁'\"}]";

/*
	jsonFile=""
	dfxFile=""
	params=""
	destRpx=""
	destFrame=""
*/
String metadata = "WEB-INF/files/dfx/beforeCommonQuery.dfx";//"myMetadata.json"; //.json or .dfx file
String destRpx = "commonQuery.rpx";
String destFrame = "_blank";
%>

<raqsoft:commonQuery
	metadata="<%=metadata %>"
	params="arg1=1&arg2=1,2,3,7,22,78,123"
	destRpx="<%=destRpx %>"
	destFrame="<%=destFrame %>"
/>

<script>
	
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
	$(document).ready(function(){

	});
	
	commQuery.rpxjsp = "<%=cp%>/reportJsp/showReport.jsp";

</script>

