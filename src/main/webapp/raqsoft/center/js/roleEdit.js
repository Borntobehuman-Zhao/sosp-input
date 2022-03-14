
function prepareUserSelect(){
	layui.config({
		base: appmap+raqdir+'/center/layui/'
	}).extend({
		formSelects: 'formSelects-rqedit'
	}).use('formSelects', function() {
		var form = layui.form;
		formSelects = layui.formSelects;
		form.render();   
		//userArray.push({name:'全选',val:'all',selected:false,disabled:true});
		var tempUserArray = userSelectedStatusJsonArray;
		console.log(userSelectedStatusJsonArray);
		for (var i = 0; i < tempUserArray.length; i++) {
			userArray.push(tempUserArray[i])
		}
		console.log(userArray);
		formSelects.render({
			name:'xm-select2',
			init:[],
			on:function(data,arr){
				
				var selectedUserVals = formSelects.value("xm-select2","val");
				var selectedFlag = contains(selectedUserVals, data.value);
				if(!selectedFlag){
					var roleUserOfCurrentSelectNode = node_roleUser[currentSelectNode];
					node_roleUser[currentSelectNode] = roleUserOfCurrentSelectNode.deleteValue(data.value);
					//减
				}else{
					node_roleUser[currentSelectNode].push(data.value);
					//增
				}
			}
			,data:{arr:userArray}
		});
	});
}

var tree;
function treeInit(){
	layui.use(['tree', 'util'], function(){
		tree = layui.tree
		//,layer = layui.layer
		,util = layui.util;
	  
		
		
		tree.render({
			    elem: '#tree'
			    ,data: data1
			    ,showCheckbox: true
			    ,id: 'tree1'
			    ,isJump: false //是否允许点击节点时弹出新窗口跳转
			    ,onlyIconControl: true
			    ,click: function(obj){
			        var node = obj.data;  //获取当前点击的节点数据
			        /*var isLeaf = node.leaf == null ? false : node.leaf;
			        var checked = node.checked == null ? false : node.checked;*/
			        var isLeaf = node.leaf == null ? false : node.leaf;
			        //通过role找到该node下设置的user
			        currentSelectNode = node.id;
					if(isLeaf){
						$('#userBoxTop').show();
						$('#userBoxTop_node_name').html(node.title);
					}else{
						$('#userBoxTop').hide();
					}
					var selectedUserVals = [];
					if(node_roleUser[node.id] != null){
						selectedUserVals = node_roleUser[node.id];
					}else{
						node_roleUser[node.id] = [];
					}
					console.log(selectedUserVals);
			        formSelects.value('xm-select2', selectedUserVals);
					//以下在初始化时候已经提取；
					return;
			        /*var selectedUserVals = [];//contain currentRoleUser
			        if(node.roles == null || node.roles.length == 0 || node.roles.indexOf(";") < 0){
			        	return;
			        }
			        var nodeUsersString = node.roles.split(";")[1];
			        nodeUsersString = nodeUsersString.split("=")[1];
			        
			        var nodeUsersHash = {};
			        var temp = "";
			        for (var i = 0; i < nodeUsersString.length; i++) {
			        	var ch = nodeUsersString.charAt(i);
			        	if(ch == ","){
			        		nodeUsersHash[temp] = temp;
			        		temp = "";
			        	}else if( i == nodeUsersString.length - 1 ){
			        		temp += ch;
			        		nodeUsersHash[temp] = temp;
			        	}else{
			        		temp += ch;
			        	}
					}
					if(isModify){
						for (var i = 0; i < currentRoleUser.length; i++) {
							if(nodeUsersHash[currentRoleUser[i]] != null){
								selectedUserVals.push(currentRoleUser[i]);
							}
						}
					}else{
						//新增不考虑刷新用户列表
						return;
					}
					
			        node_roleUser[node.id] = selectedUserVals;
			        formSelects.value('xm-select2', selectedUserVals);*/
			    }
		});
	  
	});
	
	var checkedNodes = tree.getChecked('tree1');
	//var result = [];
	//getLeafCheckedNodes(checkedNodes, result);
	checkedNodesDataInit(checkedNodes);
	
}

function checkedNodesDataInit(checkedNodes){
	for(var i = 0; i < checkedNodes.length; i++){
		if(checkedNodes[i].leaf){
			
			var node = checkedNodes[i];
			var nodeId = node.id;
	        var selectedUserVals = [];//contain currentRoleUser
	        if(node.roles == null || node.roles.length == 0 || node.roles.indexOf(";") < 0){
	        	return;
	        }
	        var nodeUsersString = node.roles.split(";")[1];
	        nodeUsersString = nodeUsersString.split("=")[1];
	        
	        var nodeUsersHash = {};
	        var temp = "";
	        for (var j = 0; j < nodeUsersString.length; j++) {
	        	var ch = nodeUsersString.charAt(j);
	        	if(ch == ","){
	        		nodeUsersHash[temp] = temp;
	        		temp = "";
	        	}else if( j == nodeUsersString.length - 1 ){
	        		temp += ch;
	        		nodeUsersHash[temp] = temp;
	        	}else{
	        		temp += ch;
	        	}
			}
			for (var k = 0; k < currentRoleUser.length; k++) {
				if(nodeUsersHash[currentRoleUser[k]] != null){
					selectedUserVals.push(currentRoleUser[k]);
				}
			}
			node_roleUser[nodeId] = selectedUserVals;
			
		}else{
			checkedNodesDataInit(checkedNodes[i].children)
		}
	}
	
}

function getLeafCheckedNodes(checkedNodes, result){
	for(var i = 0; i < checkedNodes.length; i++){
		if(checkedNodes[i].leaf){
			result.push(checkedNodes[i]);
		}else{
			getLeafCheckedNodes(checkedNodes[i].children, result)
		}
	}
}

function form2_submit(){
	var url = form2.action;
	var roleId = form2.roleId;
	var showReportOperButton = form2.showReportOperButton;
	var showFileOperButton = form2.showFileOperButton;
	if(roleId != null){
		//url += "&roleId="+roleId.value;
	}
	//基础
	/*if(showReportOperButton != null){
		url += "&showReportOperButton="+showReportOperButton.checked;
	}else{
		url += "&showReportOperButton=false";
	}
	if(showFileOperButton != null){
		url += "&showFileOperButton="+showFileOperButton.checked;
	}else{
		url += "&showFileOperButton=false";
	}*/
	var dbs = form2.dbcheck;
	var dbstr = "";
	for(var i = 0; i < dbs.length; i++){
		if(dbs[i].checked != true){
			continue;
		}
		if(dbstr.length > 0){
			dbstr += ";";
		}
		if(dbs[i].checked){
			dbstr += dbs[i].value;
		}
	}
	if(dbstr.length > 0){
		//url += "&dsList=" + dbstr;
	}
	var name = form2.roleName;
	if(name.value != null && name.value.length != 0){
		//url += "&name="+encodeURIComponent(name.value);
	}else{
		alert("机构名不可为空！");
		return;
	}
	var rdms = "";
	var rdm = null;
	var count = 0;
	while(eval("form2.enabledRptDir"+count) != null){
		rdm = eval("form2.enabledRptDir"+count);
		var validCheck = eval("form2.r_valid"+count);
		if( rdm.value == null || rdm.value.length == 0 || validCheck.value=="on") {
			count++;
			continue;
		}
		var tmp1 = rdm.value;
		var authPlus = 0;
		for(var j=0;j<3;j++){
			rdm = eval("form2.rmode"+count+j);
			if(!rdm.disabled && rdm.checked) authPlus += parseInt(rdm.value);
		}
		if(rdms.length > 0){
			rdms += ";"
		}
		rdms += tmp1 + "," + authPlus;
		count++;
	}
	count = 0;
	var ddms = "";
	var ddm = null;
	while(eval("form2.enabledDfxDir"+count) != null){
		var validCheckDfx = eval("form2.d_valid"+count);
		ddm = eval("form2.enabledDfxDir"+count);
		if( ddm.value == null || ddm.value.length == 0 || validCheckDfx.value=="on") {
			count++;
			continue;
		}
		var tmp2 = ddm.value;
		var authPlus = 0;
		for(var j=0;j<3;j++){
			ddm = eval("form2.dmode"+count+j);
			if(!ddm.disabled &&ddm.checked) authPlus += parseInt(ddm.value);
		}
		if(ddms.length > 0){
			ddms += ";"
		}
		ddms += tmp2 + "," + authPlus;
		count++;
	}
	/*if(rdms != null){
		url += "&dirmodeRptList="+rdms;
	}
	
	if(ddms != null){
		url += "&dirmodeDfxList="+ddms;
	}*/
	var treeRightDataJson = {};
	getTreeRightData(null, treeRightDataJson);
	$.ajax({
		data:{
			roleId: roleId.value,
			showFileOperButton: (showFileOperButton != null ? showFileOperButton.checked : false), 
			showReportOperButton: (showReportOperButton != null ? showReportOperButton.checked:false),
			dsList: dbstr,
			dirmodeRptList: rdms,
			dirmodeDfxList: ddms,
			name: name.value,
			treeRightDataJson:JSON.stringify(treeRightDataJson)
		},
		url:url,
		type:"post",
		success:function(str){
			if(str == "success"){
				alert("保存成功");
				/*if(!isMobile){
					top.window.document.getElementById('leftF').src="<%=contextPath%>/reportCenterServlet?action=34";
				}*/
			}else{
				alert("error:"+str);
			}
		}
	});
}

function getTreeRightData(checkedNodes, result){
	if(checkedNodes == null) checkedNodes = tree.getChecked("tree1");
	for(var i = 0; i < checkedNodes.length; i++){
		if(checkedNodes[i].leaf){
			var users = [];
			users = node_roleUser[checkedNodes[i].id] == null ? [] : node_roleUser[checkedNodes[i].id];
			result[checkedNodes[i].id] = {node:checkedNodes[i].id,users:users}
		}else{
			getTreeRightData(checkedNodes[i].children, result)
		}
	}
}