var countOlaps = 0;
var currentOlap = 'olap1';
var tabNames = [];
$(function(){
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
	}
	if(p_olap != null && p_olap.length > 0){
		addOlapTab(p_olap.substring(p_olap.lastIndexOf('/')+1).split('.')[0],p_olap);
		p_olap = "";
	}
	else addOlapTab();
});


function addOlapTab(name, olapPath){
	countOlaps++;
	var newTab = $('<li></li>');
	var divid = 'olap'+countOlaps;
	name = pushTabName(name);
	if(name) divid = name;
	newTab.append('<div class="olapTab navFont-default2" id="'+divid+'">'+divid+'</div>');
	$('#olapTabHref').before(newTab);
	var closeButton = $('<img class="closeButton" style="display:none" height="10px" src="../img/guide/dashboard/close_mouseout.png"/>');
	newTab.find('.olapTab').append(closeButton);
	newTab.click(function(){
		var tabdiv = newTab.find('.olapTab');
		currentOlap = tabdiv.attr('id');
		switchOlap(currentOlap);
	});
	prepare_closeBut(newTab);
	currentOlap = newTab.find('.olapTab').attr('id');
	$('#tabTop').append('<iframe class="olapTabContent" id="'+currentOlap+'_tab"></iframe>');
	switchOlap(currentOlap);
	tabToData(document.getElementById(currentOlap+"_tab"),olapPath);
	return $('#'+currentOlap+'_tab')[0];
}

function modifyOlapTab(name){
	if(name == null) return;
	deleteTabName(name);
	name = pushTabName(name);
	var tabDiv = $('#'+currentOlap);
	tabDiv.off('click');
	tabDiv.attr('id',name).html(name);
	$('#'+currentOlap+'_tab').attr('id',name+'_tab');
	currentOlap = name;
	tabDiv.click(function(){
		currentOlap = tabDiv.attr('id');
		switchOlap(currentOlap);
	});
	var closeButton = $('<img class="closeButton" style="display:none" height="10px" src="../img/guide/dashboard/close_mouseout.png"/>');
	$('#'+currentOlap).append(closeButton);
	prepare_closeBut($('#'+currentOlap))
	return $('#'+currentOlap+'_tab')[0];
}

function switchOlap(olapTabName){
	var tabdiv = $('#'+olapTabName);
	$('.olapTab').removeClass('activeOlapTab');
	tabdiv.addClass('activeOlapTab');
	$('.olapTabContent').removeClass('activeOlapTabContent').hide();
	$('#'+olapTabName+'_tab').addClass('activeOlapTabContent').show();
}

function tabToData(e,olapPath){
	var parameters = "";
	parameters += "dataSource="+p_dataSource;
	parameters += "&view="+p_view;
	if(olapPath != null) {
		p_olap = olapPath;
		parameters += "&isDbdFile=1";
	}
	parameters += "&olap="+p_olap;
	parameters += "&ql="+p_ql;
	parameters += "&dfxFile="+p_dfxFile;
	parameters += "&dfxScript="+p_dfxScript;
	parameters += "&dfxParams="+p_dfxParams;
	parameters += "&inputFiles="+p_inputFiles;
	parameters += "&fixedTable="+p_fixedTable;
	parameters += "&dataFileType="+p_dataFileType;
	parameters += "&dct="+p_dct;
	parameters += "&vsb="+p_vsb;
	parameters += "&filter="+p_filter;
	parameters += "&macro="+p_macro;
	e.src = "./"+data_jsp_name+".jsp?"+parameters;
}
//olap类型文件
function open_self(){
	$('#'+currentOlap+'_tab')[0].contentWindow.openOlap(0);
}

function open_tab(){
	$('#'+currentOlap+'_tab')[0].contentWindow.openOlap(1);
}

function open_blank(){
	$('#'+currentOlap+'_tab')[0].contentWindow.openOlap(2);
}

//其他类型文件
function open2_self(){
	$('#'+currentOlap+'_tab')[0].contentWindow.openDataFile(0);
}

function open2_tab(){
	$('#'+currentOlap+'_tab')[0].contentWindow.openDataFile(1);
}

function open2_blank(){
	$('#'+currentOlap+'_tab')[0].contentWindow.openDataFile(2);
}

function prepare_closeBut(tabdiv){
	var button = $(tabdiv).find('.closeButton');
	$(tabdiv).mouseover(function(){
		button.show();
	}).mouseout(function(){
		button.hide();
	});
	button.mouseover(function(){
		button.attr('src','../img/guide/dashboard/close.png');
	}).mouseout(function(){
		button.attr('src','../img/guide/dashboard/close_mouseout.png');
	});
	button.click(function(){
		var id = $(tabdiv).find('.olapTab').attr('id');
		if(!confirm('未保存的内容将会丢失。确认关闭标签页：'+id+'?')){
			return;
		}
		deleteTabName(id);
		var tabFrameId = id+"_tab";
		$(tabdiv).remove();
		$('#'+tabFrameId).remove();
		var tabs = $('.olapTab');
		if(tabs.length > 0){
			currentOlap = $($('.olapTab')[0]).attr('id');
			switchOlap(currentOlap);
		}else{
			countOlaps = 0;
			currentOlap = 'olap1';
			alert("页面无标签页，新建："+currentOlap);
			addOlapTab();
		}
	});
}

function pushTabName(name){
	if(name == null) return null;
	if(tabExist(name)){
		return pushTabName(name+"_")
	}
	tabNames.push(name);
	return name;
}

function deleteTabName(name){
	if(tabExist(name)){
		tabNames = tabNames.deleteValue(name);
	}
}

function tabExist(name){
	return $.inArray(name,tabNames) > -1;
}
