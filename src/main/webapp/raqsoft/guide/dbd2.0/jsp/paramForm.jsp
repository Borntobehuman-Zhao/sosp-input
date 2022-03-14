<%@ page contentType="text/html;charset=UTF-8" %>
<%
String cp = request.getContextPath();
String params = request.getParameter("params");
String using = request.getParameter("using");
String status = request.getParameter("status");
String rowCount = request.getParameter("rowCount");
String curr = request.getParameter("curr");
String hasSubmitButton = request.getParameter("hasSubmitButton");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<head>
	<title></title>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge;" />
	<script type="text/javascript" src="../../js/j_query_yi_jiu_yi.js"></script>
	<script type="text/javascript" src="../../js/jquery-ui-1.10.1.custom.min.js"></script>
	<script type="text/javascript" src="../../js/common.js"></script>
	<script type="text/javascript" src="../../js/ztree/js/jquery.ztree.all-3.5.min.js"></script>
	<script type="text/javascript" src="../../js/ztree/js/jquery.ztree.exhide-3.5.min.js"></script>
	<link rel="stylesheet" href="../../asset/layui/css/layui.css">
	<link rel="stylesheet" href="../../css/style.css" type="text/css">
	<link rel="stylesheet" href="../../js/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
	<style>
	.ut{
		height:100%;
		width:100%;
		border-collapse: collapse;
	}
	.utr{
		height:30px;
	}
	.utd{
	    border-style: dotted;
	    border-width: 1px;
	    width:100px;
	}
	a{
		cursor:move;
	}
	button,input{
		height:42px;
		font-size:15px;
	}
	li.level1{
		text-align:center;
		border: solid 0.5px #a6c7ff;
	}
	</style>
	<script type="text/javascript">
		var content = [];
		var currIndex = 1;
		var oldLayout = JSON.parse('<%=curr%>');
		var currLayout = JSON.parse('<%=curr%>');
		Array.prototype.deleteIndex = function(index){
			var r = this.slice(0, index).concat(this.slice(parseInt(index, 10) + 1));
			return r;
		};
		Array.prototype.deleteValue = function(value){
			var i = 0;
			var hasValue = false;
			for(i in this){
				if(this[i] == value) {
					hasValue = true;
					break;
				}
			}
			if(hasValue){
				return this.slice(0, i).concat(this.slice(parseInt(i, 10) + 1));
			}else{
				return this;
			}
		};
		
		function createPZtree(params){
			var zNodes = [];
			for(var i = 0 ; i < params.length; i++){
				var id = i+1;
				if(params[i] == "submit_button") id = -1;
				zNodes[zNodes.length] = {
						id:id, 
						//isParent:true, 
						pId:0, 
						name:params[i], 
						//open:false, 
						icon:"../../js/ztree/css/zTreeStyle/img/diy/2.png",
						value:params[i],
						load:false
				}
				currIndex++;
			}
			var pNode = {
				id:0, 
				isParent:true, 
				pId:0, 
				name:'已添加的控件', 
				open:true, 
				value:'已添加的控件',
				load:true
			};
			pNode.children = zNodes;
			$.fn.zTree.init($('#params'), {
				edit: {
					enable: true,
					drag: {
						prev: false,
						next: false,
						inner: false
					}
				},
				callback:{
					onDrag : function(event, treeId, treeNodes){
					},
					onDrop: function(e, treeId, treeNodes, targetNode, moveType) {
						if(treeNodes[0].id == 0) return;
						var paramName = treeNodes[0].value;
						var target = e.target;
						var p = null;
						if ($(target).hasClass('utd')) {
							p = $(e.target);
						} else {
							p = null;
						}
						if(p == null) return;
						if($(p).html().length > 0) {//当前位置值删除
							var paramName_old = $(p).html();
							deleteParamFromContent(paramName_old, p);
							var lIndex = getCurrLayoutCellIndex(paramName_old);
							currLayout = currLayout.deleteIndex(lIndex);
						}
						if($.inArray(paramName, content) >= 0) {//相当于移动，删除此值原来的位置
							var cellId = getCurrLayout(paramName).cell;
							$('#'+cellId).html('');
							getCurrLayout(paramName).cell = $(p).attr('id');
						}else{
							content.push(paramName);
							var old = getOldLayout(paramName);
							currLayout.push(old);
							getOldLayout(paramName).cell = $(p).attr('id');
						}
						
						$(p).html(paramName);
						
						$('.utd').css('background-color','#FFFFFF');
						seeConsole();
					},
					onDragMove : function(e, treeId, treeNodes) {
						if(treeNodes[0].id == 0) return;
						var target = e.target;
						var p = null;
						if ($(target).hasClass('utd')) {
							p = $(e.target);
						} else {
							p = null;
						}

						$('.utd').css('background-color','#FFFFFF');
						if (p) {
							p.css('background-color','#FFFF88');
						}
					}
				}
				
			}, pNode);
		}
		
		function addUtr(n){
			var tr = $('<tr class="utr" id='+n+'></tr>');
			$('#ut').append(tr);
			var cc = 0;
			while(cc < 6){
				var td = $('<td class="utd" id='+n+'_'+cc+'></td>');
				tr.append(td);
				td.dblclick(function(e){
					var paramName = $(e.target).html();
					deleteParamFromContent(paramName, e.target);
					var lIndex = getCurrLayoutCellIndex(paramName);
					currLayout = currLayout.deleteIndex(lIndex);
					//content = content.deleteValue(paramName);
					var treeObj = $.fn.zTree.getZTreeObj("params");  
					if(paramName == 'submit_button') {
						var nodes = treeObj.getNodes()[0].children;
						for(var i = 0; i < nodes.length; i++){
							if(nodes[i].id == -1){
								treeObj.removeNode( nodes[i] );
								break;
							}
						}
						//content = content.deleteValue('submit_button');
						
						//oldLayout = currLayout;
						var sbIndex = getOldLayoutCellIndex('submit_button');
						oldLayout = oldLayout.deleteIndex(sbIndex);
						/* currLayout = currLayout.deleteIndex(-1);
						oldLayout = oldLayout.deleteIndex(-1); */
						submit();
						
					}
					seeConsole();
				});
				cc++;
			}
		}
		
		function deleteParamFromContent(paramName, td){
			if(paramName == null || paramName == "") return;
			var index = $.inArray(paramName, content);
			if(index >= 0) {
				content = content.deleteIndex(index);
			}
			$(td).html('');
			seeConsole();
		}
		
		function deleteParamFromContent(paramName, td){
			if(paramName == null || paramName == "") return;
			var index = $.inArray(paramName, content);
			if(index >= 0) {
				content = content.deleteIndex(index);
			}
			$(td).html('');
			seeConsole();
		}
		
		function getCurrLayoutCellIndex(paramName){
			for(var i = 0; i < currLayout.length; i++){
				if(currLayout[i].editor.pname == paramName){
					return i;
				}
			}
		}
		
		function getCurrLayout(paramName){
			for(var i = 0; i < currLayout.length; i++){
				if(currLayout[i].editor.pname == paramName){
					return currLayout[i];
				}
			}
		}
		
		function getOldLayoutCellIndex(paramName){
			for(var i = 0; i < oldLayout.length; i++){
				if(oldLayout[i].editor.pname == paramName){
					return i;
				}
			}
		}
		
		function getOldLayout(paramName){
			for(var i = 0; i < oldLayout.length; i++){
				if(oldLayout[i].editor.pname == paramName){
					return oldLayout[i];
				}
			}
		}
		
		$(function(){
			var rc = 0;
			while(rc < <%=rowCount%>){
				addUtr(rc);
				rc++;				
			}
			var params = '<%=params%>';
			var using = '<%=using%>';
			if(using != "-") {
				using = using.split(',');
				createPZtree(using);
			}
			if(params != "-") {
				params = params.split(',');
			}
			for(var i = 0; i < oldLayout.length; i++){
				var param = oldLayout[i];
				$('#'+param.cell).html(param.editor.pname);
				content.push(param.editor.pname);
			}
			
			var status = '<%=status%>' == '1';
			if(status) $('#pbutton').html('已开启参数表单');
			var hasSubmitButton = '<%=hasSubmitButton%>' == '1';
			if(hasSubmitButton) $('#sbutton').html('已显示查询按钮');
			seeConsole();
		});
		
		function submit(){
			window.parent.paramFormLayout.currLayout = currLayout;
			window.parent.refreshParamForm();
		}
		
		function changeStatus(){
			window.parent.paramFormLayout.useParamForm = !window.parent.paramFormLayout.useParamForm;
			if(window.parent.paramFormLayout.useParamForm) $('#pbutton').html('已开启参数表单');
			else $('#pbutton').html('实际效果隐藏参数表单');
		}
		
		function showQueryButton(){
			window.parent.paramFormLayout.hasSubmitButton = !window.parent.paramFormLayout.hasSubmitButton;
			if(window.parent.paramFormLayout.hasSubmitButton) {
				//add
				$('#sbutton').html('已显示查询按钮');
			}
			else {
				$('#sbutton').html('已隐藏查询按钮');
			}
		}
		
		function addQueryButton(){
			if(JSON.stringify(content).indexOf('submit_button') < 0) {
				var utds = $('.utd');
				for(var i = 0; i < utds.length; i++){
					if(utds[i].innerHTML == ''){
						window.parent.addPfSubmitButton();
						var treeObj = $.fn.zTree.getZTreeObj("params");  
						var newNode = {
							id:-1, 
							//isParent:true, 
							pId:0, 
							name:'submit_button', 
							//open:false, 
							icon:"../../js/ztree/css/zTreeStyle/img/diy/2.png",
							value:'submit_button',
							load:false
						}
						treeObj.addNodes(treeObj.getNodes()[0], newNode);  
						utds[i].innerHTML = 'submit_button';
						content.push('submit_button');
						var o = {data: {value: "查询"},
								pname: "submit_button",
								type: "submit_button"}
						currLayout[currLayout.length] = ({editor:o, cell:$(utds[i]).attr('id')});
						oldLayout[oldLayout.length] = ({editor:o, cell:$(utds[i]).attr('id')});
						break;
					}
				}
				seeConsole();
			}
		}
	</script>
</head>
<body class="layui-layout-body" style="overflow:hidden;margin:3px;width:100%;height:100%;">
<div class="layui-layout layui-layout-admin">
	<div class="layui-side" style="border-right: 1px gray solid;top:0px">
		参数表单中：
	    <div class="layui-side-scroll" id="params">
	    </div>
	</div>
    
    <div class="layui-body" style="top:0px">
    	<table id='ut' class='ut' title="双击删除，点击应用保存">
    	</table>
	</div>
	
	<div class="layui-footer">
		<button id="pbutton" onclick="changeStatus();">实际效果隐藏参数表单</button>
		<button id="sbutton" onclick="showQueryButton();">已隐藏查询按钮</button>
		<button id="addbutton" onclick="addQueryButton();">添加查询按钮</button>
		<button id="submit" style="float:right;" onclick="submit();">应用布局</button>
	</div>
</div>
<script src="../../asset/layui/layui.js"></script>
<script>
//JavaScript代码区域
layui.use('element', function(){
  var element = layui.element;
  
});

function seeConsole(){
	try{
		console.log(content);
		console.log(currLayout);
		console.log(oldLayout);
	}catch(e){}
}
</script>
</body>
</html>