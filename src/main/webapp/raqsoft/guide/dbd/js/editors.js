var editor_global_data = {
	dealPicker: function(v){
		$('.pickerOn').hide();
		$('.pickerOff').show();
		if(this.picker == null) {
			return;
		}
		editorValueChange(this.picker,v);
		this.picker = null;
	}
};

function initAddEditorButtons(){
	var ebs = $('.addEditorButton');
	for(var i = 0; i < ebs.length; i++){
		var ebi = ebs[i];
		$(ebi).click(showForm);
	}
}

function addEditorToCurrDiv(e){
	var form = $('#currGenEditorForm')[0];
	var type = form.type.value;
	var pname = form.pname.value;
	var p1 = {
		"type" : type,
		"pname" : pname,
		"parent" : $(currDiv).find('.singleArea'),
		"form" : form,
		"formData" : null
	}
	createEditor(p1);
}

var showForm = function showCreateEditorForm(e){
	$('#currGenEditorForm').remove();
	$('#editor_list').hide();
	$('#editor_goTop').show();
	var type = $(e.target).attr('type');
	var fo = $('<form id="currGenEditorForm"></form>');
	fo.append('关联共享参数：');
	var s = $('<select class="sformInput" name="pname" id="sysparamsSelector"></select>');
	fo.append(s);
	createSysParamsSelector(s);
	var options = types[type];
	options.showForm(fo,type);
	$('#dbd-west-editor').append(fo);
}

function editor_goTop(){
	$('#currGenEditorForm').remove();
	$('#editor_list').show();
	$('#editor_goTop').hide();
}

function createEditor(p1){
	var type, pname, parent, form;
	type = p1.type;
	pname = p1.pname;
	parent = p1.parent;
	form = p1.form;
	if(form == null){
		form = p1.formData;
		
	}
	if(!pname || pname == '') {
		dump('qing');
		alert('请先添加共享参数');
		return '';
	}
	if(checkHasEditor(currDiv)){
		if(!confirm("会清除已有的控件")) return;
	}
	removeEditorDom(parent.attr('id'));
	var options = types[type];
	var div = $('<div class="editor_o dontchoose"></div>');
	var fo = $('<form class="editor_o '+pname+'"></form>');
	var data = options.prepareData(form);
	appendEditor(options,pname,fo,form, data);
	div.append(fo);
	parent.append(div);
//	$(function(){
//		easyuiapi.parser.parse(fo);
//	});
	preventPropagation(parent,'.editor_o','click');
	
	var areaid = parent.attr('id');
	var areaObj = controlUtil.getAreaCount(areaid);
	areaObj.editor = {
		"pname" : pname,
		"type" : type,
		"data" : data
	};
	$('#currGenEditorForm').html('');
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

function appendEditor(options,pname,parent,form,data){
	var v = sysparams.getValueFromSysParams(pname);
	options.append(parent,pname,v,data);
}

function checkHasEditor(currDiv){
	var parent = $(currDiv).find('.singleArea');
	return parent.find('.editor_o').length > 0;
}

function checkHasEditor2(area){
	return area.find('.editor_o').length > 0;
}

function isEditor(div){
	return $(div).find('.singleArea').attr('type') == "1";
}

//changeValue避免使用onchange，防止反复调用
var types = {
	"input":{
		append:function(parent,pname,v,data){
			var table = $('<table></table>');
			parent.append(table);
			var tr1 = $('<tr></tr>');
			var tr2 = $('<tr></tr>');
			table.append(tr1).append(tr2);
			tr1.append('<td>'+pname+':</td><td></td>');
			createPicker(tr1.find('td')[1],pname);
			tr2.append('<td></td><td></td>');
			var input1 = $('<input name="val" class="editor_text editor" type="text" value="'+v+'"/>');
			$(tr2.find('td')[0]).append(input1);
			var btn1 = $('<input type="button" class=".btn" value="更改"/>');
			$(tr2.find('td')[1]).append(btn1);
			parseEasyui(parent)
			btn1.click(function(){
				editorValueChange(pname,input1.val());
			});
		},
		prepareData:function(){
			return null;
		},
		showForm:function(parent,type){
			parent.append('<input type="hidden" name="type" value="'+type+'"/>');
			parent.append('<input type="button" onclick="addEditorToCurrDiv(this);" value="确认"/>');
		},
		changeValue:function(areaObj,v){
			var edom = $('#singleArea'+areaObj.id).find('.editor');
			edom.val(v);
		}
	}
	,"slider":{
		append:function(parent,pname,v,data){
			//data.rule=['1','10','20']
			var table = $('<table></table>');
			parent.append(table);
			var tr1 = $('<tr></tr>');
			var tr2 = $('<tr style="height:15px"></tr>');
			var tr3 = $('<tr></tr>');
			table.append(tr1).append(tr2).append(tr3);
			tr1.append('<td>'+pname+'</td><td></td>');
			createPicker(tr1.find('td')[1],pname);
			tr2.append('<td></td><td></td>');
			tr3.append('<td></td><td></td>');
			var input1 = $('<input class="easyui-slider editor" value="'+v+'" style="width:'+(data.width_param?data.width_param:"200")+'px" data-options="showTip:true,rule:'+data.rule+',step:'+data.step+',max:'+data.max+',min:'+data.min+
					',onSlideEnd:function(v){editorValueChange(\''+pname+'\',v+\'\');}">');
			$(tr3.find('td')[0]).append(input1);
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
			var i = parseInt(tipStep);
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
			parent.append('<br/>');
			parent.append('最小值');
			parent.append('<br/>');
			parent.append('<input class="sform" type="text" name="min" value="'+min+'"/>');
			parent.append('<br/>');
			parent.append('最大值');
			parent.append('<br/>');
			parent.append('<input class="sform" type="text" name="max" value="'+max+'"/>');
			parent.append('<br/>');
			parent.append('滑动间隔值');
			parent.append('<br/>');
			parent.append('<input class="sform" type="text" name="step" value="'+step+'"/>');
			parent.append('<br/>');
			parent.append('显示间隔值');
			parent.append('<br/>');
			parent.append('<input class="sform" type="text" name="tipStep" value="'+tipStep+'"/>');
			parent.append('<br/>');
			parent.append('宽度（像素）');
			parent.append('<br/>');
			parent.append('<input class="sform" type="text" name="width_param" value="'+width_param+'"/>');
			parent.append('<br/>');
			parent.append('<input type="button" onclick="addEditorToCurrDiv(this);" value="确认"/>');
		},
		changeValue:function(areaObj,v){
			var edom = $('#singleArea'+areaObj.id).find('.editor');
			easyuiapi(edom[0]).slider('setValues',v);
		}
	},
	"spinner":{
		append:function(parent,pname,v,data){
			var table = $('<table></table>');
			parent.append(table);
			var tr1 = $('<tr></tr>');
			var tr2 = $('<tr></tr>');
			table.append(tr1).append(tr2);
			tr1.append('<td>'+pname+':</td><td></td>');
			createPicker(tr1.find('td')[1],pname);
			tr2.append('<td></td><td></td>');
			var input1 = $('<input class="editor" style="width:100px;">');
			$(tr2.find('td')[0]).append(input1);
			var btn1 = $('<input type="button" class=".btn" value="更改"/>');
			$(tr2.find('td')[1]).append(btn1);
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
			btn1.click(function(){
				editorValueChange(pname,input1.val());
			});
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
			parent.append('<br/>');
			parent.append('增量值');
			parent.append('<br/>');
			parent.append('<input class="sform" type="text" name="increment" value="'+increment+'"/>');
			parent.append('<br/>');
			parent.append('警示最小值');
			parent.append('<br/>');
			parent.append('<input class="sform" type="text" name="min" value="'+min+'"/>');
			parent.append('<br/>');
			parent.append('警示最大值');
			parent.append('<br/>');
			parent.append('<input class="sform" type="text" name="max" value="'+max+'"/>');
			parent.append('<br/>');
			parent.append('<input type="button" onclick="addEditorToCurrDiv(this);" value="确认"/>');
		},
		changeValue:function(areaObj,v){
			var edom = $('#singleArea'+areaObj.id).find('.editor');
			easyuiapi(edom[0]).spinner('setValue',v);
		}
	},
	"datetime":{
		append:function(parent,pname,v,data){
			var table = $('<table></table>');
			parent.append(table);
			var tr1 = $('<tr></tr>');
			var tr2 = $('<tr></tr>');
			table.append(tr1).append(tr2);
			tr1.append('<td>'+pname+':</td><td></td>');
			createPicker(tr1.find('td')[1],pname);
			tr2.append('<td></td><td></td>');
			var input1 = $('<input class="editor" style="width:100px;">');
			$(tr2.find('td')[0]).append(input1);
//			var btn1 = $('<input type="button" class=".btn" value="更改"/>');
//			$(tr2.find('td')[1]).append(btn1);
			easyuiapi(input1).datetimebox({
			    value: v,
			    required: false,
			    showSeconds: true,
			    onChange:function(newValue){
			    	editorValueChange(pname,newValue);
			    },
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
			});
			parseEasyui(parent)
		},
		prepareData:function(form1){
			return null;
		},
		showForm:function(parent,type){
			parent.append('<input type="hidden" name="type" value="'+type+'"/>');
			parent.append('<input type="button" onclick="addEditorToCurrDiv(this);" value="确认"/>');
		},
		changeValue:function(areaObj,v){
			var edom = $('#singleArea'+areaObj.id).find('.editor');
			easyuiapi(edom[0]).datetimebox('setValue',v);
		}
	},
	"downdrawer":{
		append:function(parent,pname,v,data){
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
					var table = $('<table></table>');
					parent.append(table);
					var tr1 = $('<tr></tr>');
					var tr2 = $('<tr></tr>');
					table.append(tr1).append(tr2);
					tr1.append('<td>'+pname+':</td><td></td>');
					createPicker(tr1.find('td')[1],pname);
					tr2.append('<td></td><td></td>');
					var input1 = $('<select class="editor" style="width:100px;"></select>');
					$(tr2.find('td')[0]).append(input1);
//					var btn1 = $('<input type="button" class=".btn" value="更改"/>');
//					$(tr2.find('td')[1]).append(btn1);
					easyuiapi(input1).combobox({
					    value: v,
					    onChange:function(newValue){
					    	editorValueChange(pname,newValue);
					    },
					    valueField: 'v',
					    textField: 'd',
					    data: queriedData
					});
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
			var editorDsSelecter = $('<select name="ds" class="sformInput" id="editorDsSelecter" style=""></select>');
			parent.append(editorDsSelecter);
			editorDsSelecter.append('<option value="">选择数据集</option>');
			for (var i=0; i<rqAnalyse.dataSets.length; i++) {
				var dsn = rqAnalyse.dataSets[i].name;
				var opt = $('<option value="'+dsn+'">'+dsn+'</option>');
				editorDsSelecter.append(opt);
			}
			parent.append('</br>');
			parent.append('<select name="field" class="sformInput" id="editorFieldSelecter" style="display:none"></select>');
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
			parent.append('</br>');
			parent.append('<input type="button" onclick="addEditorToCurrDiv(this);" value="确认"/>');
		},
		changeValue:function(areaObj,v){
			var edom = $('#singleArea'+areaObj.id).find('.editor');
			easyuiapi(edom[0]).combobox('setValue',v);
		}
	}
}

function editorValueChange(pname,v){
	sysparams.changeOneSysParam(pname,v);
	changeEditorValueWithSamePname(pname,v);
}

function createPicker(td,pname){
	var imgOn = $('<img class="pickerOn" style="width:16px;display:none" src="../img/guide/dashboard/picker.png"/>');
	var imgOff = $('<img class="pickerOff" style="width:16px" src="../img/guide/dashboard/picker_off.png"/>');
	$(td).append(imgOff);
	$(td).append(imgOn);
	$(imgOff).css('cursor',"pointer");
	$(imgOn).css('cursor',"pointer");
	$(imgOff).click(function(){
		//开启提取
		editor_global_data.picker = pname;
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
});

function parseEasyui(parent){
	easyuiapi(function(){
		easyuiapi.parser.parse(parent);
	});
}