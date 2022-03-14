var appRoot,labelColor, mouseOverColor, selectedColor, selectedBackColor;
var currNode;
//document.onmousemove = tree_unselectText;

function tree_unselectText() {
	document.selection.empty();
}

function tree_setEnv( app, lc, moc, sc, sbc ) {
	appRoot = app;
	labelColor = lc;
	mouseOverColor = moc;
	selectedColor = sc;
	selectedBackColor = sbc;
}

function tree_addSubNode() {
	if( currNode == null ) {
		alert( "请先选择一个节点!" );
		return;
	}
	if( currNode.type == "1" ) {
		alert( "不能在报表节点下添加子节点！" );
		return;
	}
	if( currNode.type == "2" ) {
		alert( "不能在超链接节点下添加子节点！" );
		return;
	}
	window.top.showRightSideMengban();
	var iframe = parent.document.getElementById("showProp");
//	iframe.onload = function() {
//		window.top.hideRightSideMengban();
//	};   
	iframe.src = appmap_js+"/raqsoft/center/addSubNode.jsp?action=1&id=" + currNode.getAttribute("nodeid");
}

function tree_insertNode() {
	if( currNode == null ) {
		alert( "请先选择一个节点!" );
		return;
	}
	parent.document.getElementById("showProp").src = appmap_js+"/raqsoft/center/addSubNode.jsp?action=2&id=" + currNode.getAttribute("nodeid");
}

function tree_moveNode( updown ) {
	
	if( currNode == null ) {
		alert( "请先选择一个树节点!" );
		return;
	}
	$.ajax({
		type:"post",
		url:appmap_js + "/reportCenterServlet?action=9&id="+currNode.getAttribute("nodeid")+"&flag="+updown,
		data:{},
		success:function(strRet){
			tree_setCurrNode( document.getElementById( "id_" + strRet.substring( 8 ) ), false );
		},
		error:function(){
			alert( "移动节点时错误:\n" + strRet );
		}
	});
}

function tree_deleteNode() {
	if( currNode == null ) {
		alert( "请先选择一个节点!" );
		return;
	}
	if( currNode.id == "id_0" ) return;
	var name = currNode.getAttribute("label");
	if( !window.confirm( "删除后将不能恢复，真的要删除“" + name + "”节点吗？" ) ) return;
	$.ajax({
		type:"post",
		url:appmap_js + "/reportCenterServlet?action=8&id="+currNode.getAttribute("nodeid"),
		data:{},
		success:function(strRet){
			if( strRet == "nomore" ){
				tree_setCurrNode( document.getElementById( "id_0" ), false );
			}else{
				tree_setCurrNode( document.getElementById( "id_" + strRet.substring( 8 ) ), false );
			}
		},
		error:function(){
			alert( "删除节点时错误:\n" + strRet );
		}
	});
}

function tree_iconClick( obj ) {
	if( obj == null ) return;
   	var subdiv = document.getElementById( "_div_" + obj.id.substring( 5 ) );
   	if( subdiv == null ) return;
   	var nodeValue = obj.attributes.getNamedItem( "nodevalue" );
   	var id = $(obj).attr("id").split("_");
   	id = id[id.length-1];
   	var oldnodevalue = nodeValue.value;
   	if( oldnodevalue == "0" || oldnodevalue == "2" )
      	subdiv.style.display = "";
   	if( oldnodevalue == "0" ) {
      	nodeValue.value = "1"; 
      	$('#_nodeimg_'+id).removeClass();
      	$('#_nodeimg_'+id).addClass("fa fa-folder-open-o fa-flip-vertical");
      	$(obj).html("&#xe625;");//配合layui图标文字图标，此处必须用jquery
   	}
   	if( oldnodevalue == "2" ) {
      	nodeValue.value = "3";
      	$('#_nodeimg_'+id).removeClass();
      	$('#_nodeimg_'+id).addClass("fa fa-folder-open-o fa-flip-vertical");
      	$(obj).html("&#xe625;");
   	}
   	if( oldnodevalue == "1" || oldnodevalue == "3" )
      	subdiv.style.display = "none";
   	if( oldnodevalue == "1" ) {
      	nodeValue.value = "0"; 
      	$('#_nodeimg_'+id).removeClass();
      	$('#_nodeimg_'+id).addClass("fa fa-folder");
      	$(obj).html('&#xe623;');
   	}
   	if( oldnodevalue == "3" ) {
      	nodeValue.value = "2"; 
      	$('#_nodeimg_'+id).removeClass();
      	$('#_nodeimg_'+id).addClass("fa fa-folder");
      	$(obj).html('&#xe623;');
   	}
}

function tree_setCurrNode( node, noRefreshProp ) {
	if( node == null ) return;
	if( currNode != null ) {
		currNode.style.backgroundColor = "";
		currNode.style.color = labelColor;
	}
	node.style.backgroundColor = selectedBackColor;
	node.style.color = selectedColor;
	currNode = node;
	var type1 = currNode.getAttribute("type");
	var plusUrl = "";
	if( type1 == "3" ){
		plusUrl = "&dqldb="+currNode.getAttribute("dqldb")
				+ "&dct="+encodeURIComponent(currNode.getAttribute("dct"))
				+ "&vsb="+encodeURIComponent(currNode.getAttribute("vsb"))
				+ "&qyx="+encodeURIComponent(currNode.getAttribute("qyx"))
				+ "&queryType=" + currNode.getAttribute("queryType")
				+ "&fixedTable=" + encodeURIComponent(currNode.getAttribute("fixedTable"));
	}
	if( type1 == "4" ){
		plusUrl += "&analyseFile="+encodeURIComponent(currNode.getAttribute("anaFile"))
				+ "&analyseType=" + currNode.getAttribute("analyseType")
				+ "&analyseDB=" + currNode.getAttribute("analyseDB")
				+ "&analyseSQL=" + encodeURIComponent(currNode.getAttribute("analyseSQL"))
				+ "&analyseTables=" + encodeURIComponent(currNode.getAttribute("analyseTables"))
				+ "&anaDqldb=" + encodeURIComponent(currNode.getAttribute("anaDqldb"))
				+ "&dfxScript=" + encodeURIComponent(currNode.getAttribute("dfxScript"))
				+ "&dfxParams=" + encodeURIComponent(currNode.getAttribute("dfxParams"))
				+ "&insideFileTable="+ encodeURIComponent(currNode.getAttribute("iftn"));
	}
	if( type1 == "5" ){
		plusUrl += "&busiDir="+ encodeURIComponent(currNode.getAttribute("busiDir"))
				+"&dataFileType="+ encodeURIComponent(currNode.getAttribute("dataFileType"));
	}
	if( type1 == "6" ){
		plusUrl += "&aggrDataFiles="+ encodeURIComponent(currNode.getAttribute("aggrDataFiles"));
	}
	if( type1 == "7" ){
		plusUrl += "&cq_json="+ encodeURIComponent(currNode.getAttribute("cq_json"))
				+ "&cq_dfx="+ encodeURIComponent(currNode.getAttribute("cq_dfx"))
				+ "&cq_rpx="+ encodeURIComponent(currNode.getAttribute("cq_rpx"));
	}
	var useJsp = "default";
	useJsp = currNode.getAttribute("useJsp");
	plusUrl += "&useJsp="+useJsp;
	var iframe = parent.document.getElementById("showProp");
	if( currNode.id != "id_0" && !noRefreshProp ) {
	    /*if ( currNode.type == '0'){
	        nodePage = 'deployReportTabs.jsp?';
	    }*/
	   var nodeUrl = appmap_js+"/raqsoft/center/addSubNode.jsp?id=" + currNode.getAttribute("nodeid") 
				+ "&type=" + currNode.getAttribute("type")  
				+ "&url=" + urlEncode( currNode.getAttribute("url") ) 
				+ "&label=" + encodeURIComponent(currNode.getAttribute("label")) 
				+ "&roles=" + currNode.getAttribute("roles") 
				+ "&rpt=" + encodeURIComponent(currNode.getAttribute("rpt")) 
				+ "&form=" + encodeURIComponent(currNode.getAttribute("form"))
				+ "&scale=" + currNode.getAttribute("scale") 
				+ "&paged=" + currNode.getAttribute("paged") 
				+ "&scroll=" + currNode.getAttribute("scroll") 
				+ "&isTree=" + currNode.getAttribute("istree")
				+ "&isOlap=" + currNode.getAttribute("isolap")
				+ "&params=" + encodeURIComponent( currNode.getAttribute("params") ) 
				+ "&query=" + encodeURIComponent( currNode.getAttribute("query") )
				+ plusUrl;
	   window.top.showRightSideMengban();
	   iframe.onload = function() {
    	   window.top.hideRightSideMengban();
    	   var s = tree_getNodeExpanded();
    	   window.location.replace( "tree.jsp?status=" + s + ","+currNode.id.substring(3)+",1"+"&position=" + window.document.body.scrollTop + "&currId="+currNode.id.substring(3) );		   	
       };   

	   iframe.src = nodeUrl;
	}
	if( currNode.id == "id_0" && !noRefreshProp ) {
		iframe.src = "treeProperty.jsp?label=" + encodeURIComponent( currNode.getAttribute("label") ) + "&rpt=" + encodeURIComponent(currNode.getAttribute("rpt")) + "&form=" + 
		encodeURIComponent(currNode.getAttribute("form")) + "&url=" + encodeURIComponent( currNode.getAttribute("url")  ) + "&scale=" + currNode.getAttribute("scale") + "&paged=" + currNode.getAttribute("paged") + 
			"&scroll=" + currNode.getAttribute("scroll") + plusUrl;
	}
	showToolButtons( currNode , false );
}

function showToolButtons( node , isRootNode ){//按钮有效性
	if(node == null){
		return;
	}
	$('button').prop("disabled",true);
	var tr = node.parentElement || node.parentNode;
	var type = node.getAttribute("type");
	if(isRootNode){
		$('button#add').prop("disabled",false);
		$('button#show').prop("disabled",false);
		$('button#ins').children('.ic ').css('color','#BBB');
		$('button#up').children('.ic').css('color','#BBB');
		$('button#down').children('.ic').css('color','#BBB');
		$('button#del').children('.ic').css('color','#BBB');
		return;
	}
	if(type == "0"){
		$('button#add').prop("disabled",false);
		$('button#show').children('.ic').css('color','#BBB');
	}else{
		$('button#add').children('.ic').css('color','#BBB');
		$('button#show').prop("disabled",false);
	}
	$('button#ins').prop("disabled",false);
	$('button#up').prop("disabled",false);
	$('button#down').prop("disabled",false);
	$('button#del').prop("disabled",false);
	
	
	var buttons = $('button');
	for(var b = 0 ; b < buttons.length ; b++){
		if(!$(buttons[b]).prop("disabled")){
			if($(buttons[b]).attr("enterColor") == null){
				$(buttons[b]).attr("enterColor","black");
			}
			if($(buttons[b]).attr("leaveColor") == null){
				$(buttons[b]).attr("leaveColor","gray");
			}
			$(buttons[b]).attr("onmouseenter","changeColor('"+buttons[b].id+"','"+$(buttons[b]).attr("enterColor")+"')");
			$(buttons[b]).attr("onmouseleave","changeColor('"+buttons[b].id+"','"+$(buttons[b]).attr("leaveColor")+"')");
			$(buttons[b]).children('.ic').css('color','black');
		}
	}
}

function changeColor(button, color){
	$('#'+button).children('.ic').css("color",color);
}

function tree_nodeClick( node ) {
	var icon = document.getElementById( "_img_" + node.getAttribute("nodeid") );
	var subdiv = document.getElementById( "_div_" + node.getAttribute("nodeid")  );
	if( icon == null && subdiv != null ) 
		if( subdiv.style.display == "" ) subdiv.style.display = "none";
		else subdiv.style.display = "";
	if( subdiv != null ) {
		tree_iconClick( document.getElementById( "_img_" + node.getAttribute("nodeid") ) );
	}
	tree_setCurrNode( node );
}

function tree_nodeDoubleClick( node ) {
	tree_nodeClick( node );
	/*var icon = document.getElementById( "_img_" + node.getAttribute("nodeid") );
	var subdiv = document.getElementById( "_div_" + node.getAttribute("nodeid")  );
	if( icon == null && subdiv != null ) 
		if( subdiv.style.display == "" ) subdiv.style.display = "none";
		else subdiv.style.display = "";
	if( subdiv != null ) {
		tree_iconClick( document.getElementById( "_img_" + node.getAttribute("nodeid") ) );
	}
	tree_setCurrNode( node );*/
}

function tree_mouseOverNode( node ) {
	if( node != currNode ) node.style.color = mouseOverColor;
}

function tree_mouseOutNode( node ) {
	if( node != currNode ) node.style.color = labelColor;
}

function tree_getNodeExpanded() {
	return tree_getDivExpanded( document.body );
}

function tree_getDivExpanded( pobj ) {
	var s = "";
	for( var i = 0; i < pobj.childNodes.length; i++ ) {
		var obj = pobj.childNodes[i];
		if( obj.tagName == "DIV" ) {
			if( obj.id.indexOf( "_div_" ) == 0 ) {
				var status = "1";
				if( obj.style.display == "none" ) status = "0";
				if( s.length > 0 ) s += ",";
				s += obj.id.substring( 5 ) + "," + status;
			}
		}
		var rtn = tree_getDivExpanded( obj );
		if( rtn.length > 0 ) {
			if( s.length > 0 ) s += ",";
			s += rtn;
		}
	}
	return s;
}

function tree_restoreStatus( nodesStatus, position, currId ) {
   	tree_setCurrNode( document.getElementById( "id_" + currId ), true );
   	var includeCurrNode = false;
	var ids = nodesStatus.split( "," );
	for( var i = 0; i < ids.length; i += 2 ) {
		if( currNode != null && ids[i] == currNode.getAttribute("nodeid") ) includeCurrNode = true;
		if( ids[i] == "0" ) continue;
		if( ids[i+1] == "1" ) {
   			var subdiv = document.getElementById( "_div_" + ids[i] );
   			if( subdiv == null ) continue;
	      	subdiv.style.display = "";
   			var obj = document.getElementById( "_img_" + ids[i] );
   			var nodeValue = obj.attributes.getNamedItem( "nodevalue" );
   			var oldnodevalue = nodeValue.value;
   			if( oldnodevalue == "0" ) {
      			nodeValue.value = "1";      
      			$('#_nodeimg_'+ids[i]).removeClass();
      	      	$('#_nodeimg_'+ids[i]).addClass("fa fa-folder");
      			$(obj).html("&#xe625;");
   			}
   			if( oldnodevalue == "2" ) {
      			nodeValue.value = "3";   
      			$('#_nodeimg_'+ids[i]).removeClass();
      	      	$('#_nodeimg_'+ids[i]).addClass("fa fa-folder-open-o fa-flip-vertical");
      			$(obj).html("&#xe625;");
   			}
   		}
   	}
   	if( currNode != null && !includeCurrNode ) tree_iconClick( document.getElementById( "_img_" + currNode.getAttribute("nodeid") ) );
   	document.getElementById('treeContainer').scrollTop = position;
}

function urlEncode( str )
{
	var dst = "";
	for ( var i = 0; i < str.length; i++ )
	{
		switch ( str.charAt( i ) )
		{
			case ' ':
				dst += "+";
				break;
			case '!':
				dst += "%21";
				break;
			case '\"':
				dst += "%22";
				break;
			case '#':
				dst += "%23";
				break;
			case '$':
				dst += "%24";
				break;
			case '%':
				dst += "%25";
				break;
			case '&':
				dst += "%26";
				break;
			case '\'':
				dst += "%27";
				break;
			case '(':
				dst += "%28";
				break;
			case ')':
				dst += "%29";
				break;
			case '+':
				dst += "%2B";
				break;
			case ',':
				dst += "%2C";
				break;
			case '/':
				dst += "%2F";
				break;
			case ':':
				dst += "%3A";
				break;
			case ';':
				dst += "%3B";
				break;
			case '<':
				dst += "%3C";
				break;
			case '=':
				dst += "%3D";
				break;
			case '>':
				dst += "%3E";
				break;
			case '?':
				dst += "%3F";
				break;
			case '@':
				dst += "%40";
				break;
			case '[':
				dst += "%5B";
				break;
			case '\\':
				dst += "%5C";
				break;
			case ']':
				dst += "%5D";
				break;
			case '^':
				dst += "%5E";
				break;
			case '`':
				dst += "%60";
				break;
			case '{':
				dst += "%7B";
				break;
			case '|':
				dst += "%7C";
				break;
			case '}':
				dst += "%7D";
				break;
			case '~':
				dst += "%7E";
				break;
			default:
				dst += str.charAt( i );
				break;
		}
	}
	return dst;
}

//2017.12.22
function report_nodeClick( node ){
	var icon = document.getElementById( "_img_" + node.getAttribute("nodeid") );
	var subdiv = document.getElementById( "_div_" + node.getAttribute("nodeid")  );
	if( node.getAttribute("nodeid") != 0 && icon == null && subdiv != null ) 
		if( subdiv.style.display == "" ) subdiv.style.display = "none";
		else subdiv.style.display = "";
	if( subdiv != null ) {
		tree_iconClick( document.getElementById( "_img_" + node.getAttribute("nodeid") ) );
	}
	
	top.window.currReport = "/"+node.getAttribute("rpt");
	top.window.fieldCurrNode = node;
	//设置当前node
	if( node == null ) return;
	if( currNode != null ) {
		currNode.style.backgroundColor = "";
		currNode.style.color = labelColor;
	}
	node.style.backgroundColor = selectedBackColor;		
	node.style.color = selectedColor;
	currNode = node;
	var type1 = currNode.getAttribute("type");
	var roles = currNode.getAttribute("roles");
	var rpt = currNode.getAttribute("rpt");
	var form = currNode.getAttribute("form");
	var url2 = currNode.getAttribute("url");
	var jspName = "default";
	jspName = currNode.getAttribute("useJsp");
	//2020.8.28
	window.top.showRightSideMengban();
	var iframe = parent.document.getElementById("showProp");
	iframe.onload = function() {
 	   window.top.hideRightSideMengban();
	};   
	//var paramsJson = currNode.getAttribute("params");
	if( type1 == "1" ||  node.id == "id_0" || type1 == "6" ){
		var aggr = type1 == "6"?"yes":"no";
		if(rpt != null && rpt.length > 0){
			$.ajax({
				type:"post",
				url:appmap_js + "/reportCenterServlet?action=37&operatingDir="+encodeURIComponent(rpt)
							+"&rightType=0&isAggr="+aggr+"&useJsp="+jspName,//只需要名称，都使用center/reportJsp下面的页面文件
				data:{},
				success:function(strRet){
					if(strRet == "fail"){
						alert("缺少查看\'"+rpt+"\'的权限！");
					}else {
						eval(strRet);
					}
				}
			});
			return;
		}
	}
	if( type1 == "2" || node.id == "id_0" ){
		var url1 = currNode.getAttribute("url");
		if(url1 != null && url1.length > 0){
			if(url1.indexOf("http://") >= 0){
				parent.document.getElementById("showProp").src = currNode.getAttribute("url");
			}else if(url1.indexOf("/") == 0 || url1.indexOf("\\") == 0){
				parent.document.getElementById("showProp").src = appmap_js + currNode.getAttribute("url");
			}else{
				parent.document.getElementById("showProp").src = currNode.getAttribute("url");
			}
		}
	}
	if( type1 == "3" ){
		var detailQuerydqldb = currNode.getAttribute("dqldb");
		parent.document.getElementById("showProp").src = "../guide/jsp/detailQuery.jsp?"
			+ "dataSource=" + detailQuerydqldb
			+ "&dct=" + encodeURIComponent(currNode.getAttribute("dct"))
			+ "&vsb=" + encodeURIComponent(currNode.getAttribute("vsb"))
			+ "&qyx=" + encodeURIComponent(currNode.getAttribute("qyx"))
			+ "&fixedTable=" + encodeURIComponent(currNode.getAttribute("fixedtable"));
	}else if( type1 == "4"){
		var mainFrame = parent.document.getElementById("showProp");
		if(currNode.getAttribute("analyseType") == "ql"){
			mainFrame.src = "../guide/jsp/analyse.jsp?ql=" + encodeURIComponent(currNode.getAttribute("analyseSQL")) + "&dataSource=" + encodeURIComponent(currNode.getAttribute("analyseDB"));
		}else if(currNode.getAttribute("analyseType") == "dataFile"){
			var dataFile1 = currNode.getAttribute("anaFile");
			if(dataFile1.indexOf(".olap")>=0){
				mainFrame.src = "../guide/jsp/analyse.jsp?olap=" + encodeURIComponent(dataFile1);
			}else{
//				mainFrame.src = "../guide/jsp/analyse.jsp?dfxParams=" + encodeURIComponent("f="+dataFile1) 
//					+ "&dfxFile=" + encodeURIComponent("WEB-INF/files/dfx/official/readFile.dfx");
				mainFrame.src = "../guide/jsp/analyse.jsp?dataFile=" + encodeURIComponent(dataFile1);
			}
		}else if(currNode.getAttribute("analyseType") == "fixedTable"){
			mainFrame.src = "../guide/jsp/analyse.jsp?fixedTable=" + encodeURIComponent(currNode.getAttribute("analysetables"))
				+ "&dataSource=" + encodeURIComponent(currNode.getAttribute("anaDqldb"));
		}else if(currNode.getAttribute("analyseType") == "dfxScript"){
			var dfxScript = currNode.getAttribute("dfxScript");
			mainFrame.src = "../guide/jsp/analyse.jsp?dfxScript=" + encodeURIComponent(dfxScript)
				+ "&dfxParams=" + encodeURIComponent(currNode.getAttribute("dfxParams"));
		}else if(currNode.getAttribute("analyseType") == "dfxFile"){
			mainFrame.src = "../guide/jsp/analyse.jsp?dfxFile=" + encodeURIComponent(currNode.getAttribute("anaFile"))
				+ "&dfxParams=" + encodeURIComponent(currNode.getAttribute("dfxParams"));
		}else if(currNode.getAttribute("analyseType") == "inputFiles"){
			mainFrame.src = "../guide/jsp/analyse.jsp?"+currNode.getAttribute("analyseType")+"="+encodeURIComponent(currNode.getAttribute("anaFile"))+"&inputFileTableName="+encodeURIComponent(currNode.getAttribute("iftn"));
		}else{
			mainFrame.src = "../guide/jsp/analyse.jsp?"+currNode.getAttribute("analyseType")+"="+encodeURIComponent(currNode.getAttribute("anaFile"));
		}
	}else if( type1 == "5" ){
		$.ajax({
			type:"post",
			url:appmap_js + "/reportCenterServlet?action=37&operatingDir="+encodeURIComponent(rpt)+"&rightType=0"+"&isBusiInput=yes",
			data:{},
			success:function(strRet){
				if(strRet == "fail"){
					alert("缺少对业务填报\'"+rpt+"\'进行该操作的权限！");
				}else {
					eval(strRet);
			}
			}
		});
	}else if( type1 == "7" ){
		var cq_json = currNode.getAttribute("cq_json");
		var cq_dfx = currNode.getAttribute("cq_dfx");
		var cq_rpx = currNode.getAttribute("cq_rpx");
		var mainFrame = parent.document.getElementById("showProp");
		mainFrame.src = "./reportJsp/guideCommonQuery.jsp?cq_json=" + encodeURIComponent(cq_json)
			+ "&cq_dfx=" + encodeURIComponent(cq_dfx)+ "&cq_rpx=" + encodeURIComponent(cq_rpx);
	}
}