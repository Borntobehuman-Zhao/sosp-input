var dbdversion = "2.10";
var controlUtil = null;
var x=0;
var divTableControl = null;
var cleanMode = false;
var currDiv = null;
var currAreaJson = null;
//var divide = 10;
var minDivWidth = 50;
var countArea = 0;
var createRpxType = 1;
var selectLayoutsModel = 0;
var ua = navigator.userAgent.toLocaleLowerCase();
var editingReportName = false;
var domModified = false;
var gridsterLastRow = 1;
var diyR = 0;
var diyC = 0;
//var defaultDivWidth = 9;
//var defaultDivHeight = 150;
//var defaultLiHeight = 2;//'300px';
var defaultDivPos = 0;
var diyDivSize = false;
var setDivWidth = defaultDivWidth;
var setDivHeight = defaultDivHeight;
var setLiHeight = defaultLiHeight;
var setDivPos = defaultDivPos;
var isMobileView = false;
var colorPickersInitialized = false;
var rmbarHeight = 29;
var gridsterNotExsit = true;

$(function() {
	Array.prototype.deleteIndex = function(index){
		console.log("before delete arr has:"+this.length);
		var r = this.slice(0, index).concat(this.slice(parseInt(index, 10) + 1));
		console.log("after delete arr has:"+r.length);
		return r;
	};
	
	Array.prototype.insert = function(index,arr){
		if(index < 0 || index >= this.length) console.warn( "insert参数错误" );
		return this.slice(0, index).concat(arr).concat(this.slice(parseInt(index, 10)));
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
	
	Array.prototype.changeIndex = function(index, newvalue){
		this[index] = newvalue;
	};
	
	if (typeof Object.assign != 'function') {
		console.log("define Object.assign");
		  Object.assign = function(target) {
		    'use strict';
		    if (target == null) {
		      throw new TypeError('Cannot convert undefined or null to object');
		    }

		    target = Object(target);
		    for (var index = 1; index < arguments.length; index++) {
		      var source = arguments[index];
		      if (source != null) {
		        for (var key in source) {
		          if (Object.prototype.hasOwnProperty.call(source, key)) {
		            target[key] = source[key];
		          }
		        }
		      }
		    }
		    return target;
		  };
		}
	
  $('#sizeController').change(function() {
    diyDivSize = $(this).prop('checked');
    if(diyDivSize){
    	$('#sizeController_form_')[0].style.display = "";
  	  	parseInputWidth();
		parseInputHeight();
		parseInputPos();
    }else{
    	$('#sizeController_form_')[0].style.display = "none";
    	setDivWidth = defaultDivWidth;
    	setDivHeight = defaultDivHeight;
    	setDivPos = defaultDivPos;
    }
  });
  $('#setDivWidth').change(function() {
	  parseInputWidth();
	  
  });
  $('#setDivHeight').change(function() {
	  parseInputHeight();
  });
  $('#setDivPos').change(function() {
	  parseInputPos();
  });
});

function parseInputWidth(){
	var value1 = $('#setDivWidth').val();
	value1 = value1 == null ? defaultDivWidth : value1;
	value1 = isNaN( value1 ) ? defaultDivWidth : value1;
	value1 = value1 < 1 ? 1 : value1;
	value1 = value1 > 12 ? 12 : value1;
	setDivWidth = value1;
}

function parseInputHeight(){
	var value2 = $('#setDivHeight').val();
	value2 = value2 == null ? defaultDivHeight : value2;
	value2 = isNaN( value2 ) ? defaultDivHeight : value2;
	value2 = value2 < 30 ? 30 : value2;
	setDivHeight = value2+"px";
}

function parseInputPos(){
	var value3 = $('#setDivPos').val();
	value3 = value3 == null ? defaultDivPos : value3;
	value3 = isNaN( value3 ) ? defaultDivPos : value3;
	value3 = value3 < 1 ? 0 : value3;
	setDivPos = value3;
}

function dbdInit(layout){
	console.log(layout);
	controlUtil = initAreaControl();
	divTableControl = createDivTableControl(layout);
	//divTableControl.defaultLayout.tableLeft = "0px";
	//divTableControl.defaultLayout.tableTop = "0px";
	var model = false;
	//加载editors
	if(layout != null){
		paramFormLayout = layout.paramFormLayout == null ? {} : layout.paramFormLayout;
	}
	try{
		isMobileView = mobileView;
	}catch(e){}
	if(ua.indexOf('mobile') >= 0){
		isMobileView = true;
		minit();
	}
	initDivTable(layout, model);
	initEditors();
	easyuiapi.parser.parse($('form.editor_o'));
	//初始化ds选择器，随当前选中表变化而变化
	/*$('.layoutsImg').off();
	$('.layoutsImg').mouseover(function(e){$(e.target).css('filter','opacity(1.0)')})
	.mouseout(function(e){$(e.target).css('filter','opacity(0.5)');})
	.click(function(e){
		aly.cache.reports = [];
		selectLayoutsModel = e.target.id;
		var layoutm= layoutModels[selectLayoutsModel].layout;
		if(layoutm.areas.length < rqAnalyse.rpxs.length) {
			alert('新建布局格数小于当前报表数！');
			return;
		}
		var olapstr = olapObj.getConfStr(layoutm);
		guideConf.openDOlap = "new";
		divTableControl.divInfos.divs = [];
		aly.set(olapstr);
		cleanSideBoard();
	});*/
	//加载本文件样式
	try{
		//refreshReportStyleOptions();
		initStyle(layout.dbdStyles);
	}catch(e){console.warn(e);}
	if(!finalView && !previewDbd && !isMobileView) {
		createListImage(0);
		createListImage(1);
		createListImage(2);
	}
}


function initAreaControl(){
	return {
		setAreaByReportName: function(reportName,divid,id){
			for(var a = 0; a < this.areas.length; a++){
				if(this.areas[a].report && this.areas[a].report == reportName){
					this.areas[a].inDivCell = divid;
					break;
				}
			}
		}
		,checkGetAreaName: function(name, targetArr){
			for(var i = 0; i < targetArr.length; i++){
				if(targetArr[i].report == name){
					name += '_1';
					return this.checkGetAreaName(name,targetArr);
				}
			}
			return name;
		}
		,
		addTo: function(divCellId,identifyAreaId){
			var originIAId = identifyAreaId;
			if(identifyAreaId == null) identifyAreaId = countArea;
			var div = $("<div class='singleArea' count="+identifyAreaId+" id='singleArea"+identifyAreaId+"'></div>");
			var areaObj = {
				id:parseInt(identifyAreaId)
				,xy:{x:div.css("left"),y:div.css("top")}
				,hw:{h:div.css("height"),w:div.css("height")}
				,inDivCell:divCellId
			}
			//新版直接添加了虚拟的报表
			//var plusimg = $("<img src='../img/plus.png' class='plus'/>");
			//this.draggableFunc(div,'img div');
			//var delimg = $("<img src='../img/delete.png' class='del' onClick='controlUtil.removeArea($(this.parentElement))'/>")
//			div.append(plusimg);
//			div.append(delimg);
			$('#'+divCellId).append(div);
//			plusimg.css("width",plusimg.css("height"));
//			plusimg.css("height",plusimg.css("width"));
//			centerContent(div,plusimg);
			if(originIAId == null) {
				countAreaAddOne();
			}
			else {
				//countArea = Math.max(countArea,parseInt(identifyAreaId))+1;
				setCountArea(Math.max(countArea,parseInt(identifyAreaId)+1));
			}
			//执行一次即可？
			//divTableControl.droppableFunc($('.divCell').not('[row=0]').not('[col=0]'));
			return areaObj;
		},
		areas:[
//			"id":{
//				xy:[]
//				,hw:[]
//			}
		],
		changeInfo: function(oldRpxName, rpxName){
			for(var a = 0; a < this.areas.length; a++){
				if(this.areas[a].report == oldRpxName) {
					this.areas[a].report = rpxName;
					$('#'+this.areas[a].inDivCell).attr("confName", rpxName);
					var areaId = "singleArea"+this.areas[a].id;
					$('#'+areaId).attr("confName", rpxName);
					$('#'+areaId).find('iframe').attr("confName", rpxName);
					return areaId;
				}
			}
		},
		dashboardParse: function dashboardParse(area1){
			initDialogOver = false;
			$(area1).find('iframe').remove();//2020.1.8
			$(area1).append('<iframe name="'+$(area1).attr("confName")+'" confName="'+$(area1).attr("confName")+'" style="border:0;width:100%;height:100%;"></iframe>')
			initDialogOver = true;
			$('iframe[confName="'+$(area1).attr("confName")+'"]').attr('src',"./empty.jsp?fromDbd=true&guideDir="+guideConf.guideDir+"&confName="+encodeURIComponent($(area1).attr("confName")));
			//if(!previewDbd) 
			redefineFrameHeight($(area1).attr("confName"));
		}
		,removeArea:function(area,permission){
			removeReport($(area).find('iframe').attr('confname'),permission);
			controlUtil.areas = controlUtil.areas.deleteValue(this.getAreaByReport($(area).attr('confName')));
			$(area).remove();
		}
		,getAreaByReport:function(name, layoutAreas){
			if(!layoutAreas) layoutAreas = this.areas;
			for(var a = 0; a < layoutAreas.length; a++){
				if(layoutAreas[a].report == name) return layoutAreas[a];
			}
			return null;
		}
		,getAreaByInDivCell:function(inDivCellId, layoutAreas){
			if(!layoutAreas) layoutAreas = this.areas;
			for(var a = 0; a < layoutAreas.length; a++){
				if(layoutAreas[a].inDivCell == inDivCellId) return layoutAreas[a];
			}
			return null;
		}
		,getAreaCount:function(p){
			var count = null;
			if(typeof p == "string") count = $("#"+p).attr('count');
			else  count = $(p).attr('count');
			for(var a = 0; a < this.areas.length; a++){
				if(this.areas[a].id == count) return this.areas[a];
			}
			return null;
		}
		,getAreaFolded:function(name){
			var ar = this.getAreaByReport(name);
			if(ar == null) return 0;
			if(ar.folded == null) return 0;
			else return ar.folded;
		}
		,getCurrAreaJsonObj:function(){
			return this.getAreaCount(currArea);
		}
	};
}

function initDivTable(layout,model){
	//初始2*3
	if(!layout) return;
	//2.0这部分只用于移动端
	if(isMobileView){
		var containerWidth = $('.main').css('width');
		var containerHeight = $('.main').css('height');
		//行列数
		divTableControl.defaultLayout.lastRow = divTableControl.defaultLayout.lastRow ? divTableControl.defaultLayout.lastRow : 2;
		divTableControl.defaultLayout.lastCol = divTableControl.defaultLayout.lastCol ? divTableControl.defaultLayout.lastCol : 3;
		var row = 0;
		var col = 0;
		var top = 0;
		var left = 0;
		//预设和缩放行高列宽
		var height = divTableControl.defaultLayout.height ? divTableControl.defaultLayout.height : 
			(parseInt(containerHeight)-20)/divTableControl.defaultLayout.lastRow;
		var w1 = parseInt($('.dbd-center').css('width'));
		var minusGap = w1 - (divTableControl.defaultLayout.lastCol+1)*divide;
		var width =  minusGap / divTableControl.defaultLayout.lastCol;
		height += "px";
		width += "px";
		if(isMobileView) width = $('.main').css('width');
		var cw,rh;
		if(!model && layout && layout.divWHs){
			cw = layout.divWHs.cw;
			rh = layout.divWHs.rh;
			var w1 = parseInt($('.dbd-center').css('width'));
			var wminusGap = w1 - (divTableControl.defaultLayout.lastCol+1)*divide;
			var wratio = wminusGap/(parseInt(layout.mainWidth)-(divTableControl.defaultLayout.lastCol+1)*divide);
			var hratio = parseInt($('.dbd-center').css('height'))/parseInt(layout.mainHeight);
			for(var c = 0; c < cw.length; c++){
				cw[c] = (parseInt(cw[c])*wratio)+"px";
			}
			for(var r = 0; r < rh.length; r++){
				if(ua.indexOf('mobile') < 0){
					rh[r] = (parseInt(rh[r])*hratio)+"px";
				}
			}
		}
		//移动端视图重算列宽，一列显示
		if(isMobileView){
			var mobileWidth = parseInt($('.main').css('width'));
			divTableControl.defaultLayout.lastCol = 1;
			divTableControl.defaultLayout.lastRow = rqAnalyse.rpxs.length;
			if(layout && layout.divWHs){
				for(var c = 0; c < layout.divWHs.cw.length; c++){
					layout.divWHs.cw[c] = mobileWidth;
				}
				var rh2 = [];
				rh2[rh2.length] = layout.divWHs.rh[0];
				for(var r = 1; r <= divTableControl.defaultLayout.lastRow; r++){
					//r当前报表行号
					var rname = rqAnalyse.rpxs[r-1].name;
					var layoutRow = controlUtil.getAreaByReport(rname, layout.areas).inDivCell.split('_')[1];
					rh2[rh2.length] = layout.divWHs.rh[layoutRow];
				}
				rh = rh2;
				layout.mergeCellIds = [];
			}
		}else if(!layout){
			//非移动端如果没有记录layout则重算需要的行数
			var diff = rqAnalyse.rpxs.length - divTableControl.defaultLayout.lastRow * divTableControl.defaultLayout.lastCol;
			divTableControl.defaultLayout.lastRow = diff > 0
				? (rqAnalyse.rpxs.length + divTableControl.defaultLayout.lastCol) / divTableControl.defaultLayout.lastCol - 1 : divTableControl.defaultLayout.lastRow;
		}
		//按行按列生成div表格
		var startpos = -1;//是否生成行号列号 -1时生成，目前是必要的，拖拽合并格对此有依赖
		for(var x = startpos; x < divTableControl.defaultLayout.lastRow; x++){
			row = x+1;
			left = 0+divide;
			var h = (x == -1 ? '20px':height);
			if( layout && !model && guideConf.openDOlap != "new" && rh) {
				h = rh[row];
			}
			for(var y = startpos; y < divTableControl.defaultLayout.lastCol; y++){
				col = y+1;
				var id = "d"+"_"+row+"_"+col;
				var w = (y == -1 ? '20px':width);
				if( layout && !model && guideConf.openDOlap != "new" && cw) {
					w = cw[col];
				}
				var currentDiv = $("<div row='"+row+"' col='"+col+"' id='"+id+"' class='divCell'"+onclick+"></div>");
				currentDiv.css("top",top+"px").css("left",left+"px")
					.css("height", h).css("width",w)
					.css("background-color","white");
					//.css("position","absolute");
				
				if(x == -1 || y == -1) currentDiv.css('display','none');
				if( x == -1 ) {
					currentDiv.css('text-align','center');
				}
				if( y == -1 ) {
					currentDiv.css('line-height','200px');
				}
				$('#contents').append(currentDiv);
				if(y == -1 || x == -1) {
					currentDiv.css('background-color','rgb(210, 210, 210)');
				}else{
					currentDiv.addClass('resiz');
				}
				if(y == -1 && x != -1){
					currentDiv.html(row);
				}
				if(y != -1 && x == -1){
					currentDiv.html(col);
				}
				if(y != -1) left += parseInt(w)+divide;
			}
			if(x != -1) {
				top += parseInt(h)+divide+3;
			}
		}
		//2.0版本不用拉伸
		//if(!finalView) resizableNormalCell();
		//初始化合并格和报表参数
		if(layout) {
			divTableControl.mergeCellIds = layout.mergeCellIds;
			aly.sysparams = layout.sysparams;
		}
		//生成合并格
		for(var i = 0; i < divTableControl.mergeCellIds.length; i++){
			var s = divTableControl.mergeCellIds[i].split('_');
			var r1 = s[1];
			var c1 = s[2];
			var r2 = s[3];
			var c2 = s[4];
			divTableControl.mergeDiv(r1,c1,r2,c2);
		}
		var divCells = $('.divCell').not('[row=0]').not('[col=0]');
		//移动端使用时，按调整过移动端的展现顺序放置报表
		try{
			if(mobileFinal && layout.mobileRpxOrder && layout.mobileRpxOrder.length > 0) {
				var rpxs = rqAnalyse.rpxs;
				rqAnalyse.rpxs = [];
				for(var o = 0; o < layout.mobileRpxOrder.length; o++){
					var orderedReportName = layout.mobileRpxOrder[o];
					var fr = findReportInArray(rpxs,orderedReportName);
					rqAnalyse.rpxs.push(fr);
				}
			}
		}catch(e){}
		//移动端重设areas
		if(isMobileView) {
			layout = {};
			layout.params = [];
			layout.paramNames = [];
			layout.mergeCellIds = [];
			layout.areas = new Array();
	//		var divCells = $('.divCell').not("[row=0]").not("[col=0]");
	//		while(divCells.length < rqAnalyse.rpxs.length){
	//			divTableControl.createRow();
	//			divCells = $('.divCell').not("[row=0]").not("[col=0]");
	//		}
			for(var x = 0; x < rqAnalyse.rpxs.length; x++){
				var rpxName = rqAnalyse.rpxs[x].name;
				var divCell = divCells[x];
				layout.areas[x] = {
					hw:{h:"0px",w:"0px"},
					id:x,
					inDivCell: divCell.id,
					report:rpxName,
					xy:{x:"",y:""}
				}
			}
		}
		//生成areas
		for(var x = 0; x < divCells.length; x++){
			var sArea = $(divCells[x]).find('.singleArea');
			if(sArea == null || sArea.length == 0){
				var identifyAreaId = controlUtil.getAreaByInDivCell(divCells[x].id,layout?layout.areas:null);
				identifyAreaId = identifyAreaId?identifyAreaId.id:null;
				var areaid = addAreaIntoDivCell($(divCells[x]).attr('id'),identifyAreaId);
				var areaDom = $('#'+areaid);
				var addedReportName = "图表名称"+x;
				if(layout && (guideConf.openDOlap == 'true' || guideConf.openDOlap == true || guideConf.openDOlap == 'new' || guideConf.openDOlap == "dataFile")){
					addedReportName = controlUtil.getAreaByInDivCell(divCells[x].id,layout.areas).report;
				}
				addReportToArea(addedReportName, areaDom);
			}
		}
		//点击按钮生效
		if(!finalView && !previewDbd ) refreshItemsReportWhereBuf();
		//结构加载完，若传入的layout有paramEditor，复用他的areas来做接下来的处理（controlUtil里面的areas可能已经引移动端初始化改变了）
		if(layout){
			for(var i = 0 ; i < layout.areas.length; i++){
				var areaE = layout.areas[i];
				if(areaE.type == "1"){
					controlUtil.areas = layout.areas;
					break;
				}
			}
		}
		if(rqAnalyse == null || rqAnalyse.rpxs == null || rqAnalyse.rpxs.length == 0){
			return;
		}
		//若有报表存在，初始化报表
		if(layout) {
			controlUtil.areas = layout.areas;
		}
		if(!layout){
			//打开的olap中没有layout的时候自动增加一个areas按顺序排布报表
			layout = {};
			layout.params = [];
			layout.paramNames = [];
			layout.mergeCellIds = [];
			layout.areas = new Array();
			var divCells = $('.divCell').not("[row=0]").not("[col=0]");
			//新增空间
	//		while(divCells.length < rqAnalyse.rpxs.length){
	//			divTableControl.createRow(layout);
	//			divCells = $('.divCell').not("[row=0]").not("[col=0]");
	//		}
			for(var x = 0; x < rqAnalyse.rpxs.length; x++){
				var rpxName = rqAnalyse.rpxs[x].name;
				var divCell = divCells[x];
				layout.areas[x] = {
					hw:{h:"0px",w:"0px"},
					id:x,
					inDivCell: divCell.id,
					report:rpxName,
					xy:{x:"",y:""}
				}
			}
		}
		controlUtil.areas = layout.areas;
		for(var r = 0; r < rqAnalyse.rpxs.length; r++){
			var area = controlUtil.getAreaByReport(rqAnalyse.rpxs[r].name);
			if(area == null) continue;
			var inDivCell = $('#'+area.inDivCell);
			var oldName = inDivCell.find('.barReportName').html();
			inDivCell.find('.barReportName').html(rqAnalyse.rpxs[r].name).attr('value',rqAnalyse.rpxs[r].name);
			inDivCell.find('a.reportRemove').attr('href',"javascript:removeReport('"+rqAnalyse.rpxs[r].name+"')");
			//var rmbar = inDivCell.find('.rmbar').attr('id','rmbar_'+rqAnalyse.rpxs[r].name)
		}
		
		initReport(layout);
		if(!finalView && !previewDbd ) refreshItemsReportWhereBuf();
		if(isMobileView) $('.singleArea').find('iframe').css('width','auto');
	}else if(dbdversion < 2.10){
		//2.0
		aly.sysparams = layout.sysparams;
		var areas = layout.areas;
		for(var x = 0; x < areas.length; x++){
			var area = areas[x];
			var labelName = area.report;
			var type = "blank";
			if(area.type == null || area.type == 0 ){
				type = "define";
			}else if(area.type == 1) {
				type = "editor";
			}else if(area.type == 2){
				type = "choose";
			}else if(area.type == 3){
				type = "paramFormTop";
			}
			if(area.type == 3 && (previewDbd || finalView) && !paramFormLayout.useParamForm) continue;
			createTypedDiv(area.span,area.height,type,labelName,area.id, area.inDivCell);
		}
		controlUtil.areas = layout.areas;
		initReport(layout);
		if(!finalView && !previewDbd ) refreshItemsReportWhereBuf();
		divTableControl.changeChoosedDiv(currDiv);
	}else{
		//2.10
		if(layout.gridsterOptions.divide != null) divide=layout.gridsterOptions.divide;
		if(layout.gridsterOptions.defaultDivWidth != null) defaultDivWidth=layout.gridsterOptions.defaultDivWidth;
		if(layout.gridsterOptions.defaultDivHeight != null) defaultDivHeight=layout.gridsterOptions.defaultDivHeight;
		if(layout.gridsterOptions.defaultLiHeight != null) defaultLiHeight=layout.gridsterOptions.defaultLiHeight;
		refreshGS();
		
		if(finalView || previewDbd ) gridster.disable();
		aly.sysparams = layout.sysparams;
		var areas = layout.areas;
		
		var orderedGridAreas = layout.gridsterWidgetRowColArray;
		
		for(var y = 1; y < orderedGridAreas.length; y++){
			for(var x = 1; x < orderedGridAreas[y].length; x++){
				var area = orderedGridAreas[y][x];
				if(area == null) continue;
				var labelName = area.report;
				var type = "blank";
				if(area.type == null || area.type == 0 ){
					type = "define";
				}else if(area.type == 1) {
					type = "editor";
				}else if(area.type == 2){
					type = "choose";
				}else if(area.type == 3){
					type = "paramFormTop";
				}
				if(area.type == 3 && (previewDbd || finalView) && !paramFormLayout.useParamForm) continue;
				createTypedDivNoChangeChoosedDiv(area.span,area.height,type,labelName,area.id, area.inDivCell
					,area.widgetHeight,area.widgetWidth,area.widgetRow,area.widgetCol);
			}
		}
		gridster.last_rows = layout.gridsterOptions.last_rows;
		/*for(var x = 0; x < areas.length; x++){
			var area = areas[x];
			var labelName = area.report;
			var type = "blank";
			if(area.type == null || area.type == 0 ){
				type = "define";
			}else if(area.type == 1) {
				type = "editor";
			}else if(area.type == 2){
				type = "choose";
			}else if(area.type == 3){
				type = "paramFormTop";
			}
			if(area.type == 3 && (previewDbd || finalView) && !paramFormLayout.useParamForm) continue;
			console.log(area);
			createTypedDiv(area.span,area.height,type,labelName,area.id, area.inDivCell
				,area.widgetHeight,area.widgetWidth,area.widgetRow,area.widgetCol);
		}*/
		controlUtil.areas = layout.areas;
		initReport(layout);
		if(!finalView && !previewDbd ) {
			refreshItemsReportWhereBuf();
		}
		divTableControl.changeChoosedDiv(currDiv);
	}
}
var lockGoUp = true;
var lockGoLeft = true;

function initReport(layout,ds){
	aly.params = layout.params;
	aly.paramNames = layout.paramNames;
	aly.dsWhereParams = layout.dsWhere;
	aly.dsWhereParams = layout.dsWhere;
	for(var j = 0; j < controlUtil.areas.length; j++ ){
		//reAddAreaIntoDivCell(controlUtil.areas[j].inDivCell,controlUtil.areas[j].id);
		nonedlg_ok_refreshReport($('#singleArea'+controlUtil.areas[j].id),controlUtil.areas[j].report);
	}
	if(guideConf.openDOlap == "new") {
		aly.refreshAll();
	}
	setTimeout(function(){
		//aly.refreshAll();
		cleanSideBoard();
	},100);
}

function nonedlg_ok_refreshReport(currArea,rname) {
	var n = rname;
	if (aly.getRpx(n)) {
		//console.log( '识别了报表' + n);
	}else{
		return;
	}
	$(currArea).attr("confName",n);
	controlUtil.dashboardParse(currArea);
}

function addAreaIntoDivCell(id,identifyAreaId,pos){
	var areaObj = controlUtil.addTo(id,identifyAreaId);
	if(pos > 0) {//pos从1开始
		if($('.divbox').length < pos){
			controlUtil.areas.push(areaObj);
		}
		else controlUtil.areas = controlUtil.areas.insert((pos-1),[areaObj]);
	}
	else controlUtil.areas.push(areaObj);
	return "singleArea"+areaObj.id;
}
function reAddAreaIntoDivCell(id,identifyAreaId){
	var areaObj = controlUtil.addTo(id,identifyAreaId);
	return "singleArea"+areaObj.id;
}

function createRandomColor(){
	var arr = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'];
	var j = 0;
	var color = "#";
	while(j < 6){
		var i = random16();
		color += arr[i];
		j++;
	}
	return color;
}

function random16(){
	var a = Math.floor(Math.random()*10);
	var b = Math.floor(Math.random()*10);
	var i = 0;
	if(a<5){
		a = 0;
	}else{
		a = 1;
	}
	if(a == 0){
		i = b;
	}else{
		if(b>5) b = 5;
		i = ""+a+b;
		i = parseInt(i);
	}
	return i;
}

function centerContent(div,content){
//	var dh = $(div).css("height");
//	var dw = $(div).css("width");
//	dh = parseInt(dh.split("px")[0]);
//	dw = parseInt(dw.split("px")[0]);
//	$(content).css("top",dh/2+"px").css("left",dw/2+"px").css("transform","translate(-50%,-50%)");
	
}

var createDivTableControl = function(layout){
	var divInfos = null;
	var lastRow = null;
	var lastCol = null;
	if(layout){
		divInfos = layout.divInfos;
		
		lastCol = divInfos.cols;
		lastRow = divInfos.rows;
	}
	if(diyC != 0) lastCol = diyC; 
	if(diyR != 0) lastRow = diyR; 
	return {
	getInnerReport:function(div){
		if(div == null) return null;
		var area = $(div).find('.singleArea');
		if(area) return area.attr('confName');
	},
	currentDiv:{row:1,col:1,range:null},
	defaultLayout:{lastRow:lastRow,lastCol:lastCol,tableTop:$('#contents').css('top'),tableLeft:$('#contents').css('left')},
	//divIds:new Array(),//d_1_2[_1]第一行第二列[拆分第几个]，初始给5*5，d_1_1~d_5_5
	divInfos:(divInfos ? divInfos : {
		rows:2,
		cols:3,
		divContents:[]
	}),//rows:4,cols:4,divContents:{"d_1_2":{height:,width:,top:,left:,info:{reportName:}}}
	moveReport:function(event,ui,areaDivId,toDivRow,toDivCol) {
    	var divCellId = event == null ? "" : event.target.id;
    	var divCell = null;
    	if(divCellId == ""){
    		divCell = $('.divCell[row='+toDivRow+'][col='+toDivCol+']');
    	}else{
    		divCell = $("#"+divCellId);
    	}
    	var area = event == null ? $("#"+areaDivId) : ui.draggable;
    	var exchange = false;
    	divCell.css("background-color","white");
    	if(divCell.find('.singleArea').length != 0){
    		area.css("top","0px").css("left","0px");
    		exchange = true;
    	}
//    	if(ui != null && ui.draggable[0].className.indexOf('select_li')>=0) {
//    		if(exchange) {
//    			alert("目标中已有报表块");
//    			return;
//    		}
//			addModelReport(ui.draggable[0],divCellId);
//			return;
//		}
    	if(exchange) {
    		divTableControl.exchange(area,divCell);
    		return;
    	}
    	var areasInfos = controlUtil.areas;
    	for(var i = 0; i < areasInfos.length; i++){
    		var areaInfo = areasInfos[i];
    		if(areaInfo.id == area.attr('count')){
    			//拖拽前的div index
    			var divIndex = getIndexOfDivById(areaInfo.inDivCell);
    			areaInfo.inDivCell = divCell.attr('id');
    			//拖拽后删除原来位置的divInfos.divs
//    			if(divIndex >= 0) divTableControl.divInfos.divs = divTableControl.divInfos.divs.deleteIndex(divIndex);
//				divTableControl.divInfos.divs.push({id:areaInfo.inDivCell,area:areaInfo});
    		}
    	}
    	area.css("top","0px").css("left","0px");
    	divCell.append(area);
    	var rpxFrame = $(area).find('iframe')[0];
    	//setTimeout(function(){
    		//$(rpxFrame.contentWindow.document).find('body').find('#mainDiv').css('display','none');
        	//$(rpxFrame.contentWindow.document).find('body').find('#move').css("background","url(../img/dl/ViewReport-ICO.gif) -502px -84px no-repeat ")
    	//},500);
    	//var rowNum = $(divCell).attr("row");
		//var colNum = $(divCell).attr("col");
		//$('div[confName='+$(area).attr('confname')+']').attr("title",rowNum+"_"+colNum);
	},
	exchange:function(fromArea,toDiv){
		var theOtherArea = toDiv.find('.singleArea');
		var theOtherDiv = fromArea.parent();
		var areasInfos = controlUtil.areas;
		toDiv.append(fromArea);
		theOtherDiv.append(theOtherArea);
		//dom实体调换过了
    	for(var i = 0; i < areasInfos.length; i++){
    		var areaInfo = areasInfos[i];
    		if(areaInfo.id == fromArea.attr('count')){
    			areaInfo.inDivCell = toDiv.attr('id');
    			//拖拽后的div index
    			var divIndex = getIndexOfDivById(areaInfo.inDivCell);
    			//divIndex是之前的inDivCell
    			if(divIndex >= 0) {
    				divTableControl.divInfos.divs[divIndex].area = controlUtil.getAreaByReport($(fromArea).attr('confname'));
    			}
    		}
    	}
    	for(var j = 0; j < areasInfos.length; j++){
    		var areaInfoj = areasInfos[j];
    		if(areaInfoj.id == theOtherArea.attr('count')){
    			areaInfoj.inDivCell = theOtherDiv.attr('id');
    			//拖拽后的div index
    			var divIndex = getIndexOfDivById(areaInfoj.inDivCell);
    			//拖拽后删除原来位置的divInfos.divs
    			if(divIndex >= 0) {
    				divTableControl.divInfos.divs[divIndex].area = controlUtil.getAreaByReport($(theOtherArea).attr('confname'));
    			}
    			
    		}
    	}
    	
	},
	droppableFunc:function(div){
		div.droppable({
			accept:'.singleArea,.select_li',
	        drop: divTableControl.moveReport
	    	,over: function(event, ui) {
	    		$( this ).css("background-color","#FFFF88");
	    	}	
	    	,out: function(event, ui) {
	    		$( this ).css("background-color","white");
	        }
	    });
	},
	divCellAddReport:function(div){
		if(div == null) return;
		addAreaIntoDivCell(div)
	},
	changeRelMergeCell:function(rev,attr,value,currId){
		rev = parseInt(rev);
		var x = attr == 'height'? 'row2' : 'col2';
		var y = attr == 'height'? 'row' : 'col';
		var currDivAttrVal;
		if(currId){
			currDivAttrVal = $('#'+currId).css(attr);
		}
		//调整本列或本行合并格宽高
		var relaMergeCells = $('.mergeCell['+x+'='+rev+']');
		for(var rmc = 0; rmc < relaMergeCells.length; rmc++){
			if($(relaMergeCells[rmc]).attr(x) != rev) continue
			var rmch = parseFloat($(relaMergeCells[rmc]).css(attr));
			$(relaMergeCells[rmc]).css(attr, (rmch + value) + 'px');
		}
		//下一行或一列
		relaMergeCells = $('.mergeCell['+y+'='+(rev+1)+']');
		for(var rmc = 0; rmc < relaMergeCells.length; rmc++){
			if($(relaMergeCells[rmc]).attr(y) != (rev+1)) continue
			var rmch = parseFloat($(relaMergeCells[rmc]).css(attr));
			$(relaMergeCells[rmc]).css(attr, (rmch - value) + 'px');
		}
		
		
		if(currId){
			$('#'+currId).css(attr,currDivAttrVal);
		}
		//调整下一列或下一行合并格宽高
	}
	,
	removeRow:function(id){
		if(!id){
			id = divTableControl.defaultLayout.lastRow; 
		}
		if(id <= 1) {
			return;
		}
		var divs = $('.divCell[row='+id+']');
		//检查列序号是否连续，不连续就有合并格
		var idArray = [];
		for(var c = 0 ; c < divs.length; c++){
			var colid = $(divs[c]).attr("col");
			idArray.push(parseInt(colid));
		}
		idArray.sort(function(a,b){
		    return a-b;
		})
		for(var i = 0 ; i < idArray.length; i++){
			if(idArray[i] != i){
				alert("行中有合并格不能删除");
				return;
			}
		}
		var decreaseHeight = parseFloat($('#d_'+id+'_0').css('height'));
		for(var d = 0; d < divs.length; d++){
			if(divs[d].className.indexOf('mergeCell') > 0){
				alert("行中有合并格不能删除");
				return;
			}else{
				var innerArea = $(divs[d]).find('.singleArea');
				if(innerArea.length > 0) controlUtil.removeArea(innerArea);
//				var mcs = $('.mergeCell');
//				for(var m = 0; m < mcs.length; m++){
//					var c = mcs[m];
//					var row1 = $(c).attr('row');
//					var row2 = $(c).attr('row2');
//					if(row<id<=row2){
//						//缩小合并格
//						var height = parseFloat($(c).css('height')) - decreaseHeight;
//						$(c).css('height',height);
//					}
//				}
			}
		}
		divs.remove();
		divTableControl.defaultLayout.lastRow--;
		divTableControl.divInfos.rows--;
		//moveUpNextRow(startRow,height);
	},
	removeCol:function(id){
		if(!id){
			id = divTableControl.defaultLayout.lastCol; 
		}
		if(id <= 1) {
			return;
		}
		var divs = $('.divCell[col='+id+']');
		//检查列序号是否连续，不连续就有合并格
		var idArray = [];
		for(var c = 0 ; c < divs.length; c++){
			var rowid = $(divs[c]).attr("row");
			idArray.push(parseInt(rowid));
		}
		idArray.sort(function(a,b){
		    return a-b;
		})
		for(var i = 0 ; i < idArray.length; i++){
			if(idArray[i] != i){
				alert("行中有合并格不能删除");
				return;
			}
		}
		var decreaseWidth = parseFloat($('#d_0_'+id).css('width'));
		for(var d = 0; d < divs.length; d++){
			if(divs[d].className.indexOf('mergeCell') > 0){
				alert("列中有合并格不能删除");
				return;
			}else{
				var innerArea = $(divs[d]).find('.singleArea');
				if(innerArea.length > 0) controlUtil.removeArea(innerArea);
			}
		}
		divs.remove();
		divTableControl.defaultLayout.lastCol--;
		divTableControl.divInfos.cols--;
		//moveUpNextCol(startCol,height);
	}
	,changeChoosedDiv: function(div){
		//if(editingReportName) return;//正在编辑时不能切换div;新版自动提交
		//$("#selectDs").attr('disabled',true);
		$("#selectDs").unbind('change');
		cleanSideBoard();
		$("#selectDs").val(null);
		if(div == null) {
			return;
		}
		if(div.className.indexOf('divCell') < 0){
			currArea = null;
			return;
		}
		if(div.className.indexOf('choosedDiv') >= 0){
			$(currDiv).removeClass('choosedDiv');
			currArea = null;
			//go('top');
			propertiesOps.pend('top');
			//style_eee 灰显选项
			//refreshReportStyleOptions();
			return;
		}
		//切换编辑块
		var rn = $(div).find(".singleArea").attr('confName');
		var rpx = aly.getRpx(rn);
		
		var dataSet = "";
		if(rpx != null) {
			dataSet = aly.getRpx(rn).dataSet;
			var ds = aly.getDataSet(dataSet);
			enableAcfBut();
		}else{
			disableAcfBut();
		}
		if(dataSet == null) dataSet = ""; 
		if(currDiv != null) {
			$(currDiv).removeClass('choosedDiv');
		}
		currDiv = div;
		currArea = $(currDiv).find('.singleArea');
		if($(currDiv).attr('row') == "0" || $(currDiv).attr('col') == "0") {
			currDiv = null;
		}else $(currDiv).addClass('choosedDiv');
		$("#selectDs").val(dataSet);
		$("#selectDs").change(function(){
			changeCurrRpxDs($("#selectDs").val());
		});
		changeCurrRpxDs(dataSet);
		//aly.refresh(false,true);
		if(isEditor(div)){
			propertiesOps.pend('editor',null);
			//go('editor',null,false);
		}else if(isParamFormTop(div)) {
			propertiesOps.pend('paramFormTop',null);
			//go('editor',null,false);
		}else if(isBlank(div)) {
			propertiesOps.pend('top');
			//go('top');
		}
		else{
			$("#selectDs").attr('disabled',false).val(dataSet);
			//if(dataSet == null || dataSet.length == 0) return;
			if(!rpx) {
				//go('report',$(div).attr('rt') == "2" ? "choose":"define",false);
				propertiesOps.pend('report',$(div).attr('rt') == "2" ? "choose":"define");
			}
			else {
			//go('report',rpx.type == 2 ? "choose":"define",false);
			propertiesOps.pend('report',rpx.type == 2 ? "choose":"define");
			}
			//delayWestEvent();
		}
		//
		var area = controlUtil.getAreaByInDivCell($(div).attr('id'));
		refreshReportStyleOptions(area);
		/*$('#border_bg').off();
		$('#area_bg').off();*/
		var colorpickers = [
			$('#border_bg'),
			$('#area_bg'),
			$('#border_bg2'),
			$('#area_bg2')
		];
		try{
			var bbg = area.dbdStyle.reportDivBorderColor == null ? 
				defaultColorB : area.dbdStyle.reportDivBorderColor;
			$('#border_bg').css('background-color', bbg).val(bbg);
			$('#border_bg2').css('background-color', bbg).val(bbg);
			var abg = area.dbdStyle.reportDivColor == null ? 
				defaultColorR : area.dbdStyle.reportDivColor;
			$('#area_bg').css('background-color', abg).val(abg);
			$('#area_bg2').css('background-color', abg).val(abg);
		}catch(e){
			console.warn(e);
			$('#border_bg').css('background-color', defaultColorB).val(defaultColorB);
			$('#area_bg').css('background-color', defaultColorR).val(defaultColorR);
			$('#border_bg2').css('background-color', defaultColorB).val(defaultColorB);
			$('#area_bg2').css('background-color', defaultColorR).val(defaultColorR);
		}
		
		$(colorpickers).each(function(){
			try{
				var picker = $(this).data('colorpicker');
				picker.hide();
				$(this).removeClass("colorpicker-element").off();
				$(this).data('colorpicker',null);
			}catch(e){
			}
		});
		
		/*$('#border_bg').removeClass("colorpicker-element").off();
		$('#border_bg').data('colorpicker',null);
		$('#border_bg2').removeClass("colorpicker-element").off();
		$('#border_bg2').data('colorpicker',null);
		$('#area_bg').removeClass("colorpicker-element").off();
		$('#area_bg').data('colorpicker',null);
		$('#area_bg2').removeClass("colorpicker-element").off();
		$('#area_bg2').data('colorpicker',null);*/
		//if(!colorPickersInitialized){
		showColorBoard(2, $('#border_bg'));
		showBorderBoard($('#setBorderWidth'));
		showColorBoard(1, $('#area_bg'));
		
		showColorBoard(2, $('#border_bg2'));
		showBorderBoard($('#setBorderWidth2'));
		showColorBoard(1, $('#area_bg2'));
		//}
		$('.resetHeight').val('');
		
		colorPickersInitialized = true;
		var type_i = null;
		
		if(isEditor(div)) {
			type_i = 2;
		}else{
			type_i = 1;
		}
		var v = getAreaDbdStyle(controlUtil.getCurrAreaJsonObj()).reportDivImage;
		if(v == null) {
			initListImage(type_i,"");
		}else{
			var tempv = v.split('/');
			v = tempv[tempv.length - 1];
			initListImage(type_i,v);
		}
		//if(!rpx) return;
	}
};
}

function openMergeDialog(){
	if(!confirm('合并单元格只能保留第一个报表')){
		return;
	}
//	,lock : true
//    ,duration : 0
//    ,width : '500px'
//	,height : '130px'
//	,opacity : 0.1
//	,padding : '2px 2px'
//	,zIndex : 41000
	var dialog = art.dialog({
        title:"合并单元格",
        fixed:true,
        max: false,
        min: false,
        lock: true,
        resize:false,
        cache:false,
        esc:true,
		content:'<form name="mergeForm">'
			+'<table>'
			+'<tr><td>'
			+'起始行<input name="m_row1" type=text value=1 /></br>'
			+'起始列<input name="m_col1" type=text value=1 />'
			+'</td><td>'
			+'结束行<input name="m_row2" type=text value=1 /></br>'
			+'结束列<input name="m_col2" type=text value=2 />'
			+'</td>'
			+'</tr>'
			+'</table>'
			+'</form>',
        ok:function(){
			var mf = $('form[name=mergeForm]')[0];
			var r1 = mf.m_row1.value;
			var c1 = mf.m_col1.value;
			var r2 = mf.m_row2.value;
			var c2 = mf.m_col2.value;
			
			divTableControl.mergeDiv(r1,c1,r2,c2);
	    },
        dblclick:false, //双击不关闭对话框
        okVal : resources.guide.js20
		,zIndex : 41000
    });
   
   // var options = $.extend(defaults, options);

	//var dialog = art.dialog(options);
	return;
}

function removeContent(reportName,permission,type,deleteArea){
	if(!permission){
		if(!confirm('清空内容：'+reportName)){
			return;
		}
	}
	if(type == "paramFormTop"){
		var areas = controlUtil.areas;
		for(var a = 0; a < areas.length; a++){
			if(areas[a].report && areas[a].report == reportName){
				var count = areas[a].id;
				removeEditorDom('singleArea'+count);
				$('#singleArea'+count).find('iframe').remove();
				if(deleteArea) controlUtil.areas = controlUtil.areas.deleteIndex(a);
				break;
			}
		}
		disableAcfBut();
		//refreshItemsReportWhereBuf();
		$('.pfrow').remove();
		initParamFormCells();
		paramFormLayout.currLayout = [];
		controlUtil.getAreaByInDivCell('o_pf').paramForm = [];
	}
	else if(type != "editor"){
		rqAnalyse.rpxs.remove(aly.getRpx(reportName));
		if (rqAnalyse.currRpx == reportName) {
			rqAnalyse.currRpx = '';
		}		
		var reports = aly.cache.reports;
		var hasAndDelete = false;
		for (var i=0; i<reports.length; i++) {
			if (reports[i].name == reportName) {
				reports[i].dlg.close();
				reports[i].dlg.DOM.wrap.remove();
				reports.remove(reports[i]);
				hasAndDelete = true;
				break;
			}
		}
		var areas = controlUtil.areas;
		for(var a = 0; a < areas.length; a++){
			if(areas[a].report && areas[a].report == reportName){
				var count = areas[a].id;
				$('#singleArea'+count).find('iframe').remove();
				if(isChoosed($('#singleArea'+count).parent()[0])) {
					if(hasAndDelete) {
						cleanSideBoard();
						$('#selectDs').val('');
					}
				}
				if(deleteArea) controlUtil.areas = controlUtil.areas.deleteIndex(a);
				break;
			}
		}
		disableAcfBut();
		refreshItemsReportWhereBuf();
	} else{
		var areas = controlUtil.areas;
		for(var a = 0; a < areas.length; a++){
			if(areas[a].report && areas[a].report == reportName){
				var count = areas[a].id;
				removeEditorDom('singleArea'+count);
				$('#singleArea'+count).find('iframe').remove();
				if(deleteArea) controlUtil.areas = controlUtil.areas.deleteIndex(a);
				break;
			}
		}
		disableAcfBut();
		refreshItemsReportWhereBuf();
	}
	go('top');
}

function removeReport(reportName,permission){
	if(!permission){
		if(!confirm('删除组件：'+reportName)){
			return;
		}
	}
	removeContent(reportName,true,null,true);
	var div = $('.singleArea[confname='+reportName+']').parent().parent();
	div.addClass('animated fadeOutRight');
	setTimeout(function(){
		//div.remove();
		gridster.remove_widget(div.parent()[0],function(){
			console.log(gridster);
		});
	},500);
}

function removeEditor(reportName,permission){
	if(!permission){
		if(!confirm('删除组件：'+reportName)){
			return;
		}
	}
	removeContent(reportName,true,"editor",true);
	var div = $('.singleArea[confname='+reportName+']').parent().parent();
	div.addClass('animated fadeOutRight');
	setTimeout(function(){
		div.remove();
	},1000);
}

function createRow(){
	divTableControl.createRow();
}

function createCol(){
	divTableControl.createCol();
}

function removeRow(){
	divTableControl.removeRow();
}

function removeCol(){
	divTableControl.removeCol();
}

function showRowMenu(e){
	showMenu(0,$(e).attr('row'));
}

function showColMenu(e){
	showMenu(1,$(e).attr('col'));
}

function showMenu(type,id){
	var flag = type == 0 ? 'row':'col';
	var flag2 = type == 0 ? '行':'列';
	var ti = '删除'+flag2;
	var defaults = {
        title:ti,
        fixed:true,
        max: false,
        min: false,
        lock: true,
        resize:false,
        cache:false,
        esc:true,
		content:'<span>确认删除'+flag2+id+'</span>',
        ok:function(){
			var ff = $('form[name='+flag+'Form]')[0];
			var id = ff.id_.value;
			if(type == 0) divTableControl.removeRow(id);
			if(type == 1) divTableControl.removeCol(id);
	    },
        dblclick:false, //双击不关闭对话框
        okVal : resources.guide.js20
    };
   
    var options = $.extend(defaults, options);

	var dialog = art.dialog(options);
	return dialog;
}

function util_removeElmFromArray(arr, index, value){
	var findByValue = false;
	if( arr && arr.length > 0 ){
		if(!index || index < 0){
			findByValue = true;
		}
		
		if(findByValue && value){
			if(! (value in arr)) index = -1;
			else index = arr.indexOf(value);
		}
		
		if(index >= 0){
			return arr.deleteIndex(index);
		}
	}else{
		return;
	}
	
}

function getWidths(){
	var ws = new Array();
	for(var w = 0 ; w <= divTableControl.defaultLayout.lastCol; w++){
		var width = $('#d_0_'+w).css('width');
		ws.push(width);
	}
	return ws;
}

function getHeights(){
	var hs = new Array();
	for(var h = 0 ; h <= divTableControl.defaultLayout.lastRow; h++){
		var height = $('#d_'+h+'_0').css('height');
		hs.push(height);
	}
	return hs;
}

function getIndexOfDivById(cellId){
	if(!divTableControl.divInfos.divs){
		divTableControl.divInfos.divs = new Array();
		return -1;
	}
	for(var j = 0; j < divTableControl.divInfos.divs.length; j++){
		var div1 = divTableControl.divInfos.divs[j];
		if(div1.id == cellId){
			return j;
		}
	}
}

var countAutoAggrGraphs = 1;
function addModelReport(area,targetDivId){

	var callback = function(addedReportName, areaDom){
		var currA = 0;
		var rowNum = $(areaDom).parent().attr("row");
		var colNum = $(areaDom).parent().attr("col");
		//$('div[confName='+addedReportName+']').attr("title",rowNum+"_"+colNum);
		var cellId = $(area).parent().attr('id');
		for(var a = 0; a < controlUtil.areas.length;a++){
			if(controlUtil.areas[a].inDivCell == cellId) {
				controlUtil.areas[a].report = addedReportName;
				currA = controlUtil.areas[a];
				break;
			}
//			if(a + 1 == controlUtil.areas.length){
//				controlUtil.areas[a+1].report = addedReportName;
//				currA = controlUtil.areas[a+1];
//			}
		}
//		var divinf = {
//			id:cellId,
//			area:currA
//		}
//		if(!divTableControl.divInfos.divs)divTableControl.divInfos.divs = new Array();
//		divTableControl.divInfos.divs.push(divinf);
		//$(div).css('border-style','none');
	};
	
	currArea = area;
	var dataSet = $('#selectDs').val();
	//if(dsname) dataSet = dsname;
	var ds = aly.getDataSet(dataSet);
	//区别处理两种数据集
	//if(ds.type != 6){
		enableAcfBut();
	//}else{
	//	disableAcfBut();
	//}
	aly.checkDataSet(dataSet);
	if (ds._status != '')
	{
		alert(ds._status);
		return false;
	}
	if (ds.fields == null && ds.type != 6)
	{
		alert(resources.guide.js117);
		return false;
	}

	var n = $(area).attr('confName'); //'统计图'+countAutoAggrGraphs++;//$.trim($('#addConfName').val());
	
	if (aly.getRpx(n)) {
		alert(resources.guide.js119);
		countAutoAggrGraphs++;
		return false;
	}
	//$(currArea).attr("confName",n);
	var type = 2;
	if(area != null){
		var modelDisp = $(area.innerHTML);
		var modelName = modelDisp.attr('value');
	}
	
	//var conff = {type:type,name:n,reportId:'r'+new Date().getTime(),show:1,template:getSelDom1Value(selDom1),lefts:[],tops:[],fields:[],wheres:[],isRowData:1};
	var conff = {
		name:n
		,dataSet:dataSet
		//,dataSetLevel:'none/calc/where/group/having/order'
		,_hasAggr:0//'0/1'
		,_status:''//'为空表示正确，不为空是失效的具体信息'
		,type:type//1自定义分析报表/2模板报表
		,dialog:{
			open:1//0/1
			,top:100+Math.random()*100
			,left:100+Math.random()*200
			,width:500
			,height:400
		}
		,reportId:"rid"+getTime()
		,structType:1//:单条记录，全是统计字段/2:明细报表/3:分组及交叉报表

		,template:existRpx[0]
		,autoCalc:1//0/1
		,isRowData:1//0/1
		,lefts:[
			/*
			name:''
			,src:'字段信息'
			,srcName:''//原始字段名称
			,dataType:''
			,aggr:''
			,use:1
			,order:0无序/1升序/2降序
			,groups:[lefts,tops里的分组，空分组表示整体聚合]/null表示随分组自动聚合

			,analyse:{//指标字段
				analyseName:'占比/排名/比上期/比同期'
				,field:'被分析的测度字段'
				,scopeGroups:[空则表示针对全部]
			}
			,where:{conf:{}}
			,having:{conf:{}}
			,format:''
			,_finalType:''
			,_parentType:'top/left/field'
			,_fieldType:'group/detail/aggr/analyse'
			,_status:'为空表示正确，不为空是失效的具体信息'
			*/
		]
		,tops:[]
		,fields:[]
		,where:{conf:[]}
		,calcs:[]
	};
	sleep(1);//生成reportid
	if (type == 2) {
		var desc = existRpxDisc[0];
		for (var z=0; z<desc.split(";").length; z++) conff.fields[z] = null;
	}
	rqAnalyse.rpxs.push(conff);
	rqAnalyse.currRpx = n;
	artDialog.defaults.zIndex = zIndexBak;
	aly.refresh();
	if(!previewDbd) redefineFrameHeight(n);
	refreshItemsReportWhereBuf();
	if(callback) callback(n,currArea);
}

function addGridReport(area,dsname){
	var callback = function(addedReportName, areaDom){
		var currA = 0;
		var rowNum = $(areaDom).parent().attr("row");
		var colNum = $(areaDom).parent().attr("col");
		//$('div[confName='+addedReportName+']').attr("title",rowNum+"_"+colNum);
		var cellId = $(area).parent().attr('id');
		for(var a = 0; a < controlUtil.areas.length;a++){
			if(controlUtil.areas[a].inDivCell == cellId) {
				controlUtil.areas[a].report = addedReportName;
				currA = controlUtil.areas[a];
				break;
			}
//			if(a + 1 == controlUtil.areas.length){
//				controlUtil.areas[a+1].report = addedReportName;
//				currA = controlUtil.areas[a+1];
//			}
		}
//		var divinf = {
//			id:cellId,
//			area:currA
//		}
//		if(!divTableControl.divInfos.divs)divTableControl.divInfos.divs = new Array();
//		divTableControl.divInfos.divs.push(divinf);
		//$(div).css('border-style','none');
	};
	
	currArea = area;
	var dataSet = $('#selectDs').val();
	if(dsname) dataSet = dsname;
	var ds = aly.getDataSet(dataSet);
	//区别处理两种数据集
	//if(ds.type != 6){
		enableAcfBut();
	//}else{
	//	disableAcfBut();
	//}
	if( dataSet == null || dataSet.length == 0) {
		return;//没有选中数据集  也没有报表
	}
	aly.checkDataSet(dataSet);
	if (ds._status != '')
	{
		alert(ds._status);
		return false;
	}
	if (ds.fields == null && ds.type != 6)
	{
		alert(resources.guide.js117);
		return false;
	}

	var n = $(area).attr('confName');//$.trim($('#addConfName').val());
	
	if (aly.getRpx(n)) {
		alert(resources.guide.js119);
		countAutoAggrGraphs++;
		return false;
	}
	var type = 1;
	
	//var conff = {type:type,name:n,reportId:'r'+new Date().getTime(),show:1,template:getSelDom1Value(selDom1),lefts:[],tops:[],fields:[],wheres:[],isRowData:1};
	var conff = {
		name:n
		,dataSet:dataSet
		//,dataSetLevel:'none/calc/where/group/having/order'
		,_hasAggr:0//'0/1'
		,_status:''//'为空表示正确，不为空是失效的具体信息'
		,type:type//1自定义分析报表/2模板报表
		,dialog:{
			open:1//0/1
			,top:100+Math.random()*100
			,left:100+Math.random()*200
			,width:500
			,height:400
		}
		,reportId:"rid"+getTime()
		,structType:1//:单条记录，全是统计字段/2:明细报表/3:分组及交叉报表

		,template:""
		,autoCalc:1//0/1
		,isRowData:1//0/1
		,lefts:[
			/*
			name:''
			,src:'字段信息'
			,srcName:''//原始字段名称
			,dataType:''
			,aggr:''
			,use:1
			,order:0无序/1升序/2降序
			,groups:[lefts,tops里的分组，空分组表示整体聚合]/null表示随分组自动聚合

			,analyse:{//指标字段
				analyseName:'占比/排名/比上期/比同期'
				,field:'被分析的测度字段'
				,scopeGroups:[空则表示针对全部]
			}
			,where:{conf:{}}
			,having:{conf:{}}
			,format:''
			,_finalType:''
			,_parentType:'top/left/field'
			,_fieldType:'group/detail/aggr/analyse'
			,_status:'为空表示正确，不为空是失效的具体信息'
			*/
		]
		,tops:[]
		,fields:[]
		,where:{conf:[]}
		,calcs:[]
	};
	if (type == 2) {
		var desc = existRpxDisc[existRpx.indexOf(modelName)];
		for (var z=0; z<desc.split(";").length; z++) conff.fields[z] = null;
	}
	rqAnalyse.rpxs.push(conff);
	rqAnalyse.currRpx = n;
	artDialog.defaults.zIndex = zIndexBak;
	aly.refresh();
	if(!previewDbd) redefineFrameHeight(n);
	refreshItemsReportWhereBuf();
	if(callback) callback(n,currArea);
}

function redefineFrameHeight(n){
	var newHeight = parseInt($('iframe[confName='+n+']').parent().css('height')) - rmbarHeight;//减去area里bar和一点偏移
	$('iframe[confName='+n+']').css('height',newHeight+"px");
}

function changeCurrRpxDs(dsName){
	if(currDiv == null || dsName == "") return;
	var exsitRpx = aly.getRpx($(currDiv).find('.singleArea').attr('confName'));
	if(exsitRpx){
		rqAnalyse.currRpx = $(currDiv).find('.singleArea').attr('confName');
		var rpx = olapObj.rpxUtils.getRpx(rqAnalyse.currRpx);
		if(exsitRpx.dataSet != dsName) {
			exsitRpx.dataSet = dsName;
			rpx.where.conf = [];
		}
		refreshItemReportWhereBuf(rpx.name);
		aly.refresh(false,true);
	}else{
		if(createRpxType == 1) addGridReport($(currDiv).find('.singleArea')[0],dsName);
		else if(createRpxType == 2) addModelReport($(currDiv).find('.singleArea')[0],dsName);
	}
	$('#contentDiv').css('height','200px');
}

function addReportToArea(addedReportName, areaDom, type){
	createMenuBar(addedReportName, areaDom, type);
	if(!previewDbd && !finalView){
		$(areaDom).on('click',function(event){
			divTableControl.changeChoosedDiv($(areaDom).parent()[0]);
		});
	}
	preventPropagation(areaDom,'.dontchoose','click');
	var currA = 0;
	var rowNum = $(areaDom).parent().attr("row");
	var colNum = $(areaDom).parent().attr("col");
	$(areaDom).attr("confName",addedReportName);
	//$('div[confName='+addedReportName+']').attr("title",rowNum+"_"+colNum);
	var cellId = $(areaDom).parent().attr('id');
	for(var a = 0; a < controlUtil.areas.length;a++){
		if(controlUtil.areas[a].inDivCell == cellId) {
			controlUtil.areas[a].report = addedReportName;
			currA = controlUtil.areas[a];
			break;
		}
		if(a + 1 == controlUtil.areas.length){
			controlUtil.areas[a+1].report = addedReportName;
			currA = controlUtil.areas[a+1];
		}
	}
//	var divinf = {
//		id:cellId,
//		area:currA
//	}
//	if(!divTableControl.divInfos.divs)divTableControl.divInfos.divs = new Array();
//	console.log('addreport');
//	console.log(divinf);
//	divTableControl.divInfos.divs.push(divinf);
}

function createMenuBar(reportName, areaDom, type){
	var hideFilterButton = false;
	var hideCleanButton = false;
	if(type == -1 || type == "editor" || type == "blank" || type == "paramFormTop") hideFilterButton = true;
	if(type == "blank") hideCleanButton = true;
	var bar = $('<div class="rmbar"></div>');
	$(areaDom).append(bar);
	var extendClasses = " box-header";
	if(!isMobileView) extendClasses += " well";
	if(type == "blank") extendClasses = "";
	var barinner = $('<div class="rmbar row-fluid'+extendClasses+'" id="rmbar_'+reportName+'"></div>')
	bar.append(barinner);
	barinner.append('<div style="word-break:keep-all;display:inline-flex" class="span2 dontchoose"></div>');
	barinner.append('<div style="float:right" class="operationButtonInRmBar dontchoose"></div>');
	var divs = barinner.find('div');
	$(divs[1]).append('<div class="dontchoose box-icon1" style="float:left"></div>');
	$(divs[1]).append('<div class="dontchoose box-icon1" style="float:left"></div>');
	$(divs[1]).append('<div class="dontchoose box-icon1" style="float:left"></div>');
	$(divs[0]).append('<div class="barReportName barReportTitle dontchoose" id="barReportTitle_'+reportName+'" value="'+reportName+'"><h2>'+reportName+'</h2></div>');
	$(divs[0]).append('<div class="barEditorTitle dontchoose" id="barEditorTitle_'+reportName+'" style="display:none">控件</div>');
	if(type == "blank") {
		$(divs[0]).removeClass("span2").hide();
		$(divs[1]).addClass("span12");
	}
	if(!previewDbd) {
		bindBarReportNameEvent(divs[0],reportName);
		var div1 = $(divs[1]).find('div')[0];
		var div2 = $(divs[1]).find('div')[1];
		var div3 = $(divs[1]).find('div')[2];
		if(hideFilterButton && type != "paramFormTop") $(div1).hide();
		if(hideCleanButton) $(div2).hide();
		if(type != "paramFormTop") {
			$(div1).append('<a title="报表参数" class="reportWhere btn btn-round btn-default" style="cursor:no-drop">'
					+'<svg t="1593431514875" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="2259" width="12" height="12"><path d="M608.256 960c-17.696 0-32-14.304-32-32V448a31.912 31.912 0 0 1 8.256-21.44l208.8-234.496h-562.88L439.648 426.72a32.03 32.03 0 0 1 8.096 21.312V736.8l50.848 41.152c13.76 11.136 15.872 31.264 4.736 44.992s-31.264 15.84-44.992 4.736l-62.72-50.752c-7.52-6.048-11.872-15.232-11.872-24.864V460.192L135.136 181.344c-8.384-9.408-10.464-22.88-5.312-34.4 5.152-11.488 16.608-18.912 29.216-18.912h706.336c12.672 0 24.128 7.456 29.248 19.008s2.976 25.056-5.504 34.432L640.256 460.288V928c0 17.696-14.304 32-32 32z" p-id="2260"></path></svg>'
					+'</a>');
		}else{
			//var div1_1 = $('<div class="dontchoose box-icon" style="float:left"></div>');
			$(div1).append('<a title="参数表单设置" class="paramFormOperator btn btn-round btn-default" style="cursor:pointer" onclick="useParamFormDialog();return false;">'
					+'<svg t="1606970368162" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="5567" width="12" height="12"><path d="M610.986667 1024h-197.973334c-20.48 0-37.546667-13.653333-40.96-34.133333l-17.066666-122.88c-23.893333-10.24-47.786667-23.893333-71.68-40.96L170.666667 870.4c-20.48 6.826667-40.96 0-51.2-17.066667L20.48 682.666667c-10.24-17.066667-6.826667-40.96 10.24-54.613334l95.573333-75.093333c0-17.066667-3.413333-27.306667-3.413333-40.96s0-23.893333 3.413333-40.96L34.133333 395.946667c-17.066667-13.653333-20.48-34.133333-10.24-54.613334l98.986667-170.666666c6.826667-17.066667 30.72-27.306667 47.786667-17.066667l112.64 44.373333c23.893333-17.066667 47.786667-30.72 68.266666-40.96l20.48-122.88c3.413333-20.48 20.48-34.133333 40.96-34.133333h197.973334c20.48 0 37.546667 13.653333 40.96 34.133333l17.066666 122.88c23.893333 10.24 47.786667 23.893333 71.68 40.96L853.333333 153.6c20.48-6.826667 40.96 0 51.2 17.066667l98.986667 170.666666c10.24 17.066667 6.826667 40.96-10.24 54.613334l-95.573333 75.093333c0 10.24 3.413333 27.306667 3.413333 40.96s0 30.72-3.413333 40.96l95.573333 75.093333c17.066667 13.653333 20.48 34.133333 10.24 54.613334l-98.986667 170.666666c-10.24 17.066667-30.72 27.306667-51.2 17.066667l-112.64-44.373333c-23.893333 17.066667-47.786667 30.72-68.266666 40.96l-20.48 122.88c-3.413333 20.48-20.48 34.133333-40.96 34.133333z m-324.266667-235.52c3.413333 0 6.826667 0 10.24 3.413333 23.893333 20.48 51.2 34.133333 78.506667 47.786667 6.826667 3.413333 10.24 6.826667 10.24 13.653333l17.066666 129.706667c0 3.413333 3.413333 6.826667 6.826667 6.826667h197.973333c3.413333 0 6.826667-3.413333 6.826667-6.826667l17.066667-133.12c0-6.826667 3.413333-10.24 10.24-13.653333 27.306667-10.24 51.2-27.306667 78.506666-47.786667 3.413333-3.413333 10.24-3.413333 17.066667-3.413333l122.88 47.786666c3.413333 0 6.826667 0 10.24-3.413333l98.986667-170.666667c3.413333-3.413333 0-6.826667-3.413334-10.24l-102.4-81.92c-3.413333-3.413333-6.826667-10.24-6.826666-17.066666 0-13.653333 3.413333-30.72 3.413333-47.786667s0-34.133333-3.413333-47.786667c0-6.826667 0-10.24 6.826666-17.066666l102.4-81.92c3.413333-3.413333 3.413333-6.826667 0-10.24l-98.986666-170.666667c-3.413333-3.413333-6.826667-3.413333-10.24-3.413333l-122.88 47.786666c-6.826667 3.413333-13.653333 0-17.066667-3.413333-23.893333-20.48-51.2-34.133333-78.506667-47.786667-6.826667-3.413333-10.24-6.826667-10.24-13.653333L610.986667 23.893333c6.826667 13.653333 3.413333 10.24 0 10.24h-197.973334c-3.413333 0-6.826667 3.413333-6.826666 6.826667L389.12 170.666667c0 6.826667-3.413333 10.24-10.24 13.653333-27.306667 10.24-51.2 27.306667-78.506667 47.786667-6.826667 3.413333-13.653333 3.413333-17.066666 0L160.426667 184.32c-3.413333 0-6.826667 0-10.24 3.413333l-98.986667 170.666667c-3.413333 3.413333 0 6.826667 3.413333 10.24l102.4 81.92c3.413333 3.413333 6.826667 10.24 6.826667 17.066667-3.413333 17.066667-3.413333 34.133333-3.413333 47.786666s0 27.306667 3.413333 47.786667c0 6.826667 0 10.24-6.826667 17.066667l-102.4 81.92c-3.413333 3.413333-3.413333 6.826667 0 10.24l98.986667 170.666666c3.413333 3.413333 6.826667 3.413333 10.24 3.413334l122.88-47.786667c-3.413333-10.24 0-10.24 0-10.24z m228.693333-71.68c-112.64 0-204.8-92.16-204.8-204.8s92.16-204.8 204.8-204.8 204.8 92.16 204.8 204.8-92.16 204.8-204.8 204.8z m0-375.466667c-95.573333 0-170.666667 75.093333-170.666666 170.666667s75.093333 170.666667 170.666666 170.666667 170.666667-75.093333 170.666667-170.666667-75.093333-170.666667-170.666667-170.666667z" fill="" p-id="5568"></path></svg>'
					+'</a>');
			//div1.after(div1_1[0]);
		}
		
		$(div2).append('<a title="清空内容" class="btn btn-round btn-default" href="javascript:removeContent(\''+reportName+'\',false,\''+type+'\');">'
				+'<svg t="1593431952488" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="3379" width="12" height="12"><path d="M583.0656 59.8016a71.68 71.68 0 0 1 45.8752 16.5888l288.9728 242.4832a71.8848 71.8848 0 0 1 8.8064 100.9664l-430.08 513.2288a72.0896 72.0896 0 0 1-55.0912 25.3952 70.656 70.656 0 0 1-46.4896-16.384L106.0864 699.5968a71.8848 71.8848 0 0 1-8.8064-100.9664l430.08-513.2288a72.2944 72.2944 0 0 1 55.0912-25.6m0-51.2a122.88 122.88 0 0 0-94.208 43.8272l-430.08 513.2288a122.88 122.88 0 0 0 15.1552 173.056l288.768 242.4832a122.88 122.88 0 0 0 173.056-15.1552l430.08-513.4336a122.88 122.88 0 0 0-15.1552-173.056L661.9136 37.2736a122.88 122.88 0 0 0-78.848-28.672z" p-id="3380"></path><path d="M700.0064 599.4496a26.0096 26.0096 0 0 1-16.384-5.9392 25.6 25.6 0 0 1-3.2768-36.0448l132.096-157.2864a25.6 25.6 0 1 1 39.1168 32.9728l-131.8912 157.0816a25.3952 25.3952 0 0 1-19.6608 9.216zM139.40736 516.608l32.91136-39.2192 434.8928 364.91264-32.91136 39.2192zM921.6 1015.3984H637.7472a25.6 25.6 0 0 1 0-51.2H921.6a25.6 25.6 0 0 1 0 51.2z" p-id="3381"></path></svg>'
				+'</a>');
		if(type == "editor") $(div3).append('<a title="去掉此组件" class="reportRemove btn btn-round btn-default" href="javascript:removeEditor(\''+reportName+'\');">'
				+'<svg t="1593431993322" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="4535" width="12" height="12"><path d="M557.312 513.248l265.28-263.904a31.968 31.968 0 1 0-45.12-45.376l-265.344 263.936-263.04-263.84A32 32 0 0 0 203.776 249.28l262.976 263.776L201.6 776.8a31.968 31.968 0 1 0 45.12 45.376l265.216-263.808 265.44 266.24a31.872 31.872 0 0 0 45.248 0.064 32 32 0 0 0 0.064-45.248l-265.376-266.176z" p-id="4536"></path></svg>'
				+'</a>');
		else $(div3).append('<a title="去掉此组件" class="reportRemove btn btn-round btn-default" href="javascript:removeReport(\''+reportName+'\');">'
				+'<svg t="1593431993322" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="4535" width="12" height="12"><path d="M557.312 513.248l265.28-263.904a31.968 31.968 0 1 0-45.12-45.376l-265.344 263.936-263.04-263.84A32 32 0 0 0 203.776 249.28l262.976 263.776L201.6 776.8a31.968 31.968 0 1 0 45.12 45.376l265.216-263.808 265.44 266.24a31.872 31.872 0 0 0 45.248 0.064 32 32 0 0 0 0.064-45.248l-265.376-266.176z" p-id="4536"></path></svg>'
				+'</a>');
	}
}

function cleanSideBoard(){
	$('#contentDiv').html('<p>请选择数据集</p>');
	$('#items').html('<p>请选择数据集</p>');
	$('#gridTable').children().remove();
	$('#allReportStyles').children().remove();
	$('#modelReportFields').children().remove();
}

function editReport(rn){
	var editDiv = $('.barReportName[value='+rn+']');
	var inputWidth = editDiv.css('width');
	editDiv.html('');
	if($('#rmNameEditor').length > 0) {
		saveRmName($('#rmNameEditor').attr('value'));
	}
	var input = $('<input  class="dontchoose" id="rmNameEditor" style="width:'+inputWidth+';" type=text value="'+rn+'"/>');
	editDiv.append(input);
	input.focus();
	editDiv.on('click','input',function(event){
		event.stopPropagation();
	});
	input.keydown(function(e){
		e = e||window.event;
	  if (e.keyCode == 13)
	  {
	    e.returnValue=false;
	    e.cancel = true;
	    editingReportName = false;
	    //rn = controlUtil.checkGetAreaName(rn,controlUtil.areas);
	    saveRmName(rn);
	  }
	});
	input.blur(function(e){
	    saveRmName(rn);
	});
	editingReportName = true;
}

function saveRmName(rn){
	var editDiv = $('.barReportName[value='+rn+']');
	var n = $('#rmNameEditor').val();
	if (n == '') {
		alert(resources.guide.js112);
		editDiv.html(rn);
		dealDisplayOfLongStr(editDiv[0], 150);
		return;
	}
	
	if(rn == n) {
		editDiv.html("<h2>"+rn+"</h2>").attr('value',rn);
		dealDisplayOfLongStr(editDiv[0], 150);
		return;
	}
	var areaExistReportName = false;
	//$(t2tds[0]).find('div[confName="'+cn+'"]').html(n);
	for(var i = 0; i < controlUtil.areas.length; i++){
		var area = controlUtil.areas[i];
		areaExistReportName = area.report == n;
		if(areaExistReportName) break;
	}
	
	if(areaExistReportName){
		editDiv.html("<h2>"+rn+"</h2>").attr('value',rn);
		alert(resources.guide.js113);
		return;
	}
	//$('.singleArea[confName='+rn+']').attr('confName',n);
	editDiv.html("<h2>"+n+"</h2>").attr('value',n);
	editDiv.parent().parent().find('a.reportRemove').attr('href',"javascript:removeReport('"+n+"')");
	dealDisplayOfLongStr(editDiv[0], 150);
	controlUtil.changeInfo(rn,n);
	bindBarReportNameEvent(editDiv.parent(),n);
	var rpx = aly.getRpx(rn);
	if(rpx == null) return;
	rpx.name = n;
	var reports = aly.cache.reports;
	for (var i=0; i<reports.length; i++) {
		if (reports[i].name == rn) {
			reports[i].dlg.close();
			reports[i].dlg.DOM.wrap.remove();
			reports.remove(reports[i]);
			break;
		}
	}
	artDialog.defaults.zIndex = zIndexBak;
	setTimeout(function(){
		var currAreaId = controlUtil.changeInfo(rn,n);
		currArea = $('#'+currAreaId);
		rqAnalyse.currRpx = n;
		aly.refreshReport(n, false, false);
		aly.refresh();
		if(!previewDbd) redefineFrameHeight(n);
	},1);
	
}

function bindBarReportNameEvent(d,reportName){
	unbindBarReportNameEvent(d);
	$(d).on('click','.barReportTitle',function(event){event.stopPropagation();editReport(reportName);})
	.on('mouseover','.barReportTitle',function(e){$(e.target).addClass('showBrnBorder')})
	.on('mouseout','.barReportTitle',function(e){$(e.target).removeClass('showBrnBorder')});
}

function unbindBarReportNameEvent(d){
	$(d).off();
}

function showDsParameters(dataSet){
	dataSet = aly.getDataSet(dataSet);
	aly.params = [];
	aly.paramNames = [];
	
	var inFunc = function() {
		var filter1 = "";
//		var params = aly.params;
//			if (dataSet.type == 6 || dataSet.type == 7) filter1 = whereUtils.getExp(conf.where.conf, "T1.", 1);
//			else filter1 = whereUtils.getExp(conf.where.conf, "", 1, 2);
		//20190925
		var saveFunc = function () {
			var disp = whereUtils.getDisp(cache.where1.wheres);
			if (disp == '') return false;
//				var rpxs = rqAnalyse.rpxs;
//				for(var r = 0; r < rpxs.length; r++){
//					var conf = rpxs[r];
//					conf.where.conf = cache.where1.wheres;
//					var exp = '';
//					if (dataSet.type == 6 || dataSet.type == 7) exp = whereUtils.getExp(conf.where.conf, "T1.", 1);
//					else exp = whereUtils.getExp(conf.where.conf, "", 1, 2);
//				}
			var dsWhereParamItem = {dsname:dataSet.name,wheres:cache.where1.wheres};
			if(aly.dsWhereParams != null && aly.dsWhereParams.length > 0){
				for(var d = 0; d < aly.dsWhereParams.length; d++) {
					var tempDsWhereParamItem = aly.dsWhereParams[d];
					if(tempDsWhereParamItem.dsname == dataSet.name) {aly.dsWhereParams = aly.dsWhereParams.deleteIndex(d);break;}
				}
			}else{
				aly.dsWhereParams = [];
			}
			aly.dsWhereParams.push(dsWhereParamItem);
			dataSet.params = cache.where1.wheres;
			//2019.11.25多个数据集可能共享参数
//				for (var i=0; i<rqAnalyse.dataSets.length; i++) {
//					if(rqAnalyse.dataSets[i].type == dataSet.type)//不同类型数据集，where条件对象不可通用
//					rqAnalyse.dataSets[i].params = cache.where1.wheres;
//				}
			setTimeout("aly.refreshAll();",1);
			artDialog.defaults.zIndex = zIndexBak;
			return true;
		 };
		 var clearFunc = function () {
			var rpxs = rqAnalyse.rpxs;
//				for(var r = 0; r < rpxs.length; r++){
//					var conf = rpxs[r];
//					conf.where.conf = [];
//					var exp = '';
//					if (dataSet.type == 6 || dataSet.type == 7) exp = whereUtils.getExp(conf.where.conf, "T1.", 1);
//					else exp = whereUtils.getExp(conf.where.conf, "", 1, 2);
//				}
			aly.dsWhereParams = [];
			dataSet.params = [];
			//setTimeout("aly.refreshAll();",1);
			aly.refreshAll();//火狐setTimeout没调用到
			artDialog.defaults.zIndex = zIndexBak;
			return true;
		}

		var fields = [];
		if (dataSet.type == 6){
			var ts = dataSet.tableName.split(",");
			for (var i=0; i<ts.length; i++) cus.getFieldInfos(ts[i], fields, 0, null, null,true);//2019.09.26改成true
			for (var i=0; i<fields.length; i++) fields[i] = transWhereInfo(fields[i],null,false);
		} else {
			for (var n=0; n<dataSet.fields.length; n++) {
				var itemn = dataSet.fields[n];
				if (itemn.exp && itemn.exp != '') continue;
				fields[fields.length] = {disp:itemn.name,dataType:itemn.dataType,edit:itemn.edit,exp:itemn.name,valueType:1,values:""};
			}
		}
		var initField = fields[0];
		var choosesp = aly.sysparams != null && aly.sysparams.length > 0;
		whereUtils.openWhereDialog(saveFunc, clearFunc, choosesp);
		if(aly.dsWhereParams == null) aly.dsWhereParams = [];
		if(dataSet.params == null) dataSet.params = [];
		whereUtils.refresh(fields, initField, JSON.parse(JSON.stringify(dataSet.params)), true, choosesp);
	}
	analyseApi.complexWhereFunc(inFunc);
}

function dsParameterButtonEvent(){
	var dataSet = $('#selectDs').val();
	if(dataSet == "" || $('#selectDs').disabled == "disabled") {
		flash($('#selectDs'),4);
		return;
	}
	
	var conf = null;
	var rpxname = divTableControl.getInnerReport(currDiv);
	if(rpxname) conf = aly.getRpx(rpxname);
	showDsParameters(dataSet);
	return;
}

function flash(d,flag,color){//flag必须是偶数
	var color_ = color ? color :'#ffb5a8';
	setTimeout(function(){
		if(flag != 0){
			if(flag-- % 2 == 0)
				d.css('background-color',color_);
			else
				d.css('background-color','');
			flash(d,flag,color)
		}
	},80);
}


function preventPropagation(p,s,e){
	$(p).on(e,s,function(event){
		event.stopPropagation();
	});
}

function dsAddCalcField(){
	aly.editCalcField(null,function(){
		aly.refresh(true,true);
	});
}

function enableAcfBut(){
	enableStyle($('#acfBut'),this.dsAddCalcField);
}

function disableAcfBut(){
	disableStyle($('#acfBut'));
}

function enableStyle($1,f,confItem, dataSet){
	$1.off();
	$1.css('cursor','pointer');
	$1.addClass('enable');
	$1.on('click',function(){f(confItem,dataSet)});
}

function disableStyle($1){
	$1.css('cursor','no-drop');
	$1.removeClass('enable');
	$1.off();
}

function refreshItemReportWhereBuf(rpxname){
	if(rpxname == null) return;
	var conf = aly.getRpx(rpxname);
	var area = controlUtil.getAreaByReport(rpxname);
	disableStyle($('#rmbar_'+rpxname).find('.reportWhere'));
	var areaType = $(area).attr('type');//-1是空白,0是报表,1是控件,2是统计图
	var isNotEnabled = $("#singleArea"+area.id).find('.reportWhere')[0].className.indexOf('enabled') < 0;
	var dataSet = aly.getDataSet(conf.dataSet);
	if(isNotEnabled){
		var f = function(confItem, dataSet){
			var inFunc = function() {
				//改变光标位置
				var divcell = $('.singleArea[confname="'+confItem.name+'"]').parent()[0];
				if( !isChoosed(divcell) ){
					divTableControl.changeChoosedDiv(divcell);
				}
				var filter1 = "";
				if (dataSet.type == 6 || dataSet.type == 7) filter1 = whereUtils.getExp(confItem.where.conf, "T1.", 1);
				else filter1 = whereUtils.getExp(confItem.where.conf, "", 1, 2);
				var saveFunc = function () {
					var disp = whereUtils.getDisp(cache.where1.wheres);
					if (disp == '') return false;
					confItem.where.conf = cache.where1.wheres;
					var exp = '';
					if (dataSet.type == 6 || dataSet.type == 7) exp = whereUtils.getExp(confItem.where.conf, "T1.", 1);
					else exp = whereUtils.getExp(confItem.where.conf, "", 1, 2);
					if (exp != filter1) {
						setTimeout("aly.refresh();",1);
					}
					artDialog.defaults.zIndex = zIndexBak;
					return true;
				 };
				 var clearFunc = function () {
					confItem.where.conf = [];
					var exp = '';
					if (dataSet.type == 6 || dataSet.type == 7) exp = whereUtils.getExp(confItem.where.conf, "T1.", 1);
					else exp = whereUtils.getExp(confItem.where.conf, "", 1, 2);
					if (exp != filter1) {
						setTimeout("aly.refresh();",1);
					}
					artDialog.defaults.zIndex = zIndexBak;
					return true;
				}

				var fields = [];
				if (dataSet.type == 6){
					var ts = aly.getDataSet(confItem.dataSet).tableName.split(",");
					//for (var i=0; i<ts.length; i++) cus.getFieldInfos(ts[i], fields, 0, null, null,false);
					for(var i = 0; i < confItem.fields.length; i++){
						fields[fields.length] = confItem.fields[i].src;
					}
					for(var i2 = 0; i2 < confItem.tops.length; i2++){
						fields[fields.length] = confItem.tops[i2].src;
					}
					for(var i3 = 0; i3 < confItem.lefts.length; i3++){
						fields[fields.length] = confItem.lefts[i3].src;
					}
					for (var i=0; i<fields.length; i++) fields[i] = transWhereInfo(fields[i],null,false);
					if(fields.length == 0) {
						alert("此类型报表中没有字段时无法过滤");
						return;
					}
				} else {
					for (var n=0; n<dataSet.fields.length; n++) {
						var itemn = dataSet.fields[n];
						if (itemn.exp && itemn.exp != '') continue;
						fields[fields.length] = {disp:itemn.name,dataType:itemn.dataType,edit:itemn.edit,exp:itemn.name,valueType:1,values:""};
					}
				}
				var initField = fields[0];
				
				var choosesp = aly.sysparams != null && aly.sysparams.length > 0;
				whereUtils.openWhereDialog(saveFunc, clearFunc, choosesp);
				if(aly.dsWhereParams == null) aly.dsWhereParams = [];
				if(dataSet.params == null) dataSet.params = [];
				whereUtils.refresh(fields, initField, JSON.parse(JSON.stringify(confItem.where.conf)), true, choosesp);
			}
			analyseApi.complexWhereFunc(inFunc);
		};
		enableStyle($("#singleArea"+area.id).find('.reportWhere'),f,conf, dataSet);
	}
	/*var toEditorButtons = $('.toEditor');
	for(var j = 0; j < toEditorButtons.length; j++){
		var area = findParentArea(toEditorButtons[j]);
		var areaType = $(area).attr('type');
		if(!areaType) {
			areaType = "0";
			$(area).attr('type',"0");
		}
		if(areaType == "1"){
			$(area).find('.toEditor').hide();
		}else if(areaType == "0"){
			$(area).find('.toReport').hide();
		}
	}*/
	
}

function refreshItemsReportWhereBuf(){
	var rpxs = rqAnalyse.rpxs;
	disableStyle($('.reportWhere'));
	for(var r = 0; r < rpxs.length; r++){
		var conf = rpxs[r];
		var area = controlUtil.getAreaByReport(conf.name);
		var areaType = $(area).attr('type');//-1是空白,0是报表,1是控件,2是统计图
		var isNotEnabled = $("#singleArea"+area.id).find('.reportWhere')[0].className.indexOf('enabled') < 0;
		var dataSet = aly.getDataSet(conf.dataSet);
		if(isNotEnabled){
			var f = function(confItem, dataSet){
				var inFunc = function() {
					//改变光标位置
					var divcell = $('.singleArea[confname="'+confItem.name+'"]').parent()[0];
					if( !isChoosed(divcell) ){
						divTableControl.changeChoosedDiv(divcell);
					}
					var filter1 = "";
					if (dataSet.type == 6 || dataSet.type == 7) filter1 = whereUtils.getExp(confItem.where.conf, "T1.", 1);
					else filter1 = whereUtils.getExp(confItem.where.conf, "", 1, 2);
					var saveFunc = function () {
						var disp = whereUtils.getDisp(cache.where1.wheres);
						if (disp == '') return false;
						confItem.where.conf = cache.where1.wheres;
						var exp = '';
						if (dataSet.type == 6 || dataSet.type == 7) exp = whereUtils.getExp(confItem.where.conf, "T1.", 1);
						else exp = whereUtils.getExp(confItem.where.conf, "", 1, 2);
						if (exp != filter1) {
							setTimeout("aly.refresh();",1);
						}
						artDialog.defaults.zIndex = zIndexBak;
						return true;
					 };
					 var clearFunc = function () {
						confItem.where.conf = [];
						var exp = '';
						if (dataSet.type == 6 || dataSet.type == 7) exp = whereUtils.getExp(confItem.where.conf, "T1.", 1);
						else exp = whereUtils.getExp(confItem.where.conf, "", 1, 2);
						if (exp != filter1) {
							setTimeout("aly.refresh();",1);
						}
						artDialog.defaults.zIndex = zIndexBak;
						return true;
					}

					var fields = [];
					if (dataSet.type == 6){
						var ts = aly.getDataSet(confItem.dataSet).tableName.split(",");
						//for (var i=0; i<ts.length; i++) cus.getFieldInfos(ts[i], fields, 0, null, null,false);
						for(var i = 0; i < confItem.fields.length; i++){
							fields[fields.length] = confItem.fields[i].src;
						}
						for(var i2 = 0; i2 < confItem.tops.length; i2++){
							fields[fields.length] = confItem.tops[i2].src;
						}
						for(var i3 = 0; i3 < confItem.lefts.length; i3++){
							fields[fields.length] = confItem.lefts[i3].src;
						}
						for (var i=0; i<fields.length; i++) fields[i] = transWhereInfo(fields[i],null,false);
						if(fields.length == 0) {
							alert("此类型报表中没有字段时无法过滤");
							return;
						}
					} else {
						for (var n=0; n<dataSet.fields.length; n++) {
							var itemn = dataSet.fields[n];
							if (itemn.exp && itemn.exp != '') continue;
							fields[fields.length] = {disp:itemn.name,dataType:itemn.dataType,edit:itemn.edit,exp:itemn.name,valueType:1,values:""};
						}
					}
					var initField = fields[0];
					
					var choosesp = aly.sysparams != null && aly.sysparams.length > 0;
					whereUtils.openWhereDialog(saveFunc, clearFunc, choosesp);
					if(aly.dsWhereParams == null) aly.dsWhereParams = [];
					if(dataSet.params == null) dataSet.params = [];
					whereUtils.refresh(fields, initField, JSON.parse(JSON.stringify(confItem.where.conf)), true, choosesp);
				}
				analyseApi.complexWhereFunc(inFunc);
			};
			enableStyle($("#singleArea"+area.id).find('.reportWhere'),f,conf, dataSet);
		}
	}
	var toEditorButtons = $('.toEditor');
	for(var j = 0; j < toEditorButtons.length; j++){
		var area = findParentArea(toEditorButtons[j]);
		var areaType = $(area).attr('type');
		if(!areaType) {
			areaType = "0";
			$(area).attr('type',"0");
		}
		if(areaType == "1"){
			$(area).find('.toEditor').hide();
		}else if(areaType == "0"){
			$(area).find('.toReport').hide();
		}
	}
}

function findParentArea(e){
	var p = $(e).parent();
	if(p == null) return null;
	if(p.hasClass('singleArea')) {
		return p;
	}
	else {
		return findParentArea(p);
	}
}


function preview(){
	//var isOpenOlapFile = guideConf.openDOlap == 'true' || guideConf.openDOlap == true;
	//if((!isOpenOlapFile || olapFile[0] == "{") || domModified) {
		var name = saveOlapTemp();
		olapFile = guideConf.olapFolderOnServer + "temp/"+name;
	//}
	$('#preview').css('cursor','progress');
	setTimeout(function(){
		$('#preview').css('cursor','pointer');
		window.location = './view.jsp?olap='+encodeURIComponent(olapFile);
	},1000);
}

function findReportInArray(rpxs,name){
	for(var i = 0; i < rpxs.length; i++){
		if(rpxs[i].name == name) {
			return rpxs[i];
		}
	}
}

function checkHasReport(d){
	var rname = $(d).find('.singleArea').attr('confName');
	return aly.getRpx(rname) != null;
}

function sleep(numberMillis) { 
	var now = new Date(); 
	var exitTime = now.getTime() + numberMillis; 
	while (true) { 
		now = new Date(); 
		if (now.getTime() > exitTime) 
			return; 
	} 
}

function sysparams(){
	var dlg = null;
	return {
		addOneParam:function(){
			dlg = art.dialog({
				id : 2762,
				title : "增加参数",
			    content: '<div id="sysparams_div" style="width:100%;height:100%;overflow:auto;">'
			    	+'<table id="sys_p_content" style="width:100%"></table></div>'
		    	,button: [
		    	     ]
			    ,ok : function(){
			    	var param = null;
			    	if(aly.sysparams == null) aly.sysparams = [];
					var saveSysTrs = $('.sysParamsTr');
					for(var i = 0 ; i < saveSysTrs.length; i++){
						var pname = $(saveSysTrs[i]).find('.sp_name').val();
						var val = $(saveSysTrs[i]).find('.sp_value').val();
						var ptype = $(saveSysTrs[i]).find('.sp_type').val();
						//校验
						if(pname == null || pname.length == 0){
							alert("参数名不能为空");
							return false;
						}
						for(var j = 0; j < aly.sysparams.length; j++){
							if(pname == aly.sysparams[j].name){
								alert("有重复的参数名，添加失败");
								return false;
							}
						}
						if(val == null || val.length == 0){
							alert("值不能为空");
							return false;
						}
						if(ptype == "8") {
							//日期
							var isDate = /^\d{4}\-\d{1,2}\-\d{1,2}$/g.test(val);
							if(!isDate) {
								alert("日期请使用yyyy-MM-DD格式");
								return false;
							}
						}else if(ptype == "10") {
							//日期时间
							var isDateTime = /^\d{4}\-\d{1,2}\-\d{1,2}\s\d{1,2}\:\d{1,2}\:\d{1,2}$/g.test(val);
							if(!isDateTime) {
								alert("日期时间请使用yyyy-MM-DD HH:mm:ss格式");
								return false;
							}
						}
						param = {name:pname,value:val,type:ptype};
					}
					//覆盖
					aly.sysparams[aly.sysparams.length] = param;
					//editors
					$('#sysparamsSelector').append("<option value='"+param.name+"'>"+param.name+"</option>");
					$('#sysparamsSelector').val(param.name);
					dlg.close();
					return false;
			    }
			    ,cancel : function(){
					artDialog.defaults.zIndex = zIndexBak;
					return true;
				}
			    ,okVal : resources.guide.js51
			    ,cancelVal : '退出'
			    ,lock : true
			    ,duration : 0
				,zIndex : 44444
			    ,width : '900px'
				,height : '200px'
				,opacity : 0.1
				,padding : '2px 2px'
			});
			$('#sysparams_div').find('#sys_p_content').append('<tr><th>名称</th><th>值</th><th>类型</th><th>&nbsp;</th></tr>');
			addSysParam(null,true);
		}
		,getSysparams:function(){
			zIndexBak = artDialog.defaults.zIndex;
			dlg = art.dialog({
				id : 2762,
				title : "共享参数",
			    content: '<div id="sysparams_div" style="width:100%;height:100%;overflow:auto;">'
			    	+'<table id="sys_p_content" style="width:100%"></table></div>'
		    	,ok : this.saveSysparams
			    ,cancel : function(){
					artDialog.defaults.zIndex = zIndexBak;
					return true;
				}
			    ,okVal : resources.guide.js51
			    ,cancelVal : '退出'
			    ,lock : true
			    ,duration : 0
				,zIndex : 11111
			    ,width : '900px'
				,height : '400px'
				,opacity : 0.1
				,padding : '2px 2px'
			});
			this.initSysparams();
		},
		initSysparams:function(){
			$('#sysparams_div').append('<a onclick="addSysParam();">添加</a>');
			$('#sysparams_div').find('#sys_p_content').append('<tr><th>名称</th><th>值</th><th>类型</th><th>&nbsp;</th></tr>');
			var initparams = aly.sysparams;
			if(initparams != null && initparams.length > 0){
				for(var j = 0; j < initparams.length; j++){
					addSysParam(initparams[j]);
				}
			}else{
				aly.sysparams = [];
			}
		},
		saveSysparams:function(){
			var warn = false;
			var params = [];
			var saveSysTrs = $('.sysParamsTr');
			outerp:for(var i = 0 ; i < saveSysTrs.length; i++){
				var pname = $(saveSysTrs[i]).find('.sp_name').val();
				var val = $(saveSysTrs[i]).find('.sp_value').val();
				var ptype = $(saveSysTrs[i]).find('.sp_type').val();
				var old_pname = $(saveSysTrs[i]).attr('id');
				var changedPname = old_pname != pname;
				//校验
				if(pname == null || pname.length == 0){
					alert("参数名不能为空");
					return false;
				}
				if(val == null || val.length == 0){
					alert("值不能为空");
					return false;
				}
				if(ptype == "8") {
					//日期
					var isDate = /^\d{4}\-\d{1,2}\-\d{1,2}$/g.test(val);
					if(!isDate) {
						alert("日期请使用yyyy-MM-DD格式");
						return false;
					}
				}else if(ptype == "10") {
					//日期时间
					var isDateTime = /^\d{4}\-\d{1,2}\-\d{1,2}\s\d{1,2}\:\d{1,2}\:\d{1,2}$/g.test(val);
					if(!isDateTime) {
						alert("日期时间请使用yyyy-MM-DD HH:mm:ss格式");
						return false;
					}
				}
				var param = {name:pname,value:val,type:ptype};
				for(var j = 0; j < params.length; j++){
					if(pname == params[j].name){
						alert("有重复的参数名，只能保留一个【"+params[j].name+"】\n当前值："+params[j].value);
						warn = true;
						continue outerp;
					}
				}
				params.push(param);
				if(changedPname) {
					changeSysParamName(old_pname,pname);
				}
				editorValueChange(pname,val,true);
				refreshInvokedParams(pname,val);
			}
			//覆盖
			aly.sysparams = params;
			//editors
			$('#sysparamsSelector').html('');
			createSysParamsSelector($('#sysparamsSelector'));
			
			if(!warn) {
				alert("保存成功");
				dlg.close();
			}
			aly.refreshAll();
			cleanSideBoard();
			divTableControl.changeChoosedDiv(currDiv);
			return false;
		},
		changeOneSysParam:function(pname, value, pfSkipRefreshReports){
			if(pfSkipRefreshReports == null) pfSkipRefreshReports = false;
			for(var k = 0; k < aly.sysparams.length; k++){
				if(aly.sysparams[k].name == pname){
					if(aly.sysparams[k].value == value) return true;
					aly.sysparams[k].value = value;
					refreshInvokedParams(pname,value);
					if(!pfSkipRefreshReports) aly.refreshAll();
					cleanSideBoard();
					divTableControl.changeChoosedDiv(currDiv);
					editorValueChange(pname,value,true);
					return true;
				}
			}
			alert("没找到参数："+pname);
			return false;
		},
		del:function(e){
			$(e).parent().parent().remove();
		},
		getValueFromSysParams: function(name){
			var initparams = aly.sysparams;
			if(initparams != null && initparams.length > 0){
				for(var j = 0; j < initparams.length; j++){
					if(initparams[j].name == name) return initparams[j].value;
				}
			}
		}
	}
}

function refreshDsSysparams(pname, value){
	for(var r = 0; r < rqAnalyse.dataSets.length; r++){
		var ds = rqAnalyse.dataSets[r];
		if(ds.params){
			for(var p = 0; p < ds.params.length; p++) {
				var csp = ds.params[p].chooseSp;
				if(pname == csp) ds.params[p].values = value;
			}
		}
	}
}

function refreshRpxsSysparams(pname, value){
	for(var r = 0; r < rqAnalyse.rpxs.length; r++){
		var rpx = rqAnalyse.rpxs[r];
		if(rpx.where.conf.length > 0){
			for(var p = 0; p < rpx.where.conf.length; p++) {
				var csp = rpx.where.conf[p].chooseSp;
				if(pname == csp) rpx.where.conf[p].values = value;
			}
		}
	}
}

function refreshInvokedParams(pname,val){
	refreshDsSysparams(pname,val);
	refreshRpxsSysparams(pname,val);
}

function addSysParam(jsonData, skipDelBtn){
	var tr = $('<tr class="sysParamsTr"></tr>');
	$('#sys_p_content').append(tr);
	tr.append('<td><input type="text" class="sp_name"/></td>');
	tr.append('<td><input type="text" class="sp_value"/></td>');
	var select1td = $('<td></td>');
	var select1 = $('<select style="width:125px" class="sp_type" ></select>');
	select1td.append(select1);
	/*select1.append('<option value=1>整数</option>');
	select1.append('<option value=2>长整数</option>');
	select1.append('<option value=3>短整数</option>');
	select1.append('<option value=4>大整数</option>');
	select1.append('<option value=5>浮点数</option>');
	select1.append('<option value=6>双精度数</option>');
	select1.append('<option value=7>数值</option>');*/
	select1.append('<option value=8>日期</option>');
	/*select1.append('<option value=9>时间</option>');*/
	select1.append('<option value=10>日期时间</option>');
	select1.append('<option value=11 selected>字符串</option>');
	/*select1.append('<option value=12>布尔值</option>');
	select1.append('<option value=51>整数组</option>');
	select1.append('<option value=52>长整数组</option>');
	select1.append('<option value=53>短整数组</option>');
	select1.append('<option value=54>大整数组</option>');
	select1.append('<option value=55>浮点数组</option>');
	select1.append('<option value=56>双精度数组</option>');
	select1.append('<option value=57>数值组</option>');
	select1.append('<option value=58>日期组</option>');
	select1.append('<option value=59>时间组</option>');
	select1.append('<option value=60>日期时间组</option>');
	select1.append('<option value=61>字符串组</option>');
	select1.append('<option value=62>二进制</option>');
	select1.append('<option value=0>默认</option>');
	select1.append('<option value=102>自动增长</option>');
	select1.append('<option value=27>大文本</option>');*/
	tr.append(select1td);
	if( skipDelBtn ) tr.append('<td></td>');
	else tr.append('<td><a class="sp_del" onclick="javascript:delSysparam(this);">删除</a></td>');
	if(jsonData != null){
		tr.find('.sp_name').val(jsonData.name);
		tr.find('.sp_value').val(jsonData.value);
		tr.find('.sp_type').val(jsonData.type);
		tr.attr('id',jsonData.name);
	}
}

function delSysparam(e){
	sysparams.del(e);
}

function changeSysParamName(old_pname,new_pname){
	var eareas = getEditorAreas(old_pname);
	for(var i = 0; i < eareas.length; i++){
		if(eareas[i].editor.pname != old_pname) continue;
		//area里的pname
		eareas[i].editor.pname = new_pname;
		//页面上控件的pname
		$('#'+eareas[i].inDivCell).find('.pname').html(new_pname);
	}
	
	var pf = paramFormLayout.currLayout;//getParamFormArea();
	if(pf == null) return;
	for(var i = 0 ; i < pf.length; i++){
		var ps = pf[i];
		if(ps.editor.pname != old_pname) continue;
		//area里的pname
		var parea = getParamFormArea();
		for(var j = 0; j < parea.paramForm.length; j++){
			var param = parea.paramForm[j];
			if(param.pname == old_pname){
				param.pname = new_pname;
				break;
			}
		}
		//elayout里的pname
		ps.editor.pname = new_pname;
		//页面上控件的pname
		$('#singleArea'+parea.id).find('#'+old_pname).attr('id',new_pname).find('.pname').html(new_pname);
		
		for(var k = 0; k < rqAnalyse.dataSets.length; k++){
			var w = rqAnalyse.dataSets[k].params;
			for(var m = 0; m < w.length; m++){
				if(w[m].chooseSp == old_pname) {
					w[m].chooseSp = new_pname;
				}
			}
		}
		
		for(var l = 0; l < rqAnalyse.rpxs.length; l++){
			var w = rqAnalyse.rpxs[l].where.conf;
			for(var n = 0; n < w.length; n++){
				if(w[n].chooseSp == old_pname) {
					w[n].chooseSp = new_pname;
				}
			}
		}
	}
}

function test(){
}

function useParamFormDialog(){
	var params = "";
	var usingInParamForm = "";
	if(aly.sysparams != null && aly.sysparams.length > 0){
		for(var i = 0; i < aly.sysparams.length; i++){
			var param = aly.sysparams[i];
			params += param.name;
			if(i < aly.sysparams.length - 1) params += ',';
		}
	}
	var divId = $('.divCell[type=2]').attr('id');
	var area = controlUtil.getAreaByInDivCell(divId);
	var formParams = area.paramForm;
	if(formParams == null || formParams.length == 0){
		alert('参数表单中至少需要一个控件');
		return;
	}
	for(var j = 0; j < formParams.length; j++){
		usingInParamForm += formParams[j].pname;
		if(j < formParams.length - 1) usingInParamForm += ',';
	}
	if(params.length == 0) params = '-';
	if(usingInParamForm.length == 0) usingInParamForm = '-';
	layui.use('layer', function(){
		layer.open({
			title: '参数表单布局'
			,type:2
			,content: './paramForm.jsp?params='+params+'&using='+usingInParamForm+'&status='+(paramFormLayout.useParamForm == true ? '1':'0')
			+"&rowCount="+paramFormLayout.rowCount
			+"&curr="+encodeURIComponent(JSON.stringify(paramFormLayout.currLayout))
			+'&hasSubmitButton='+(paramFormLayout.hasSubmitButton == true ? '1':'0')
			,anim: 2 
			,area:['100%','300px']
		});
	});
}

function dump(a){
	try{
		e = d1.o1;
	}catch(e){
		if(a)console.log(a);
		console.log('dump');
		console.log(e);
	}
}

function getTime(){
	sleep(1);
	return new Date().getTime();
}

function changeMainWidthHeight(v1,v2){
	if(v1) $('.main').css('height',v1+'px');
	if(v2) $('.main').css('width',v2+'px');
}

function getMainWidth(){
	parseInt($('.main').css('width'));
}

function getMainHeight(){
	parseInt($('.main').css('height'));
}

var sysparams = sysparams();

function changeLayout(r,c){
//	if(!confirm('新建布局会清空当前布局报表，是否继续？')){
//		return;
//	}
	//rqAnalyse.rpxs = [];
	if(r*c < rqAnalyse.rpxs.length) {
		alert('新建布局格数小于当前报表数！');
		return;
	}
	aly.cache.reports = [];
	$('#contents').html('');
	controlUtil.area = [];
	//var l = {divInfos:{cols:c,rows:r},mergeCellIds:[],areas:[]};
	diyR = r;
	diyC = c;
	guideConf.openDOlap = "new";
	divTableControl.divInfos.divs = [];
	countArea = 0;
	dbdInit();
	cleanSideBoard();
	diyR=0;
	diyC=0;
}

function diyLayout(){
	var dlg = art.dialog({
		id : dialogCount++,
		title : '自定义布局',
	    content: '<table id="diyLayout"></table>'
	    ,ok : function() {
	    	changeLayout($('#diyLayout').find('#diyrow').val(),$('#diyLayout').find('#diycol').val());
	    }
	    ,okVal : resources.guide.js20
	    ,cancelVal : resources.guide.js21
	    ,lock : true
	    ,duration : 0
	    ,width : '330px'
		,height : '150px'
		,opacity : 0.1
		,padding : '2px 2px'
		,zIndex : 41000
	});
	var tr1 = $("<tr><td><input id=diyrow type=text /></td><td>行</td></tr>");
	var tr2 = $("<tr><td><input id=diycol type=text /></td><td>列</td></tr>");
	$('#diyLayout').append(tr1);
	$('#diyLayout').append(tr2);
}

function isChoosed(div){
	return div.className.indexOf('choosedDiv') >= 0;
}

function dealDisplayOfLongStr(d, width){
	if(d.clientWidth > width) $(d).html($(d).html().substring(0,10)+"......");
}


function toEditor(areaid,api){
	var area = $("#"+areaid);
	area.find('.toEditor').hide();
	area.find('.reportWhere').hide();
	area.find('.toReport').show();
	area.attr('type','1');
	divTableControl.changeChoosedDiv(currDiv);
	var areaObj = controlUtil.getAreaCount(areaid);
	areaObj.type = "1";
	area.find('.barReportName').hide();
	area.find('.barEditorTitle').show();
	try{
		var oldHrefMethod = area.find('.reportRemove')[0].href;
		area.find('.reportRemove')[0].href=oldHrefMethod.replace('removeReport','removeEditor');
	}catch(e){}
	removeReport($(area).find('iframe').attr('confname'),true);
	if(!api) areaObj.editor = {};
	
}

function toReport(areaid){
	var area = $("#"+areaid);
	area.find('.toEditor').show();
	area.find('.reportWhere').show();
	area.find('.toReport').hide();
	area.attr('type','0');
	divTableControl.changeChoosedDiv(currDiv);
	var areaObj = controlUtil.getAreaCount(areaid);
	areaObj.type = "0";
	area.find('.barReportName').show();
	area.find('.barEditorTitle').hide();
	var oldHrefMethod = area.find('.reportRemove')[0].href;
	area.find('.reportRemove')[0].href=oldHrefMethod.replace('removeEditor','removeReport');
	removeEditorDom(areaid);
}

function removeEditorDom(areaid){
	var area = $("#"+areaid);
	area.find('.editor_o').remove();
	var areaObj = controlUtil.getAreaCount(areaid);
	areaObj.editor = null;
}

function initEditors(){
	var hasParamFormLayout = $('.singleArea[type=2]').length > 0;
	if(hasParamFormLayout) {
		refreshParamForm();
	}
	else {
		initParamFormCells();
	}
	var areas = controlUtil.areas;
	for(var i = 0 ; i < areas.length; i++){
		var area = areas[i];
		if(area.type != "1" && area.type != "3") continue;
		if(area.type == "1" && area.editor == null) continue;
		var ps = [];
		if(area.type == "1"){
			var p1 = {
					"type" : area.editor.type,
					"pname" : area.editor.pname,
					"parent" : $('#singleArea'+area.id),
					"form" : null,
					"formData" : area.editor.data
			};
			ps.push(p1);
		}else if(area.type == "3" && area.paramForm != null && !hasParamFormLayout){
			for(var j = 0 ; j < area.paramForm.length; j++){
				var pfp = area.paramForm[j];
				var p2 = {
						"type" : pfp.type,
						"pname" : pfp.pname,
						"parent" : $('#singleArea'+area.id),
						"form" : null,
						"formData" : pfp.data
				};
				ps.push(p2);
			}
		}
		for(var k = 0 ; k < ps.length; k++){
			if(!ps[k].pname) continue;
			createEditor( ps[k], area.type == "3", true );
		}
	}
}

function showSysparams(){
	sysparams.getSysparams();
}

function go(id,type,createDiv){
	if(gridsterNotExsit) refreshGS();
	if(createDiv == null) createDiv = true;
	$('#currGenEditorForm').remove();
	$('.dbd-west-part').not('#dbd-west-report').hide();//report块的隐藏在下面
	try{
		if(id == "report"){
			//animate_(true,'slideInUp','slideOutDown',$('#dbd-west-report'),'flex');
			propertiesOps.show(type);
			animate_(true,null,null ,$('#dbd-west-report'),'');
		}else {
			//animate_(false,'slideOutDown','slideInUp',$('#dbd-west-report'));
			propertiesOps.show(id);
			animate_(false, null, null,$('#dbd-west-report'));
			$('#dbd-west-'+id).show();
		}
	}catch(e){}//预览视图中不考虑此
	$('#editor_list').show();
	if(id == "report"){
		selectReportType(type);
		if(createDiv) createTypedDiv(setDivWidth,setLiHeight*setDivHeight+(setLiHeight-1)*10,type);
	}else if(id == "editor"){
		if(createDiv) createTypedDiv(setDivWidth,setLiHeight*setDivHeight+(setLiHeight-1)*10,"editor");
	}else if(id == "paramFormTop"){
		if($('.singleArea[type=2]').length > 0) return;
		if(createDiv) createTypedDiv(setDivWidth,setLiHeight*setDivHeight+(setLiHeight-1)*10,"paramFormTop");
		initParamFormCells();
	}else if(id == "top"){
		$("#selectDs").val('');
		$('.choosedDiv').removeClass('choosedDiv');
		currDiv = null;
	}
	
	var scrollToTop = $(currDiv).parent().parent().css('top');
	console.log(scrollToTop);
	setTimeout(function(){
		$('.gridster').parent()[0].scrollTop = parseInt(scrollToTop);
	},500);
}

function selectReportType(id){
	if(id == 'choose') {
		createRpxType = 2;
		$('.allReportStyles').show();
		$('.gridTable').hide();
	} else {
		createRpxType = 1;
		$('.allReportStyles').hide();
		$('.gridTable').show();
	}
	$("#selectDs").attr('disabled',false);
}

function createDivWithoutArea(height, pf, divId, widgetHeight,widgetWidth,widgetRow,widgetCol){
	divId = divId == null ? ("o_"+( pf ? "pf" : countArea)) : divId ;
	var outerDiv = $('<div class="divbox animated fadeInUp box"></div>');
	var outerLi = $('<li></li>');
	outerLi.append(outerDiv);
	//end
	
	var div = $('<div class="divCell box-inner"></div>');
	div.css('height',height).attr('id',divId);
	outerDiv.append(div);
	/*if(pos > 0 && $('.divbox').length >= pos){
		outerDiv.insertBefore($($('.divbox')[pos-1]));
	}else{
		$('#contents').append(outerLi);
	}*/
	$('#contents').append(outerLi);
	gridster.add_widget( outerLi, widgetWidth, widgetHeight,widgetCol,widgetRow);
	
	
	return divId;
}

function createDiv(height,pos,type,name,currAreaId,pf, divId,widgetHeight,widgetWidth,widgetRow,widgetCol){
	//if($('#o_pf').length > 0 && pos > 0) pos++;
	if(widgetHeight == null) widgetHeight = setLiHeight;
	if(widgetRow == null) widgetRow = 100;
	if(widgetCol == null) widgetCol = 1;
	if(widgetWidth == null) widgetWidth = setDivWidth;
	if(height == null) height = setDivHeight;
	
	divId = createDivWithoutArea(height,pf, divId,widgetHeight,widgetWidth,widgetRow,widgetCol);
	var areaObj = arealizeDiv(divId,countArea,pos,type,name,currAreaId);
	areaObj.height = height;
	areaObj.widgetHeight = widgetHeight;
	areaObj.widgetWidth = widgetWidth;
	areaObj.widgetCol = widgetCol;
	areaObj.widgetRow = widgetRow;
	
	if(type == "blank")  areaObj.type = "-1";
	else if(type == "define") areaObj.type = "0";
	else if(type == "editor") areaObj.type = "1";
	else if(type == "choose") areaObj.type = "2";
	else if(type == "paramFormTop") areaObj.type = "3";
	
	setTimeout(function(){
		redefineFrameHeight(areaObj.report, height);
	},2000)
	return $('#'+divId);
}

function arealizeDiv(divId,c,pos,type,name,currAreaId){
	if(!type) type = -1;
	var areaId = addAreaIntoDivCell(divId,currAreaId,pos);
	var addedDivName = "新组件"+c;//count 可能重名
	if(type == "paramFormTop") addedDivName = "参数表单";
	if(name != null) {
		addedDivName = name;//一般打开文件使用
	}else{
		addedDivName = guaranteeName(addedDivName);
	}
	addReportToArea(addedDivName, $('#'+areaId)[0],type);
	return controlUtil.getAreaByInDivCell(divId);
}

function createTypedDiv(spanNum,height,type,name,currAreaId, divId,widgetHeight,widgetWidth,widgetRow,widgetCol){
	var div = createTypedDivNoChangeChoosedDiv(spanNum,height,type,name,currAreaId, divId,widgetHeight,widgetWidth,widgetRow,widgetCol);
	if(!finalView && !previewDbd) divTableControl.changeChoosedDiv(div[0]);
}

function createTypedDivNoChangeChoosedDiv(spanNum,height,type,name,currAreaId, divId,widgetHeight,widgetWidth,widgetRow,widgetCol){
	var div = createDiv(spanNum,height,type,name,currAreaId,type == "paramFormTop", divId,widgetHeight,widgetWidth,widgetRow,widgetCol);
	if( type == "editor" ){
		div.attr("type","1");
		div.find('.singleArea').attr("type","1");
	}else if( type == "paramFormTop" ){
		div.attr("type","2");
		div.find('.singleArea').attr("type","2");
	}else if( type == "define" ){
		div.attr("type","0");
		div.find('.singleArea').attr("type","0");
		div.attr("rt","1");
	}else if( type == "choose" ){
		div.attr("type","0");
		div.find('.singleArea').attr("type","0");
		div.attr("rt","2");
	}else if( type == "blank" ){
		div.attr("type","-1");
		if(finalView || previewDbd) div.css('visibility','hidden');
	}
	return div;
}

function createBlank(){
	var div = null;
	if(diyDivSize) div = createDiv(setDivWidth,setDivHeight,setDivPos,'blank');
	else div = createDiv(1,'35px',0,'blank');
	divTableControl.changeChoosedDiv(div[0]);
}


function isEditor(div){
	return $(div).find('.singleArea').attr('type') == "1";
}

function isBlank(div){
	return $(div).find('.singleArea').attr('type') == null;
}

function isParamFormTop(div){
	return $(div).find('.singleArea').attr('type') == "2";
}

function guaranteeName(n){
	if(controlUtil.getAreaByReport(n) == null) return n;
	else return guaranteeName(n+"_");
}

function countAreaAddOne(){
	countArea++;
}

function setCountArea(v){
	countArea = v;
}

function contains(arr, value){
	  var index = $.inArray(value,arr);
	    if(index >= 0){
	        return true;
	    }
	    return false;
}