<%@ page contentType="text/html;charset=UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page isELIgnored="false" %> 
<%@ page import="com.raqsoft.report.view.*"%>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">

<%
	String contextPath = request.getContextPath();
%>
<html>
<head>
<script src="<%=contextPath%>/js/jquery.js"></script>
<script src="<%=contextPath%><%=ReportConfig.raqsoftDir%>/center/util.js"></script>
<script src="<%=contextPath%><%=ReportConfig.raqsoftDir%>/center/layui/layui.all.js"></script>
<link rel="stylesheet" href="<%=contextPath%><%=ReportConfig.raqsoftDir%>/center/layui/css/layui.css">
<script type="text/javascript">
	function add(){
		var agent = navigator.userAgent;
		if(agent.toLowerCase().indexOf("mobile")>=0){
			top.window.location = "<%=contextPath%><%=ReportConfig.raqsoftDir%>/center/mobile/jsp/outfitForm.jsp?submitFunction=form2_submit&inner=<%=contextPath%>/reportCenterServlet?action=35%26userAction%3D32" + "%26roleId";
		}else{
			top.document.getElementById("showProp").setAttribute("src", "<%=contextPath%>/reportCenterServlet?action=35&userAction=32" + "&roleId");
		}
	}
	
	function modify(roleId){
		var agent = navigator.userAgent;
		if(agent.toLowerCase().indexOf("mobile")>=0){
			top.window.location = "<%=contextPath%><%=ReportConfig.raqsoftDir%>/center/mobile/jsp/outfitForm.jsp?submitFunction=form2_submit&inner=<%=contextPath%>/reportCenterServlet?action=35%26userAction%3D33" + "%26roleId%3D" + roleId;
		}else{
			top.document.getElementById("showProp").setAttribute("src","<%=contextPath%>/reportCenterServlet?action=35&userAction=33" + "&roleId=" + roleId);
		}
	}
	
	function deleteSelect(){
		var delRoleIds = new Array();
		var subGo=0;
	  for(var i=0;i<document.forms.form3.elements.length;i++){
        if(document.forms.form3.elements[i].type=="checkbox"){
		  if(document.forms.form3.elements[i].checked){
			  if(document.forms.form3.elements[i].name=='selectAll'){
				  continue;
			  }
			  delRoleIds[delRoleIds.length] = document.forms.form3.elements[i].value;
			  subGo++;
		   }
	    }
	   }
	    if(subGo<1){
		   alert("您没有选择！");
		   return ;
	    }
        if(window.confirm("确认要删除 请确认！")==false)return;
        document.forms.form3.action = '<%=contextPath%>/reportCenterServlet?action=-32&delRoleIds='+ delRoleIds;
        document.forms.form3.submit();
		//top.document.getElementById("showProp").setAttribute("src", "<%=contextPath%>/reportCenterServlet?action=34");
    }

	function clearSelect(){
	  var subGo=0;
	  var clsPwdUserIds = new Array();
	  for(var i=0;i<document.forms.form3.elements.length;i++){
	        if(document.forms.form3.elements[i].type=="checkbox"){
			  if(document.forms.form3.elements[i].checked){
				  clsPwdUserIds[clsPwdUserIds.length] = document.forms.form3.elements[i].value;
				  subGo++;
			   }
		   }
	  }

      if(subGo<1){
	     alert("您没有选择！");
	     return ;
      }
      
      if(window.confirm("确认要清除密码 请确认！")==false)return;
         document.forms.form3.action = '<%=contextPath%>/reportCenterServlet?action=29';
         document.forms.form3.submit();
      }

 	function selectAll(form3 ){
	  for(var i=0;i<form3.elements.length;i++){
        if(form3.elements[i].type=="checkbox"){
					 form3.elements[i].checked = true;
	     }
	   }
 	}
 	
 	function clearAll(form3 ){
	  for(var i=0;i<form3.elements.length;i++){
        if(form3.elements[i].type=="checkbox"){
					 form3.elements[i].checked = false;
	     }
	   }
 	}

	window.onload = function(){
 		var device = navigator.userAgent;
		var isMobile = device.indexOf('Mobile') >= 0;
 	};
 	
 	$(function(){
 		$('li.layui-nav-item').bind("click",function(event){
 			layItem_Li_change(event.target);
 		});
 	});
 	
 	function layItem_Li_change(elm){
 		if(elm.tagName == "LI"){
 			$(elm).toggleClass("layui-nav-itemed");
 			return;
		}else{
			layItem_Li_change(elm.parentNode);
		}
 	}
 	
 	function selectAllToggle(){
 		if($(form3.selectAll).prop("checked") == true){
 			selectAll(form3);
 		}else{
 			clearAll(form3);
 		}
 	}
 	
 	function setConfigs(){
 		layui.use("layer",function(){});
 		var title = "权限参数配置";
 		var hasOkBtn = true;
 		var url = "<%=contextPath%>/reportCenterServlet";
 		var getdata = {
			action:78,
			act:3,//1,set;2,remove;3,get
			act2:3,//1,set;2,remove;3,get
			tagName:'unap',
			tagName2:'rnap'
 		};
 		$.ajax({
 			url:url,
			data:getdata,
			type:'get',
			success:function(str){
				var getParamName = "";
				var roleNameParam = "";
				var vimg = "";
				var layer_index = -1;
				if(str){
					str = str.split("|||");
					getParamName = str[0] == "no_value"?"":str[0];
					roleNameParam = str[1] == "no_value"?"":str[1];
					vimg = str[2] == "no_value"?true:(str[2]=="1"?true:false);
					asip = str[3] == "no_value"?true:(str[3]=="1"?true:false);
					var okFunc = function(){
						
						/* 
						
							{
								unap:{enabled:false,value:pn1,changed:true},
								rnap:{enabled:false,value:pn2,chenged:false},
								validImg:{enabled:false,value:false,changed:false},
								asip:{enabled:false,value:false,changed:false}
							}
						*/
						
			 			var allow = $('#unap')[0].checked;
			 			var paramName = $('#pn').val();
			 			var act = 1;
			 			
			 			var allow2 = $('#rnap')[0].checked;
			 			var paramName2 = $('#pn2').val();
			 			var act2 = 1;
			 			
			 			var validImg = $('#validImg')[0].checked;
			 			var asip = $('#asip')[0].checked;
			 			if(!allow){
			 				act = 2;
				 			paramName = null;
			 			}
			 			if(!allow2){
			 				act2 = 2;
				 			paramName2 = null;
			 			}
			 			/* var data = {
			 				action:78,
			 				act:act,
			 				act2:act2,
			 				value:paramName,
			 				value2:paramName2,
			 				tagName:'unap',
			 				tagName2:'rnap',
			 				validImg:validImg,
			 				asip:asip
			 			}; */
			 			
			 			data = {};
			 			data.unap = {
			 					enabled:allow,
			 					value:paramName,
			 					changed:true
			 			};
			 			
			 			data.rnap = {
			 					enabled:allow2,
			 					value:paramName2,
			 					changed:true
			 			};
			 			
			 			data.validImg = {
			 					enabled:validImg,
			 					value:validImg,
			 					changed:false
			 			};
			 			
			 			data.asip = {
			 					enabled:asip,
			 					value:asip,
			 					changed:false
			 			};
			 			
			 			$.ajax({
			 				url:url,
			 				data:{action:781,j:JSON.stringify(data)},
			 				type:'post',
			 				success:function(str){
			 					window.layui.layer.close(layer_index);
			 				}
			 			});
			 		};
			 		var contentHtml = "<table style='width:100%;text-align:center'>";
			 		contentHtml += "<tr style='display:none'>";
			 		contentHtml += "<td>";
			 		contentHtml += "启用登录验证码";
			 		contentHtml += "</td>";
			 		contentHtml += "<td>";
			 		contentHtml += "</td>";
			 		contentHtml += "</tr>";
			 		contentHtml += "<tr style='display:none'>";
			 		contentHtml += "<td>";
			 		if(vimg) contentHtml += "<input id='validImg' type='checkbox' checked=true/>";
			 		else contentHtml += "<input id='validImg' type='checkbox' />";
			 		contentHtml += "</td>";
			 		contentHtml += "<td>";
			 		contentHtml += "</td>";
			 		contentHtml += "</tr>";
			 		contentHtml += "<tr style='display:none'>";
			 		contentHtml += "<td>";
			 		contentHtml += "密码必须包含特殊字符";
			 		contentHtml += "</td>";
			 		contentHtml += "<td>";
			 		contentHtml += "</td>";
			 		contentHtml += "</tr>";
			 		contentHtml += "<tr style='display:none'>";
			 		contentHtml += "<td>";
			 		if(asip) contentHtml += "<input id='asip' type='checkbox' checked=true/>";
			 		else contentHtml += "<input id='asip' type='checkbox' />";
			 		contentHtml += "</td>";
			 		contentHtml += "<td>";
			 		contentHtml += "</td>";
			 		contentHtml += "</tr>";
			 		contentHtml += "<tr>";
			 		contentHtml += "<td>";
			 		contentHtml += "使用机构名称作为参数";
			 		contentHtml += "</td>";
			 		contentHtml += "<td>";
			 		contentHtml += "设置参数名称";
			 		contentHtml += "</td>";
			 		contentHtml += "</tr>";
			 		contentHtml += "<tr>";
			 		contentHtml += "<td>";
			 		if(roleNameParam!="") contentHtml += "<input id='rnap' type='checkbox' checked=true/>";
			 		else contentHtml += "<input id='rnap' type='checkbox' />";
			 		contentHtml += "</td>";
			 		contentHtml += "<td>";
			 		contentHtml += "<input tyle='float:left' id='pn2' type='text' value='"+roleNameParam+"'/>";
			 		contentHtml += "</td>";
			 		contentHtml += "</tr>";
			 		contentHtml += "<tr>";
			 		contentHtml += "<td>";
			 		contentHtml += "使用用户名作为参数";
			 		contentHtml += "</td>";
			 		contentHtml += "<td>";
			 		contentHtml += "设置参数名称";
			 		contentHtml += "</td>";
			 		contentHtml += "</tr>";
			 		contentHtml += "<tr>";
			 		contentHtml += "<td>";
			 		if(getParamName!="") contentHtml += "<input id='unap' type='checkbox' checked=true/>";
			 		else contentHtml += "<input id='unap' type='checkbox' />";
			 		contentHtml += "</td>";
			 		contentHtml += "<td>";
			 		contentHtml += "<input tyle='float:left' id='pn' type='text' value='"+getParamName+"'/>";
			 		contentHtml += "</td>";
			 		contentHtml += "</tr>";
			 		contentHtml += "</table>";
			 		layer_index = popLayuiLayer(title,contentHtml,hasOkBtn,okFunc, null, '500px');
				}else{
					alert("error get");
				}
			}
 		});
 	}
</script>
<style>

table thead, tbody tr {
    table-layout: fixed;
}

.roleTableFixedHead{
	z-index: 1;
	background-color: white
}

.roleTable{
	top:130px;
	margin-top:0px;
	margin-bottom:0px
}

</style>
</head>
<body>
<form action="<%=contextPath %>/" method="post" id="form3">
	<div class="roleTableFixedHead">
		<div align="center">
			<div style="margin-top:50px" class="layui-container">
			<div class="layui-bg-white layui-layout" style="height:40px;margin-left: 20px;margin-top: 50px;">
				<div class="layui-row">
				    <div class="layui-col-xs1">
				    <button  style="cursor: pointer;"  class="layui-btn layui-bg-green layui-btn-sm" onclick="add();return false;"><i class="layui-icon">&#xe654;</i>添加</button>
				    </div>
				    <div class="layui-col-xs1">
				    <button style="cursor: pointer;" class="layui-btn layui-bg-red layui-btn-sm" onclick="deleteSelect();return false;"><i class="layui-icon">&#xe640;</i>删除</button>
				    </div>
				    <div class="layui-col-xs1">
				    <button style="cursor: pointer;" class="layui-btn layui-bg-blue layui-btn-sm" onclick="setConfigs();return false;"><i class="layui-icon">&#xe614;</i>设置</button>
					    </div>
					</div>
				</div>
			</div>
		</div>
		<div class="layui-container">
		<table class="layui-table roleTable" align="center" title="机构管理"> 
		<colgroup><col width="10%"/><col width="20%"/><col width="40%"/></colgroup>
	   		<thead class="layui-bg-gray">
	   			<td style=""><input name="selectAll" type="checkbox" onchange="selectAllToggle();"></td>
	   			<td>机构名称</td>
	   			<td>现有用户</td>
	   		</thead>
	   	</table>
		</div>
	</div>
   	<div class="roleTableBody layui-container">
   		<table class="layui-table roleTable" align="center" title="机构管理"> 
		<colgroup><col width="10%"/><col width="20%"/><col width="40%"/></colgroup>
    		<c:forEach items="${roleArr }" var="role">
    		<c:if test="${role.id ne null and role.id ne '0'}">
    		<c:set var="userList" value="${r_u_map[role.id] }"></c:set>
    			<tr>
    				<td>
    				<c:if test="${role.id ne '-1' and role.id ne '1'}">
     			<input name="selectRole" type="checkbox" value="${role.id }">
     			</c:if>
     			</td>
     			<td <c:if test="${role.id eq '1'}">style="color:#DDD"</c:if> <c:if test="${role.id ne '1'}">onclick="modify('${role.id}');"</c:if>>${role.name }</td>
     			<td <c:if test="${role.id ne '1'}">onclick="modify('${role.id}');"</c:if>>
     			<span style="color:#E0C0A0">
     				(${fn:length(userList) })
     				<c:forEach items="${userList }" var="user">
     					${user.userName }
     				</c:forEach>
     			</span>
     			</td>
     		</tr>
    		</c:if>
    		</c:forEach>
    	</table>
   	</div>
</form>
  
     	
</body>
</html>
