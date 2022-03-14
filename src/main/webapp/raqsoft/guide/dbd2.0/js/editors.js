//dbd2.0 update
var editor_global_data = {
	dealPicker: function(v){
		$('.pickerOn').hide();
		$('.pickerOff').show();
		if(this.picker == null) {
			return;
		}
		v = e_trim(v);
		editorValueChange(this.picker,v);
		this.picker = null;
	}
};

var paramFormLayout = {
	rowCount : 5,
	currLayout : [],
	useParamForm : true,
	hasSubmitButton : false//显示与否
};

function e_trim(v){
	v = v.trim(v);
	v = v.replace("<br/>","");
	v = v.replace("<br>","");
	return v;
}

function initAddEditorButtons(){
	var ebs = $('.addEditorButton');
	for(var i = 0; i < ebs.length; i++){
		var ebi = ebs[i];
		$(ebi).click(showForm);
	}
}

function addEditorToCurrDiv(e){
	var carea = $(currDiv).find('.singleArea');
	var form = $('#currGenEditorForm')[0];
	var type = form.type.value;
	var pname = form.pname.value;
	var p1 = {
		"type" : type,
		"pname" : pname,
		"parent" : carea,
		"form" : form,
		"formData" : null
	}
	createEditor(p1,carea.attr('type') == '2', false);
}

var showForm = function showCreateEditorForm(e){
	$('#currGenEditorForm').remove();
	$('#editor_list').hide();
	var type = $(e.target).attr('type');
	
	var fo = $('<form id="currGenEditorForm" class="form-horizontal"></form>');
	var fs = $('<div><div class="propSubTitle">制作参数组件</div></div>');
	fs.append('<div><div id="editorFsLegend" class="btn-group"></div></div>');
	fo.append(fs);
	var extra = $('<input class="btn btn-primary" onclick="sysparams.addOneParam();" type="button" value="增加参数"/>');
	fo.find('#editorFsLegend').append(extra);
	var s = $('<select class="sformInput" name="pname" id="sysparamsSelector"></select>');
	var formGroup = createBootstrapFormGroupDiv('关联共享参数',s,null,3,6);
	fs.append(formGroup);
	createSysParamsSelector(s);
	var options = types[type];
	options.showForm(fs,type);
	$('#dbd-west-editor-detail').append(fo);
}

function createBootstrapFormGroupDiv(label,input,extra,size1,size2){
	var formgroup = $('<div class="form-group"></div>');
	var label = $('<label class="control-label2">'+label+'</label>');
	formgroup.append(label);
	var inputItemContainer = $('<div class="w80"></div>');
	formgroup.append(inputItemContainer);
	inputItemContainer.append(input);
	if(extra) var ex = $(extra);
	formgroup.append(extra);
	return formgroup;
}

function getCurrParamFormLayoutCellIndex(paramName){
	for(var i = 0; i < paramFormLayout.currLayout.length; i++){
		if(paramFormLayout.currLayout[i].editor.pname == paramName){
			return i;
		}
	}
}

function createEditor(p1, isParamForm, openParamForm, paramFormCell){
	if(isParamForm && (previewDbd || finalView) && !paramFormLayout.useParamForm){
		return;
	}
	var type, pname, parent, form;
	type = p1.type;
	pname = p1.pname;
	parent = p1.parent;
	form = p1.form;
	if(form == null){
		form = p1.formData;
	}
	if(!pname || pname == '') {
		flash($('.sformInput'),4);
		return '';
	}
	if(isParamForm && type == "slider"){
		alert('参数表单尚未支持滑块');
		return;
	}
	
	if(checkHasEditor(currDiv) && !isParamForm){
		if(!confirm("会清除已有的控件")) return;
	}else if(parent.find('#'+pname).length > 0 && isParamForm){
		if(!confirm("会替换表单内同名的控件")) return;
	}
	var pfChangedCellId = null;
	if(!isParamForm) {removeEditorDom(parent.attr('id'));}
	else {
		if(parent.find('#'+pname).length > 0){
			parent.find('#'+pname).html('');
			var lIndex = getCurrParamFormLayoutCellIndex(pname);
			pfChangedCellId = paramFormLayout.currLayout[lIndex].cell;
			paramFormLayout.currLayout = paramFormLayout.currLayout.deleteIndex(lIndex);
		}
	}
	
	var areaid = parent.attr('id');
	var areaObj = controlUtil.getAreaCount(areaid);
	
	if(isParamForm && areaObj.paramForm == null) areaObj.paramForm = [];
	
	var options = types[type];
	var div = null;
	if(!isParamForm){
		div = $('<div style="text-align:center;" class="editor_o dontchoose" id="'+pname+'"></div>');
		parent.append(div);
	}
	else {
		if(pfChangedCellId != null) div = pfChangedCellId;
		if(paramFormCell != null) div = paramFormCell;
		else {
			var paramFormCells = parent.find('.paramFormCell');
			for(var k = 0; k < paramFormCells.length; k++){
				//在参数表单第一个空格中加控件
				if($(paramFormCells[k]).children() == null || $(paramFormCells[k]).children().length == 0){
					div = $(paramFormCells[k]);
					break;
				}
			}
		}
	}
	$(div).attr('id',pname);
	var data = options.prepareData(form);
	appendEditor(options,pname,div,form, data, isParamForm);
	preventPropagation(parent,'.editor_o','click');
	if(!isParamForm){
		areaObj.editor = {
			"pname" : pname,
			"type" : type,
			"data" : data
		};
	}else {
		var row_col = div.attr('pos');
		row_col = row_col.split('_');
		var tempEditor = {
				"pname" : pname,
				"type" : type,
				"data" : data
		};
		var paramCell = {editor: tempEditor, cell: row_col[0]+"_"+row_col[1]};
		if(!openParamForm){//打开文件createEditor的时候并不需要把参数表单再向area添加一遍
			var index = paramFormContain(areaObj.paramForm, pname);
			if(index >= 0){
				areaObj.paramForm = areaObj.paramForm.deleteIndex(index);
			}
			if(pname != "submit_button") paramFormLayout.currLayout.push(paramCell);
		}
		areaObj.paramForm.push(tempEditor);//按添加先后顺序
	}
	$('#currGenEditorForm').html('');
}

function paramFormContain(list, pname){
	for(var i = 0 ; i < list.length; i++){
		if(pname == list[i].pname){
			return i;
		}
	}
	return -1;
}

function createSysParamsSelector(s){
	if(!aly.sysparams || aly.sysparams.length == 0) {
		s.append('<option value="">需要共享参数</option>');
		s.attr('title',"需要共享参数");
		return;
	}
	for (var i=0; i<aly.sysparams.length; i++) {
		var pname = aly.sysparams[i].name;
		var opt = $('<option value="'+pname+'">'+pname+'</option>');
		s.append(opt);
	}
}

function appendEditor(options,pname,parent,form,data,inParamForm){
	var v = sysparams.getValueFromSysParams(pname);
	options.append(parent,pname,v,data,inParamForm);
	divTableControl.changeChoosedDiv(currDiv)
}

function checkHasEditor(currDiv){
	var parent = $(currDiv).find('.singleArea');
	return parent.find('.editor_o').length > 0;
}

function checkHasEditor2(area){
	return area.find('.editor_o').length > 0;
}


function editorValueChange(pname, v, forceonce, pfSkipRefreshReports){
	if(forceonce){
		changeEditorValueWithSamePname(pname,v);
	}else if(!sysparams.changeOneSysParam(pname,v,pfSkipRefreshReports)){
		changeEditorValueWithSamePname(pname,v);
	}
	//sysparams.changeOneSysParam(pname,v)返回true/false false的时候值已经一致不再change
}

function changeEditorValueWithSamePname(pname,v){
	for(var i = 0; i < controlUtil.areas.length; i++){
		var areaObj = controlUtil.areas[i];
		if(areaObj.type != "1" && areaObj.type != "3") continue;
		else if((areaObj.type == "3" && (areaObj.paramForm == null || areaObj.paramForm.length == 0)) && (areaObj.type == "1" && (areaObj.editor == null || areaObj.editor.pname != pname))) continue;
		if(areaObj.type == "1") {
			var options = types[areaObj.editor.type];
			options.changeValue(areaObj,v);
		}else{
			if(areaObj.paramForm == null) return;
			for(var j = 0; j < areaObj.paramForm.length; j++){
				var param = areaObj.paramForm[j];
				if(param.pname == pname){
					var options = types[param.type];
					options.changeParamFormEditorValue(areaObj,v,pname);
					break;
				}
			}
		}
	}
}

function createPicker(td,pname){
	var imgOn = $('<img class="pickerOn" style="width:16px;display:none" src="../img/guide/dashboard/picker.png"/>');
	var imgOff = $('<img class="pickerOff" style="width:16px" src="../img/guide/dashboard/picker_off.png"/>');
	$(td).append(imgOff);
	$(td).append(imgOn);
	$(imgOff).css('cursor',"pointer");
	$(imgOn).css('cursor',"pointer");
	$(imgOff).click(function(e){
		//开启提取
		editor_global_data.picker = $(e.target).parents('div.editor_o').find('.pname').html();
		imgOn.show();
		imgOff.hide();
		var frames = $('iframe');
		for(var i = 0; i < frames.length; i++){
			$($('iframe')[i].contentDocument).find('html').css('cursor','copy');
		}
	});
	$(imgOn).click(function(){
		editor_global_data.picker = null;
		imgOff.show();
		imgOn.hide();
		var frames = $('iframe');
		for(var i = 0; i < frames.length; i++){
			$($('iframe')[i].contentDocument).find('html').css('cursor','auto');
		}
	});
}

function showEditorButton(n){
	if($('#collapse'+n).hasClass('in')){
		$('#collapse'+n).removeClass('in');
		return;
	}
	$('.leftNavCollapse').removeClass('in');
	$('#collapse'+n).addClass('in');
}

$(function(){
	easyuiapi.extend(easyuiapi.fn.validatebox.defaults.rules, {
	    min_max:{
	    	validator: function(value, param){
	    		var min = param[0];
	    		var max = param[1];
	    		return value >= min && value <= max;
			},
			message: '不在范围内  {0}：{1}'
	    }
	});
	initAddEditorButtons();
});

function initParamFormCells(){
	var hasParamForm = $('.singleArea[type=2]').length == 1;
	if(hasParamForm){
		//发现initParamForm后调用
		var parent = $($('.singleArea[type=2]')[0]);
		var i = 0;
		while(i < paramFormLayout.rowCount){
			var row = addParamFormRow(parent, i);
			addParamFormCell(row, i);
			i++;
		}
	}
}


function addParamFormRow(parent, count){
	var div = $('<div class="row-fluid pfrow row_'+count+'"></div>');
	parent.append(div);
	return div;
}

function addParamFormCell(row, rowCount){
	for(var j = 0; j < 6; j++){
		var div = $('<div class="editor_o dontchoose paramFormCell" id="" pos="'+rowCount+'_'+j+'"></div>');
		row.append(div);
		div.addClass('col-md-2');
	}
}

function refreshParamForm(){
	$('.singleArea[type=2]').find('.pfrow').remove();
	initParamFormCells();
	controlUtil.getAreaCount($('.singleArea[type=2]').attr('id')).paramForm = [];
	for(var j = 0; j < paramFormLayout.currLayout.length; j++){
		var pfp = paramFormLayout.currLayout[j].editor;
		var p2 = {
				"type" : pfp.type,
				"pname" : pfp.pname,
				"parent" : $('.singleArea[type=2]'),
				"form" : null,
				"formData" : pfp.data
		};
		var id = paramFormLayout.currLayout[j].cell;
		var pfcell = $('.paramFormCell[pos='+id+']');
		if( pfp.type == "submit_button" && (previewDbd || finalView) && !paramFormLayout.hasSubmitButton) continue;
		createEditor( p2, true, true, pfcell );
	}
}

function getEditorAreas(filter){
	var result = [];
	if(filter != null && typeof filter == 'string'){
		filter = {name: filter};
	}
	for(var i = 0 ; i < controlUtil.areas.length; i++){
		var area = controlUtil.areas[i];
		if(area.type == "1" && area.editor != null) {
			if(filter == null
				|| (filter != null && filter.name == area.editor.pname) )
			{
				result.push(area);
			}
		}	
	}
	return result;
}
	
function getParamFormArea(){
	for(var i = 0 ; i < controlUtil.areas.length; i++){
		var area = controlUtil.areas[i];
		if(area.type == "3" && area.paramForm != null) {
			return area;
		}
	}
	return null;
}

function parseEasyui(parent){
	easyuiapi(function(){
		easyuiapi.parser.parse(parent);
	});
}

function addPfSubmitButton(){
	var p2 = {
			"type" : "submit_button",
			"pname" : "submit_button",
			"parent" : $('.singleArea[type=2]'),
			"form" : null,
			"formData" : {value : "查询"}
	};
	createEditor( p2, true, false );
}


function pfsubmit(){
	for(var i = 0; i < paramFormLayout.currLayout.length; i++){
		var pname = paramFormLayout.currLayout[i].editor.pname;
		if(paramFormLayout.currLayout[i].editor.type.indexOf('button') >= 0) continue;
		var pf = $('.singleArea[type=2]');
		var eds = pf.find('.editor[id='+pname+']');
		var v = eds.val();
		editorValueChange(pname,v, false, true);
	}
	 aly.refreshAll();
}

function isParamFormFinalViewAndHasSubmit(){
	var containSubmitButton = false;
	for(var i = 0; i < paramFormLayout.currLayout.length; i++){
		if(paramFormLayout.currLayout[i].editor.pname == "submit_button"){
			containSubmitButton = true;
			break;
		}
	}
	if(containSubmitButton){
		containSubmitButton = paramFormLayout.hasSubmitButton;//有但是隐藏了是false
	}else{
		//没有是false
	}
	return (previewDbd || finalView) && containSubmitButton;
}

//changeValue避免使用onchange，防止反复调用
var types = {
	"input":{
		append:function(parent,pname,v,data, inParamForm){
			var table = $('<table class="editor_o" style="display:inline-block;"></table>');
			parent.append(table);
			var tr1 = $('<tr></tr>');
			table.append(tr1);//.append(tr2);
			tr1.append('<td class="pname">'+pname+'</td><td></td><td></td><td></td>');
			var input1 = $('<input id="'+pname+'" name="val" class="editor_text editor" type="text" value="'+v+'"/>');
			$(tr1.find('td')[1]).append(input1);
			createPicker(tr1.find('td')[2],pname);
			//var btn1 = $('<input type="button" class=".btn" value="更改"/>');
			var btn1 = $('<img width="100%" height="100%" class="btn1" src="../../img/guide/17.png" title="刷新"/>');
			$(tr1.find('td')[3]).append(btn1);
			parseEasyui(parent);
			btn1.click(function(e){
				var n = $(e.target).parents('div.editor_o').find('.pname').html();
				editorValueChange(n,input1.val());
			});
			if(inParamForm && isParamFormFinalViewAndHasSubmit()){
				btn1.hide();
			}
		},
		prepareData:function(){
			return null;
		},
		showForm:function(parent,type){
			parent.append('<input type="hidden" name="type" value="'+type+'"/>');
			parent.find('#editorFsLegend').append('<input type="button" class="btn btn-success" onclick="addEditorToCurrDiv(this);" value="确认"/>');
		},
		changeValue:function(areaObj,v){
			var edom = $('#singleArea'+areaObj.id).find('.editor');
			edom.val(v);
		},
		changeParamFormEditorValue:function(areaObj,v,pname){
			var edom = $('#singleArea'+areaObj.id).find('#'+pname).find('.editor');
			edom.val(v);
		}
	}
	,"slider":{
		append:function(parent,pname,v,data,inParamForm){
			//data.rule=['1','10','20']
			var table = $('<table class="editor_o" style="display:inline-block;"></table>');
			parent.append(table);
			var tr1 = $('<tr style="height:15px"></tr>');
			var tr2 = $('<tr></tr>');
			//var tr3 = $('<tr></tr>');
			table.append(tr1).append(tr2);//.append(tr3);
			tr2.append('<td class="pname">'+pname+'</td><td></td><td></td><td></td>');
			createPicker(tr2.find('td')[2],pname);
			var input1 = $('<input id="'+pname+'" class="easyui-slider editor" value="'+v+'" style="width:'+(data.width_param?data.width_param:"200")+'px" data-options="showTip:true,rule:'+data.rule+',step:'+data.step+',max:'+data.max+',min:'+data.min+
					',onSlideEnd:function(v){editorValueChange(\''+pname+'\',v+\'\');}">');
			$(tr2.find('td')[1]).append(input1);
			parseEasyui(parent)
		},
		prepareData:function(form1){
			var data = {
				rule:"",
			};
			//打开文件时候用form1.min
			var min = form1.min.value ? form1.min.value :(form1.min ? form1.min: 0);
			var max = form1.max.value ? form1.max.value :(form1.max ? form1.max: 100);
			var step = form1.step.value ? form1.step.value :(form1.step ? form1.step: 1);
			var tipStep = form1.tipStep.value ? form1.tipStep.value :(form1.tipStep ? form1.tipStep: 10);
			var width_param = form1.width_param.value ? form1.width_param.value :(form1.width_param ? form1.width_param: 10);
			data.rule += "[";
			data.rule += '\''+min+'\'';
			var i = parseInt(min)+parseInt(tipStep);
			while(i < parseInt(max)){
				data.rule += ',\''+i+'\'';
				i += parseInt(tipStep);
			}
			data.rule += ',\''+max+'\'';
			data.rule += "]";
			data.min = min;
			data.max = max;
			data.step = step;
			data.tipStep = tipStep;
			data.width_param = width_param;
			return data;
		},
		showForm:function(parent,type){
			var max = 100;
			var min = 0;
			var tipStep = 10;
			var step = 1;
			var width_param = "200";
			parent.append('<input type="hidden" name="type" value="'+type+'"/>');
			var formGroup1 = createBootstrapFormGroupDiv('最小值',
					'<input class="sform form-control" type="text" name="min" value="'+min+'"/>',null,3,6);
			parent.append(formGroup1);
			var formGroup2 = createBootstrapFormGroupDiv('最大值',
					'<input class="sform form-control" type="text" name="max" value="'+max+'"/>',null,3,6);
			parent.append(formGroup2);
			var formGroup3 = createBootstrapFormGroupDiv('滑动间隔值',
					'<input class="sform form-control" type="text" name="step" value="'+step+'"/>',null,3,6);
			parent.append(formGroup3);
			var formGroup4 = createBootstrapFormGroupDiv('显示间隔值',
					'<input class="sform form-control" type="text" name="tipStep" value="'+tipStep+'"/>',null,3,6);
			parent.append(formGroup4);
			var formGroup5 = createBootstrapFormGroupDiv('宽度[像素]',
					'<input class="sform form-control" type="text" name="width_param" value="'+width_param+'"/>',null,3,6);
			parent.append(formGroup5);
			parent.find('#editorFsLegend').append('<input type="button" class="btn btn-success" onclick="addEditorToCurrDiv(this);" value="确认"/>');
		},
		changeValue:function(areaObj,v){
			var edom = $('#singleArea'+areaObj.id).find('.editor');
			easyuiapi(edom[0]).slider('setValues',v);
		},
		changeParamFormEditorValue:function(areaObj,v,pname){
			var edom = $('#singleArea'+areaObj.id).find('#'+pname).find('.editor');
			easyuiapi(edom).slider('setValues',v);
		}
	},
	"spinner":{
		append:function(parent,pname,v,data, inParamForm){
			var table = $('<table class="editor_o" style="display:inline-block;"></table>');
			parent.append(table);
			var tr1 = $('<tr></tr>');
			table.append(tr1);//.append(tr2);
			tr1.append('<td class="pname">'+pname+'</td><td></td><td></td><td></td>');
			var input1 = $('<input id="'+pname+'" class="editor" style="width:100px;">');
			$(tr1.find('td')[1]).append(input1);
			createPicker(tr1.find('td')[2],pname);
			//var btn1 = $('<input type="button" class=".btn" value="更改"/>');
			var btn1 = $('<img class="btn1" src="../../img/guide/17.png" title="刷新"/>');
			$(tr1.find('td')[3]).append(btn1);
			easyuiapi(input1).spinner({
				value:v,
			    required:false,
			    increment:data.increment,
			    max:data.max,
			    min:data.min,
			    onSpinUp:function(){
			    	var spinner = easyuiapi(input1);
			    	spinner.spinner("setValue",parseInt(spinner.spinner("getValue"))+parseInt(data.increment));
			    },
			    onSpinDown:function(){
			    	var spinner = easyuiapi(input1);
			    	spinner.spinner("setValue",parseInt(spinner.spinner("getValue"))-parseInt(data.increment));
			    },
			    validType:['min_max['+data.min+','+data.max+']']
			});
			parseEasyui(parent)
			btn1.click(function(e){
				var n = $(e.target).parents('div.editor_o').find('.pname').html();
				editorValueChange(n,$(e.target).parents('div.editor_o').find('.textbox-text').val());
			});
			if(inParamForm && isParamFormFinalViewAndHasSubmit()){
				btn1.hide();
			}
		},
		prepareData:function(form1){
			var data = {
				rule:"",
			};
			//打开文件时候用form1.min
			var min = form1.min.value ? form1.min.value :(form1.min ? form1.min: 0);
			var max = form1.max.value ? form1.max.value :(form1.max ? form1.max: 100);
			var increment = form1.increment.value ? form1.increment.value :(form1.increment ? form1.increment: 1);
			data.min = min;
			data.max = max;
			data.increment = increment;
			return data;
		},
		showForm:function(parent,type){
			var max = 100;
			var min = 0;
			var increment = 1;
			parent.append('<input type="hidden" name="type" value="'+type+'"/>');
			var formGroup1 = createBootstrapFormGroupDiv('增量值',
					'<input class="sform form-control" type="text" name="increment" value="'+increment+'"/>',null,3,6);
			parent.append(formGroup1);
			var formGroup2 = createBootstrapFormGroupDiv('警示最小值',
					'<input class="sform form-control" type="text" name="min" value="'+min+'"/>',null,3,6);
			parent.append(formGroup2);
			var formGroup3 = createBootstrapFormGroupDiv('警示最大值',
					'<input class="sform form-control" type="text" name="max" value="'+max+'"/>',null,3,6);
			parent.append(formGroup3);
			parent.find('#editorFsLegend').append('<input type="button" class="btn btn-success" onclick="addEditorToCurrDiv(this);" value="确认"/>');
		},
		changeValue:function(areaObj,v){
			var edom = $('#singleArea'+areaObj.id).find('.editor');
			easyuiapi(edom[0]).spinner('setValue',v);
		},
		changeParamFormEditorValue:function(areaObj,v,pname){
			var edom = $('#singleArea'+areaObj.id).find('#'+pname).find('.editor');
			easyuiapi(edom).spinner('setValue',v);
			//edom.val(v);
		}
	},
	"date":{
		append:function(parent,pname,v,data, inParamForm){
			var table = $('<table class="editor_o" style="display:inline-block;"></table>');
			parent.append(table);
			var tr1 = $('<tr></tr>');
			table.append(tr1);
			tr1.append('<td class="pname">'+pname+'</td><td></td><td></td><td></td>');
			var input1 = $('<input id="'+pname+'" class="editor" style="width:100px;">');
			$(tr1.find('td')[1]).append(input1);
			createPicker(tr1.find('td')[2],pname);
//			var btn1 = $('<input type="button" class=".btn" value="更改"/>');
//			$(tr1.find('td')[3]).append(btn1);
			var easyuiOptions = {
				    value: v,
				    required: false,
				    showSeconds: true,
				    
				    formatter:function(date){
						var y = date.getFullYear();
						var m = date.getMonth()+1;
						var d = date.getDate();
						return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
					}
				    ,parser:function(s){
						if (!s) return new Date();
						var ss = (s.split('-'));
						var y = parseInt(ss[0],10);
						var m = parseInt(ss[1],10);
						var d = parseInt(ss[2],10);
						if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
							return new Date(y,m-1,d);
						} else {
							return new Date();
						}
					}
				}
			if(inParamForm && isParamFormFinalViewAndHasSubmit()){
			}else{
				easyuiOptions.onSelect = function(newValue){
			    	var y = newValue.getFullYear();
					var m = newValue.getMonth()+1;
					var d = newValue.getDate();
					newValue = y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
			    	editorValueChange(pname,newValue);
			    }
			}
			easyuiapi(input1).datebox(easyuiOptions);
			parseEasyui(parent)
		},
		prepareData:function(form1){
			return null;
		},
		showForm:function(parent,type){
			parent.append('<input type="hidden" name="type" value="'+type+'"/>');
			parent.find('#editorFsLegend').append('<input type="button" class="btn btn-success" onclick="addEditorToCurrDiv(this);" value="确认"/>');
		},
		changeValue:function(areaObj,v){
			var edom = $('#singleArea'+areaObj.id).find('.editor');
			easyuiapi(edom[0]).datebox('setValue',v);
		},
		changeParamFormEditorValue:function(areaObj,v,pname){
			var edom = $('#singleArea'+areaObj.id).find('#'+pname).find('.editor');
			easyuiapi(edom).datebox('setValue',v);
		}
	},
	"datetime":{
		append:function(parent,pname,v,data, inParamForm){
			var table = $('<table class="editor_o" style="display:inline-block;"></table>');
			parent.append(table);
			var tr1 = $('<tr></tr>');
			table.append(tr1);
			tr1.append('<td class="pname">'+pname+'</td><td></td><td></td><td></td>');
			var input1 = $('<input id="'+pname+'" class="editor" style="width:100px;">');
			$(tr1.find('td')[1]).append(input1);
			createPicker(tr1.find('td')[2],pname);
			var btn1 = $('<img class="btn1" src="../../img/guide/17.png" title="刷新"/>');
			$(tr1.find('td')[3]).append(btn1);
			var easyuiOptions = {
				    value: v,
				    required: false,
				    showSeconds: true,
				    
				    formatter:function(date){
						console.log(date);
						var y = date.getFullYear();
						var M = date.getMonth()+1;
						var d = date.getDate();
						var h = date.getHours();
						var mm = date.getMinutes();
						var s = date.getSeconds();
						
						return y+'-'+(M<10?('0'+M):M)+'-'+(d<10?('0'+d):d)+" "+(h<10?('0'+h):h)+":"+(mm<10?('0'+mm):mm)+":"+(s<10?('0'+s):s);
					}
				    ,parser:function(s){
						if (!s) return new Date();
						var ss_top = (s.split(' '));
						if(ss_top.length == 1 || ss_top[1].length == 0){
							var ss = (ss_top[0].split('-'));
							var y = parseInt(ss[0],10);
							var m = parseInt(ss[1],10);
							var d = parseInt(ss[2],10);
							if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
								return new Date(y,m-1,d);
							} else {
								return new Date();
							}	
						}
						
						var date_top = ss_top[0];
						
						var time_top = ss_top[1];
						
						var ss = (date_top.split('-'));
						var y = parseInt(ss[0],10);
						var m = parseInt(ss[1],10);
						var d = parseInt(ss[2],10);
						
						var ss2 = (time_top.split(':'));
						var hours = parseInt(ss2[0],10);
						var minutes = parseInt(ss2[1],10);
						var seconds = parseInt(ss2[2],10);
						
						if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
							return new Date(y,m-1,d,hours,minutes,seconds);
						} else {
							return new Date();
						}
					}
				}
			/*if(inParamForm && isParamFormFinalViewAndHasSubmit()){
			}else{
				easyuiOptions.onSelect = function(newValue){
			    	var y = newValue.getFullYear();
					var M = newValue.getMonth()+1;
					var d = newValue.getDate();
					var h = newValue.getHours();
					var mm = newValue.getMinutes();
					var s = newValue.getSeconds();
					console.log(h);
					newValue = y+'-'+(M<10?('0'+M):M)+'-'+(d<10?('0'+d):d)+" "+(h<10?('0'+h):h)+":"+(mm<10?('0'+mm):mm)+":"+(s<10?('0'+s):s);
			    	editorValueChange(pname,newValue);
			    };
			}*/
			easyuiapi(input1).datetimebox(easyuiOptions);
			btn1.click(function(e){
				var n = $(e.target).parents('div.editor_o').find('.pname').html();
				editorValueChange(n,$(e.target).parents('div.editor_o').find('.textbox-text').val());
			});
			parseEasyui(parent)
		},
		prepareData:function(form1){
			return null;
		},
		showForm:function(parent,type){
			parent.append('<input type="hidden" name="type" value="'+type+'"/>');
			parent.find('#editorFsLegend').append('<input type="button" class="btn btn-success" onclick="addEditorToCurrDiv(this);" value="确认"/>');
		},
		changeValue:function(areaObj,v){
			var edom = $('#singleArea'+areaObj.id).find('.editor');
			easyuiapi(edom[0]).datetimebox('setValue',v);
		},
		changeParamFormEditorValue:function(areaObj,v,pname){
			var edom = $('#singleArea'+areaObj.id).find('#'+pname).find('.editor');
			easyuiapi(edom).datetimebox('setValue',v);
		}
	},
	"downdrawer":{
		append:function(parent,pname,v,data, inParamForm){
			//data.ds data.field 查询该数据集此字段数据和总数量，根据数量多少让用户决定是否生成由此数据集组成的下拉框作为参数
			var ds = aly.getDataSet(data.ds);
			var requestData = {};
			
			if(ds.type == "6" || ds.type == "7"){
				requestData = {action:2,oper:'ddwQuery',calcFieldTypeJSON:null,dataSource:ds.dataSource,dqlField:data.field}
			}else{
				requestData = {action:2,oper:'ddwDfxCalc',calcFieldTypeJSON:null,dataSource:ds.dataSource,dqlField:data.field,dataId:ds.dataId,dataFileType:guideConf.dataFileType,reportId:"where"};
			}
			$.ajax({
				url:contextPath + "/DLServlet?d="+new Date().getTime(),
				data:requestData,
				type:'post',
				success:function(d){
					var dd = d.split('|||');
					var count = dd[0];
					var queriedData = JSON.parse(dd[1]);
					var table = $('<table class="editor_o" style="display:inline-block;"></table>');
					parent.append(table);
					var tr1 = $('<tr></tr>');
					table.append(tr1);//.append(tr2);
					tr1.append('<td class="pname">'+pname+'</td><td></td><td></td><td></td>');
					var input1 = $('<select id="'+pname+'" class="editor" style="width:100px;"></select>');
					$(tr1.find('td')[1]).append(input1);
					createPicker(tr1.find('td')[2],pname);
//					var btn1 = $('<input type="button" class=".btn" value="更改"/>');
//					$(tr1.find('td')[3]).append(btn1);
					var easyuiOptions = {
						value: v,
					   
					    valueField: 'v',
					    textField: 'd',
					    data: queriedData
					}
					if(inParamForm && isParamFormFinalViewAndHasSubmit()){
					}else{
						easyuiOptions.onSelect = function(record){
						    editorValueChange(pname,record.v);
						}
					}
					easyuiapi(input1).combobox(easyuiOptions);
					parseEasyui(parent)
				}
			});
		},
		prepareData:function(form1){
			var data = {};
			data.ds = form1.ds.value ? form1.ds.value :(form1.ds ? form1.ds: null);
			data.field = form1.field.value ? form1.field.value :(form1.field ? form1.field: null);
			return data;
		},
		showForm:function(parent,type){
			parent.append('<input type="hidden" name="type" value="'+type+'"/>');
			var editorDsSelecter = $('<select name="ds" class="sformInput form-control" id="editorDsSelecter" style=""></select>');
			var formGroup1 = createBootstrapFormGroupDiv('数据集',
					editorDsSelecter,null,3,6);
			parent.append(formGroup1);
			var formGroup2 = createBootstrapFormGroupDiv('字段',
					'<select name="field" class="sformInput form-control" id="editorFieldSelecter" style="display:none"></select>',null,3,6);
			parent.append(formGroup2);
			editorDsSelecter.append('<option value="">选择数据集</option>');
			for (var i=0; i<rqAnalyse.dataSets.length; i++) {
				var dsn = rqAnalyse.dataSets[i].name;
				var opt = $('<option value="'+dsn+'">'+dsn+'</option>');
				editorDsSelecter.append(opt);
			}
			editorDsSelecter.change(function(e){
				var fields = [];
				var dsName = $(this).val();
				if(dsName == "") {
					$('#editorFieldSelecter').hide();
					$('#editorFieldSelecter').html();
					return;
				}
				else{
					$('#editorFieldSelecter').show();
				}
				var dataSet = aly.getDataSet(dsName);
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
				var fsDiv = $('#editorFieldSelecter');
				fsDiv.append('<option value="">选择字段</option>');
				for(var j = 0; j < fields.length; j++) {
					fsDiv.append('<option value="'+fields[j].disp+'">'+fields[j].disp+'</option>');
				}
			});
			parent.find('#editorFsLegend').append('<input type="button" class="btn btn-success" onclick="addEditorToCurrDiv(this);" value="确认"/>');
		},
		changeValue:function(areaObj,v){
			var edom = $('#singleArea'+areaObj.id).find('.editor');
			easyuiapi(edom[0]).combobox('setValue',v);
		},
		changeParamFormEditorValue:function(areaObj,v,pname){
			var edom = $('#singleArea'+areaObj.id).find('#'+pname).find('.editor');
			easyuiapi(edom).combobox('setValue',v);
		}
	}
	,"submit_button":{
		append:function(parent,pname,v,data){
			var table = $('<table class="editor_o"></table>');
			parent.append(table);
			var tr1 = $('<tr></tr>');
			table.append(tr1);//.append(tr2);
			tr1.append('<td></td>');
			var input1 = $('<input name="'+pname+'" class="btn btn-primary" type="button" value="'+data.value+'"/>');
			tr1.find('td').append(input1);
			input1.click(function(e){
				pfsubmit();
			});
		},
		prepareData:function(f){
			return {value:f.value};
		},
		changeValue:function(areaObj,v){
			var edom = $('#singleArea'+areaObj.id).find('.editor');
			edom.val(v);
		},
		changeParamFormEditorValue:function(areaObj,v,pname){
			var edom = $('#singleArea'+areaObj.id).find('#'+pname).find('.editor');
			edom.val(v);
		}
	}
}
