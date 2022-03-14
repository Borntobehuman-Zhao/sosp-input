<%@ page contentType="text/html;charset=UTF-8"%>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.raqsoft.report.view.*"%>
<%@ page import="com.raqsoft.center.entity.*"%>
<%@ page isELIgnored="false"%>
<html>
<head>
<%
  String contextPath = request.getContextPath();
%>
<script type="text/javascript" src="<%=contextPath%>/js/jquery.js"></script>
<script type="text/javascript" src="<%=contextPath%><%=ReportConfig.raqsoftDir%>/center/js/roleEdit.js"></script>
<script src="<%=contextPath%><%=ReportConfig.raqsoftDir%>/center/layui/layui.all.js"></script>
<link rel="stylesheet" href="<%=contextPath%><%=ReportConfig.raqsoftDir%>/center/layui/css/layui.css">
<script type="text/javascript">
		var isMobile = false;
		function clean(type, inputId){
			var selecter = null;
			var radios = null;
			if(type == 1){
				selecter = eval("form2.enabledRptDir"+inputId);
				radios = document.getElementsByClassName("rmode"+inputId);
			}else if(type == 2){
				selecter = eval("form2.enabledDfxDir"+inputId);
				radios = document.getElementsByClassName("dmode"+inputId);
			}
			selecter.value = null;
			for(var i = 0; i < radios.length; i++){
				radios[i].checked = "";
			}
		}
		
		function addPath(){
			layui.use('layer', function(){
				$('#openLayerIndex').val(layer.open({
	    			type:1,
	    			title:"添加新目录",
	    			content:'<div style="text-align:center">\n'+
	    					'<form name="apForm" action="">\n'+
	    					'<input class="layui-input" required autofocus style="height:30px;" type="text" id="newPath" name="newPath" value=""/>\n'+
	    					'<input class="layui-btn layui-btn-sm" type="button" onclick="ajaxAddSubmit();" value="提交"/>'+
	    					'</form>'+
	    					'</div>\n',
	    			area: '250px',
	    			offset: '100px'
	    		}));
	    	});
		}
		
		function delPath(){
			var pathSelForm = $('#pathSelForm').clone(false);
			layui.use('layer', function(){
				$('#openLayerIndex').val(layer.open({
	    			type:1,
	    			title:"删除目录",
	    			content:'<div id="pathSelDiv" style="height:50px;text-align:center">\n'+
	    					'</div>\n'+
	    					'<script>\n'+
	    					'$("#pathSelDiv").append($("#pathSelForm"));'+
	    					'</'+'script>',
	    			area: '250px',
	    			offset: '100px',
	    			cancel:function(){
	    				$('#tmp_delPath').prop('id','delPath');
	    			}
	    		}));
	    	});
			$(pathSelForm.children('select')[0]).prop('id','tmp_delPath');
			$("#refreshDelPathDiv").append(pathSelForm);
		}
		
		function ajaxDelSubmit(){
			if(document.getElementById("delPath").value == ""){alert("请选择路径");return;}
			var delPath = $('#delPath').val();
			var pathSelect = $('#tmp_delPath');
			layer.confirm('此操作会导致该路径下的文件同时被清除！请确保文件已备份！',{icon:5,offset:'100px'}, function(index){
				$.ajax({
					data:{"delPath":delPath},
					url:"reportCenterServlet?action=-41",
					type:"post",
					success:function(callbackstr){
						if(callbackstr == "success"){					
							alert("删除成功!");
						}else if(callbackstr == "success2"){					
							alert("删除成功!");
						}else if(callbackstr == "fail"){					
							alert("删除失败!");
						}else{
							alert(callbackstr);
							layer.close(index);
							return;
						}
					}
				});
				layer.close(index);
				refreshPathListDel(pathSelect,delPath);
				if(isMobile){
					closeFrameLayer("mainframe");
				}else{
					closeFrameLayer("showProp");
				}
			},function(){
				layer.msg("已取消",{offset:'100px'});
			});
		}
		
		function refreshPathListDel(pathSelForm,path){
			$(pathSelForm).prop('id','delPath');
			var options = $(pathSelForm).children('option');
			for(var opt = 0; opt < options.length; opt++){
				if(options[opt].value == path){
					$(options[opt]).remove();
				}
			}
			$(document.getElementById('rpxTr_'+path)).remove();
			$(document.getElementById('dfxTr_'+path)).remove();
		}
		
		function closeFrameLayer(frame){
			var index = $("#openLayerIndex").val();
			var frameWin = top.document.getElementById(frame).contentWindow;
			frameWin.layer.close(index);
		}
		
		
		function ajaxAddSubmit(){
			if(document.getElementById("newPath").value == ""){alert("请输入路径");return;}
			$.ajax({
				data:{"newPath":apForm.newPath.value},
				url:"reportCenterServlet?action=41",
				type:"post",
				success:function(callbackstr){
					if(callbackstr == "success"){					
						refreshPathList(apForm.newPath.value);
						alert("添加成功!");
					}else if(callbackstr == "success2"){
						refreshPathList(apForm.newPath.value);
						alert("将已存在的路径添加到列表！");
					}else{
						alert(callbackstr);
					}
				}
			});
			if(isMobile){
				closeFrameLayer("mainframe");
			}else{
				closeFrameLayer("showProp");
			}
		}
</script>
</head>
<body class="">
<input value id="openLayerIndex" type="hidden"/>
<div class="layui-container" style="margin-top:40px">
	<form id=form2 method=post class="layui-form"  action="<%=contextPath%>/reportCenterServlet?action=${action }">
	<input type=hidden id="roleId" name='roleId' value='${role.id }'>
	<div class="layui-form-item">
	    <label class="layui-form-label" style="">机构名</label>
	    <div class="layui-input-block">
			<input value='${role.name }'  type="text" name="roleName" id="roleName" lay-verify="required" autocomplete="off" style="width:145px" class="layui-input"
				<c:if test="${role.id ne null or role.id eq '-1'}">disabled </c:if>
				<c:if test="${role.id eq null}">placeholder="新增" </c:if>
			/>
	    </div>
  	</div>
  	<div class="layui-collapse" lay-accordion>
		  <c:if test="${role.id ne '-1'}">
		  <div class="layui-colla-item">
		    <h2 class="layui-colla-title">基础权限</h2>
		    <div class="layui-colla-content">
				<div class="layui-form-item" style="height:100px;width:380px;overflow: auto;">
			  		<div class="">
			  			<input title="显示报表管理按钮" type="checkbox" class="layui-input" lay-skin="primary" name="showReportOperButton" id="showReportOperButton"
			  			<c:if test="${role.showReportOperButton}">
			  				checked=true
			  			</c:if>
			  			 >
			  			<input title="显示查询分析管理按钮" type="checkbox" class="layui-input" lay-skin="primary" name="showFileOperButton" id="showFileOperButton"
			  			<c:if test="${role.showFileOperButton}">
			  				checked=true
			  			</c:if> 
						>
					</div>
			  	</div>
			</div>
		  </div>
		  </c:if>
	  <div class="layui-colla-item">
	    <h2 class="layui-colla-title">数据源权限</h2>
	    <div class="layui-colla-content">
	      <div class="layui-form-item" style="height:100px;width:380px;overflow: auto;">
		  		<div class="">
			      	<c:forEach items="${dbs }" var="db">
						<input title="${db }" class="layui-input" lay-skin="primary" type="checkbox" name="dbcheck" id="dbcheck" value="${db }"
						<c:if test="${role ne null }">
							<c:forEach items="${role.enabledDataSources }" var="dsname">
								<c:if test="${dsname eq db}">
									checked="true"
								</c:if>
							</c:forEach>
						</c:if>
						/>
						<div class="layui-unselect layui-form-checkbox layui-form-checked" lay-skin="primary"><span>${db }</span><i class="layui-icon"></i></div>
					</c:forEach>
				</div>
		  	</div>
	    </div>
	  </div>
	  <div class="layui-colla-item">
	    <h2 class="layui-colla-title">报表管理权限</h2>
	    <div class="layui-colla-content">
      		<div class="layui-form-item">
		  		<input style="margin-left:10px" type="button" class="layui-btn layui-bg-black layui-btn-sm" onclick="addPath();" value="添加新目录"/>
		  		<input style="margin-left:10px" type="button" class="layui-btn layui-btn-danger layui-btn-sm" onclick="delPath();" value="删除目录"/>
		  	</div>
		  	<%
				int countId = 0;
			%>
			<div class="layui-tab">
			  <ul class="layui-tab-title">
			    <li class="layui-this">报表文件目录</li>
			    <li>集算器文件目录</li>
			  </ul>
			  <div class="layui-tab-content">
			    <div class="layui-tab-item layui-show">
					<div class="layui-col-xs-offset5 layui-bg-white">
				  		<table lay-size="sm" id="rpxPathTable" class="layui-table" style="width:300px">
				  			<colgroup>
				  			<col width="10px"/>
				  			<col/>
				  			<col width="10px"/>
				  			<col width="10px"/>
				  			<col width="10px"/>
				  			</colgroup>
				  			<thead>
							    <tr>
							    <th style="text-align:center;height:20px;font-weight: 600;">可用</th>
							      <th style="text-align:center;height:20px;font-weight: 600;">报表文件目录</th>
							      <th style="text-align:center;height:20px;font-weight: 600;">读</th>
							      <th style="text-align:center;height:20px;font-weight: 600;">写</th>
							      <th style="text-align:center;height:20px;font-weight: 600;">删</th>
							    </tr> 
						  	</thead>
						  	<c:forEach items="${pathArr }" var="path">
						  		<c:if test="${path ne null and path ne ''}">
								<tr id="rpxTr_${path}">
									<td><input type="hidden" id="countId" value="<%=countId %>"/>
									<input onclick="changeValidity();" class="r_valid" name="r_valid<%=countId %>" type="checkbox" lay-skin="switch" lay-text="ON|OFF" lay-filter="switchTest" <c:forEach items="${role.rptDirModes }" var="rptDM" ><c:if test="${rptDM.dir eq path }">value="off" checked="checked"</c:if></c:forEach>/>
									</td>
									<td><input name="enabledRptDir<%=countId %>" id="enabledRptDir<%=countId %>" type="hidden" value="${path }"/>${path }</td>
									<td><input class="rmode<%=countId %>0 rmode_<%=countId %>" lay-skin="primary" name="rmode<%=countId %>0" type="checkbox" value=1<c:forEach items="${role.rptDirModes }" var="rptDM" ><c:if test="${rptDM.dir eq path and rptDM.mode%2 eq 1 }"> checked="checked"</c:if></c:forEach>
									/></td>
									<td><input class="rmode<%=countId %>1 rmode_<%=countId %>" lay-skin="primary" name="rmode<%=countId %>1" type="checkbox" value=2<c:forEach items="${role.rptDirModes }" var="rptDM" ><c:if test="${rptDM.dir eq path and (rptDM.mode eq 2 || rptDM.mode eq 3 || rptDM.mode ge 6) }"> checked="checked"</c:if></c:forEach>
									/></td>
									<td><input class="rmode<%=countId %>2 rmode_<%=countId %>" lay-skin="primary" name="rmode<%=countId %>2" type="checkbox" value=4<c:forEach items="${role.rptDirModes }" var="rptDM" ><c:if test="${rptDM.dir eq path and rptDM.mode ge 4 }"> checked="checked"</c:if></c:forEach>
									/></td>
									<%countId++; %>
								</tr>
								</c:if>
							</c:forEach>
				  		</table>
			  		</div>
				</div>
			    <div class="layui-tab-item">
					<div class="layui-col-xs-offset5 layui-bg-white">
				  		<%int countId2 = 0; %>
				  		<table lay-size="sm" id="dfxPathTable" class="layui-table" style="width:300px">
				  			<colgroup>
				  			<col width="10px"/>
				  			<col/>
				  			<col width="10px"/>
				  			<col width="10px"/>
				  			<col width="10px"/>
				  			</colgroup>
				  			<thead >
							    <tr>
							    <th style="text-align:center;height:20px;font-weight: 600;">可用</th>
							      <th style="text-align:center;height:20px;font-weight: 600;">集算器文件目录</th>
							      <th style="text-align:center;height:20px;font-weight: 600;">读</th>
							      <th style="text-align:center;height:20px;font-weight: 600;">写</th>
							      <th style="text-align:center;height:20px;font-weight: 600;">删</th>
							    </tr> 
						  	</thead>
							<c:forEach items="${pathArr }" var="path">
						  		<c:if test="${path ne null and path ne ''}">
								<tr id="dfxTr_${path}">
									<td><input type="hidden" id="countId" value="<%=countId2 %>"/>
										<input onclick="changeValidityDfx();" class="d_valid" name="d_valid<%=countId2 %>" type="checkbox" lay-skin="switch" lay-text="ON|OFF" lay-filter="switchTest" <c:forEach items="${role.dfxDirModes }" var="dfxDM" ><c:if test="${dfxDM.dir eq path }">value="off" checked="checked"</c:if></c:forEach>/>
									</td>
									<td><input name="enabledDfxDir<%=countId2 %>" id="enabledDfxDir<%=countId2 %>" type="hidden" value="${path }"/>${path }</td>
									<td><input class="dmode<%=countId2 %>0 dmode_<%=countId2 %>" lay-skin="primary" name="dmode<%=countId2 %>0" type="checkbox" value=1<c:forEach items="${role.dfxDirModes }" var="dfxDM" ><c:if test="${dfxDM.dir eq path and dfxDM.mode%2 eq 1 }"> checked="checked"</c:if></c:forEach>
									/></td>
									<td><input class="dmode<%=countId2 %>1 dmode_<%=countId2 %>" lay-skin="primary" name="dmode<%=countId2 %>1" type="checkbox" value=2<c:forEach items="${role.dfxDirModes }" var="dfxDM" ><c:if test="${dfxDM.dir eq path and (dfxDM.mode eq 2 || dfxDM.mode eq 3 || dfxDM.mode ge 6) }"> checked="checked"</c:if></c:forEach>
									/></td>
									<td><input class="dmode<%=countId2 %>2 dmode_<%=countId2 %>" lay-skin="primary" name="dmode<%=countId2 %>2" type="checkbox" value=4<c:forEach items="${role.dfxDirModes }" var="dfxDM" ><c:if test="${dfxDM.dir eq path and dfxDM.mode ge 4 }"> checked="checked"</c:if></c:forEach>
									/></td>
									<%countId2++; %>
								</tr>
								</c:if>
							</c:forEach>
				  		</table>
			  		</div>
				</div>
			  </div>
			</div>
	    </div>
	  </div>
	  <div class="layui-colla-item">
	    <h2 class="layui-colla-title">节点显示权限</h2>
	    <div class="layui-colla-content"><!--  layui-show -->
  			<div class="layui-row">
  				<div class="layui-col-xs6">
  					<div id="tree">
  				
  					</div>
  				</div>
  				<div class="layui-col-xs6">
  					<div style="display:none;position:fixed;top:50%;width:300px" id="userBoxTop">
	  					<label id="userBoxTop_node_name"></label>
  						<!-- <input class="layui-btn layui-btn-sm" type="button" value="全选" name="r2" onclick="selectall()">
					 	 <input class="layui-btn layui-btn-sm" type="button" value="清空" name="r2" onclick="noselect()">   -->
				  		 <SELECT name=userBox xm-select-placeholder="用户（空代表所有人有权限）" xm-select-skin="primary" xm-select="xm-select2" xm-select-type="2" lay-filter="xm-select2" xm-select-search id=userBox> 
				        </SELECT>
  					</div>
  				</div>
  			</div>
		</div>
	  </div>
	</div>
  	
  	<div class="layui-bg-gray mobile-hide" style="position:fixed;left:0px;bottom:0px;height:35px;width:100%">
	  	<input type="button" value="提交" onclick="form2_submit();"id="loginbtn" class="layui-btn layui-btn-sm"/>
  	</div>
</form>
</div>


	<div class="layui-container">
		<div style="margin-top:40px" class="layui-container">
		
		</div>
	</div>
	<div id="refreshDelPathDiv" style="display:none">
	<form name="dpForm" id="pathSelForm" action="">
		<select id="delPath" class="layui-select" style="height:30px;" name="delPath" value=""/>
			<c:forEach items="${pathArr }" var="path">
			<c:if test="${path ne 'dcts' and path ne 'vsbs' and path ne 'analyseFiles' and path ne 'dfx' and path ne 'rpx' and path ne 'dfxScript' and path ne 'inputFiles'}">
				<option value='${path }'>${path }</option>
			</c:if>
			</c:forEach>
		</select>
		<input type="button" value="删除" class="layui-btn layui-btn-danger" onclick="ajaxDelSubmit();"/>
	</form>
	</div>
	<br>
<script type="text/javascript">
var appmap = "<%=contextPath%>";
var raqdir = "<%=ReportConfig.raqsoftDir%>";
var userSelectedStatusJsonArray = ${userSelectedStatusJsonArray};

function refreshPathList(value){
	var j = <%=countId%>;
	var newPath_a = "<td><input type='hidden' id='countId' value='"+j+"'/>"
					+"<input onclick='changeValidity();' class='r_valid' name='r_valid"+j+"' type='checkbox' lay-skin='switch' lay-text='ON|OFF' lay-filter='switchTest' value='on'/>"
					+"</td>";
	var newPath_b = "<td><input name='enabledRptDir"+j+"' id='enabledRptDir"+j+"' type='hidden' value='"+value+"'/>"+value+"</td>\n";
	var newPath_c = "<td><input class='rmode"+j+"0 layui-input rmode_"+j+"' disabled lay-skin='primary' name='rmode"+j+"0' type='checkbox' value=1/></td>\n";
	var newPath_d = "<td><input class='rmode"+j+"1 layui-input rmode_"+j+"' disabled lay-skin='primary' name='rmode"+j+"1' type='checkbox' value=2/></td>\n";
	var newPath_e = "<td><input class='rmode"+j+"2 layui-input rmode_"+j+"' disabled lay-skin='primary' name='rmode"+j+"2' type='checkbox' value=4/></td>\n";
	<%countId++; %>
	$("#rpxPathTable").append($("<tr id='rpxTr_"+value+"'>\n"+newPath_a+newPath_b+newPath_c+newPath_d+newPath_e+"</tr>\n"));
	var k = <%=countId2%>;
	var newPath_f = "<td><input type='hidden' id='countId' value='"+k+"'/>"
					+"<input onclick='changeValidityDfx();' class='d_valid' name='d_valid"+k+"' type='checkbox' lay-skin='switch' lay-text='ON|OFF' lay-filter='switchTest' value='on'/>"
					+"</td>";
	var newPath_g = "<td><input name='enabledDfxDir"+k+"' id='enabledDfxDir"+k+"' type='hidden' value='"+value+"'/>"+value+"</td>\n";
	var newPath_h = "<td><input class='dmode"+k+"0 layui-input dmode_"+k+"' disabled lay-skin='primary' name='dmode"+k+"0' type='checkbox' value=1/></td>\n";
	var newPath_i = "<td><input class='dmode"+k+"1 layui-input dmode_"+k+"' disabled lay-skin='primary' name='dmode"+k+"1' type='checkbox' value=2/></td>\n";
	var newPath_j = "<td><input class='dmode"+k+"2 layui-input dmode_"+k+"' disabled lay-skin='primary' name='dmode"+k+"2' type='checkbox' value=4/></td>\n";
	<%countId2++; %>
	$("#dfxPathTable").append($("<tr id='dfxTr_"+value+"'>\n"+newPath_f+newPath_g+newPath_h+newPath_i+newPath_j+"</tr>\n"));
	layuiParse();
}

function layuiParse(){
	layui.use('form', function(){
		  var form = layui.form; 
		  form.render();
		  setTimeout(function(){
			  $('.layui-form-switch').bind("click" ,changeValidity);
		  },200);
		  
	});
}


function changeValidity(){
	var inputSwitch = this.parentNode.children[1];
	var inputCountId = this.parentNode.children[0];
	var index = inputCountId.value;
	if($(inputSwitch).val() == "on"){
		if(inputSwitch.name.charAt(0) == 'r'){
			$('.rmode_'+index)[0].removeAttribute("disabled");
			$('.rmode_'+index)[1].removeAttribute("disabled");
			$('.rmode_'+index)[2].removeAttribute("disabled");
		}else if(inputSwitch.name.charAt(0) == 'd'){
			$('.dmode_'+index)[0].removeAttribute("disabled");
			$('.dmode_'+index)[1].removeAttribute("disabled");
			$('.dmode_'+index)[2].removeAttribute("disabled");
		}
		$(inputSwitch).val("off");
	}else if($(inputSwitch).val() == "off"){
		if(inputSwitch.name.charAt(0) == 'r'){
			$('.rmode_'+index)[0].setAttribute("disabled",true);
			$('.rmode_'+index)[1].setAttribute("disabled",true);
			$('.rmode_'+index)[2].setAttribute("disabled",true);
		}else if(inputSwitch.name.charAt(0) == 'd'){
			$('.dmode_'+index)[0].setAttribute("disabled",true);
			$('.dmode_'+index)[1].setAttribute("disabled",true);
			$('.dmode_'+index)[2].setAttribute("disabled",true);
		}
		$(inputSwitch).val("on");
	}
	layuiParse();
	return false;
}

var userArray = [];
var formSelects = null;
var node_roleUser = {};
var currentRoleUser = ${users};
var currentSelectNode = null;
var data1 = ${treejson};
var isModify = ${role.id ne null};

$(function(){//初始化开关
	//tree	
	prepareUserSelect();
	treeInit();
	$('#userBoxTop').hide();
	
	layui.use('element', function(){
	    var element = layui.element; 
	    element.render();
	});
	tool_bindCharCheck($('#roleName'),["<",">",";"]);
	
	var device = navigator.userAgent;
	isMobile = device.toLowerCase().indexOf('mobile') >= 0;
	if(isMobile){
		$('.mobile-hide').hide();
	}
	
	layuiParse();
	setTimeout(function(){
		var swiItems = $('.layui-form-switch');
		for(var i = 0; i < swiItems.size(); i++){
			var index = $(swiItems[i].parentNode.children)[0].value;
			var tmp = $(swiItems[i].parentNode.children)[1];
			if(tmp.value == "off"){
				if(tmp.name.charAt(0) == 'r'){
					$('.rmode_'+index)[0].removeAttribute("disabled");
					$('.rmode_'+index)[1].removeAttribute("disabled");
					$('.rmode_'+index)[2].removeAttribute("disabled");
				}
				else if(tmp.name.charAt(0) == 'd'){
					$('.dmode_'+index)[0].removeAttribute("disabled");
					$('.dmode_'+index)[1].removeAttribute("disabled");
					$('.dmode_'+index)[2].removeAttribute("disabled");
				}
			}else if(tmp.value == "on"){
				if(tmp.name.charAt(0) == 'r'){
					$('.rmode_'+index)[0].setAttribute("disabled",true);
					$('.rmode_'+index)[1].setAttribute("disabled",true);
					$('.rmode_'+index)[2].setAttribute("disabled",true);
				}
				else if(tmp.name.charAt(0) == 'd'){
					$('.dmode_'+index)[0].setAttribute("disabled",true);
					$('.dmode_'+index)[1].setAttribute("disabled",true);
					$('.dmode_'+index)[2].setAttribute("disabled",true);
				}
			}
		} 
		layuiParse();
	},100);
	
	
	
	if(isMobile){
		$('.layui-col-xs-offset5').removeClass('layui-col-xs-offset5');
	}
	
});

function tool_bindCharCheck(elm, b){
	var bans = b == null ? ['<','>',';','\"'] : b;
	var ta = "以下字符被禁止:";
	for(var i = 0; i < bans.length; i++){
		ta += bans[i] + " ";
	}
	var t = $(elm).attr("title");
	$(elm).attr("title", (t == null ? "" : (t +",") )+ta);
	var l = $(elm).length;
	$(elm).bind('keyup',function(e){
		var v = e.target.value;
		for(var j = 0; j < bans.length; j++){
			if(v.indexOf(bans[j]) >= 0){
				v = removeCharForElm(e.target, v, bans[j]);
			}
		}
	});
	$(elm).change(function(e){
		var v = e.target.value;
		for(var j = 0; j < bans.length; j++){
			if(v.indexOf(bans[j]) >= 0){
				v = removeCharForElm(e.target, v, bans[j]);
			}
		}
	});
}

function contains(arr, value){
	  var index = $.inArray(value,arr);
	    if(index >= 0){
	        return true;
	    }
	    return false;
}
</script>
</body>
</html>
