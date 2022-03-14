var dbdStyles = {//默认值与最后dbd展现为准
	//hideTitle:false,//false
	//reportDivColor:null,//rgb(255, 255, 255)
	//reportDivImage:null,
	//reportDivBorderColor:null,//rgb(238, 238, 238)
	//reportDivBorderWidth:null//1
	mainColor:null,//rgb(255, 255, 255)
	mainImage:null
}

var defaultColorM = 'rgb(255, 255, 255)';
var defaultColorR = 'rgb(255, 255, 255)';
var defaultColorB = 'rgb(238, 238, 238)';

//单个报表块的样式示例
/*var reportStyle = [
{name: "标题", backColor: -1641217, color: -16777216},
{name: "分组", backColor: -1641217, color: -16777216},
{name: "指标1", backColor: -1, color: -16777216},
{name: "指标2", backColor: -853778, color: -16777216}
]*/

//样式生成器：设置标题、指标两块即可，并命名保存。报表选择配置好的样式，记录样式命名。生成报表时映射样式用在dqlApi_d2.js  3623 func4


function createListImage(type){
	var clazz = null;
	if(type == null){
		return;
	}
	else if(type == 0) {
		clazz = "pageImageSelect";
	}else if(type == 1) {
		clazz = "reportImageSelect";
	}else if(type == 2) {
		clazz = "editorImageSelect";
	}
	//$('.'+clazz).remove();
	$('#'+clazz+'Out').children().remove();
	$.ajax({
		data:{},
		type:'post',
		url:contextPath+'/DLServletAjax?action=2&oper=dbdStyleImageList',
		success:function(data){
			console.log(data);
			if(data.length == 0) return;
			
			
			
			var imageArr = eval(data);
			var currValue = "";
			var imageSelect = $('<select></select>');
			imageSelect.append('<option value="">从列表选择</option>');
			for (var i=0; i<imageArr.length; i++) {
				imageSelect.append('<option value="'+imageArr[i]+'">'+imageArr[i]+'</option>');
				imageSelect.val(currValue);
			}
			//if (currValue && currValue != '') dom.val(currValue);
			imageSelect.addClass(clazz);
			$('#'+clazz+'Out').append('<div class="label">选择背景图</div>');
			$('#'+clazz+'Out').append(imageSelect);
			bindPageImageSelect(imageSelect, type);
		}
	});
}

//切换选择div时候改变其值
function initListImage(type,v){
	var clazz = null;
	if(type == null){
		return;
	}
	else if(type == 0) {
		clazz = "pageImageSelect";
	}else if(type == 1) {
		clazz = "reportImageSelect";
	}else if(type == 2) {
		clazz = "editorImageSelect";
	}
	var imageSelect = $('.'+clazz);
	imageSelect.val(v);
}

function bindPageImageSelect(imageSelectDom, type){
	if(imageSelectDom == null) return;
	else imageSelectDom = $(imageSelectDom);
	
	if(type == 0) {
		imageSelectDom.on('change',function(e){
			var imageName = imageSelectDom.val();
			if(imageName == "" || imageName == null) {
				dbdStyles.mainImage = null;
			} else{
				var resultPath = contextPath+guideConf.dbdImageFileFolderOnServer+imageName;
				dbdStyles.mainImage = resultPath;
			}
			initMainStyle(dbdStyles);
		});
	}else if(type == 1 || type == 2) {
		imageSelectDom.on('change',function(e){
			var imageName = imageSelectDom.val();
			if(imageName == "" || imageName == null) {
				getAreaDbdStyle(controlUtil.getCurrAreaJsonObj()).reportDivImage = null;
			} else{
				var resultPath = contextPath+guideConf.dbdImageFileFolderOnServer+imageName;
				getAreaDbdStyle(controlUtil.getCurrAreaJsonObj()).reportDivImage = resultPath;
			}
			refreshReportStyle(controlUtil.getCurrAreaJsonObj());
		});
	}
	
}

function chooseImage(type){
	//上传路径暂定为静态文件路径WEB-INF\files\dbdStyleImage\
	var uploadDbdStyleImage = $('#uploadDbdStyleImage');
	if(uploadDbdStyleImage == null || uploadDbdStyleImage.length == 0){
		uploadDbdStyleImage = $('<form enctype="multipart/form-data" target=hiddenFrame id="uploadDbdStyleImage" style="display:none" action=""></form>');
		var chooseFile = $('<input accept=".png,.jpg,.bmp,.gif" type="file" name="file"/>')
		uploadDbdStyleImage.append(chooseFile);
		chooseFile.change(function(){
			//默认上传到../img/dbdStyleImage/并返回文件名
			var fakeFile = uploadDbdStyleImage[0].file.value;
			var sep = '/';
			if(fakeFile.indexOf('\\')>-1){
				sep = '\\';
			}
			var pathSecs = fakeFile.split(sep);
			fakeFile = pathSecs[pathSecs.length-1];
			if(fakeFile == '') return;
			$.ajax({
				data:{filename:fakeFile,action:2,oper:'existDbdStyleImage'},
				url:contextPath+'/DLServletAjax',
				method:'post',
				success:function(result){
					if(result.indexOf('error') > -1){
						alert('错误:'+result);
						chooseFile.val('');
						return;
					}
					if(result == "1"){
						if(!confirm('存在同名文件【'+fakeFile+'】，是否替换？')){
							alert('已取消上传！');
							if(confirm('是否应用服务器上的文件【'+fakeFile+'】？')){
								var resultPath = contextPath+guideConf.dbdImageFileFolderOnServer+imageName+fakeFile;
								if(uploadDbdStyleImage.attr('upType') == 0){
									dbdStyles.mainImage = resultPath;
									initMainStyle(dbdStyles);
								}else{
									getAreaDbdStyle(controlUtil.getCurrAreaJsonObj()).reportDivImage = resultPath;
									refreshReportStyle(controlUtil.getCurrAreaJsonObj());
								}
							}
							chooseFile.val('');
							return;
						}
					}
					var formData = new FormData(uploadDbdStyleImage[0]);
					$.ajax({
						data:formData,
						type:'post',
						url:contextPath+'/DLServletAjax?action=2&oper=uploadDbdStyleImage',
						async: false,  
				        cache: false,  
				        contentType: false,  
				        processData: false,  
						success:function(callbackstr){
							if(callbackstr.indexOf("error") >= 0){
								alert("上传失败："+callbackstr);
								return;
							}
							var resultPath = contextPath+guideConf.dbdImageFileFolderOnServer+fakeFile;
							if(uploadDbdStyleImage.attr('upType') == 0){
								dbdStyles.mainImage = resultPath;
								initMainStyle(dbdStyles);
								createListImage(0);
							}else{
								getAreaDbdStyle(controlUtil.getCurrAreaJsonObj()).reportDivImage = resultPath;
								refreshReportStyle(controlUtil.getCurrAreaJsonObj());
								createListImage(1);
								createListImage(2);
							}
							chooseFile.val('');
						}
					});
				}
			});
		});
		$('html').append(uploadDbdStyleImage);
	}
	uploadDbdStyleImage.attr('upType',type);
	
	
	//uploadDbdStyleImage.find('input[name=file]').click();
	var a=document.createEvent("MouseEvents");
	a.initEvent("click", true, true);  
	uploadDbdStyleImage.find('input[name=file]')[0].dispatchEvent(a);
}

function defaultBG(type){
	if(type == 0){
		dbdStyles.mainColor = null;
		dbdStyles.mainImage = null;
		resetPageBg($('#page_bg'));
	}else{
		getAreaDbdStyle(controlUtil.getCurrAreaJsonObj()).reportDivColor = null;
		getAreaDbdStyle(controlUtil.getCurrAreaJsonObj()).reportDivImage = null;
	}
	refreshReportStyle(controlUtil.getCurrAreaJsonObj());
	initMainStyle(dbdStyles);
	$('.main').css('background-color','');
}

function getAreaDbdStyle(area){
	if(area.dbdStyle == null) area.dbdStyle = {};
	return area.dbdStyle;
}

function switchShowTitle(){
	var cd = getAreaDbdStyle(controlUtil.getCurrAreaJsonObj());
	cd.hideTitle = !cd.hideTitle;
	changeCheckMarkStatus(cd.hideTitle,'.hideTitle')
}

function showBorderBoard(dom){
	if(dom == null){
		return;
	}
	dom.off();
	dom.on('change', function (event) {
		getAreaDbdStyle(controlUtil.getCurrAreaJsonObj()).reportDivBorderWidth = event.target.value;
		refreshReportStyle(controlUtil.getCurrAreaJsonObj());
	});
	$('.colorExample').css('background-color', getAreaDbdStyle(controlUtil.getCurrAreaJsonObj()).reportDivBorderColor != null ? getAreaDbdStyle(controlUtil.getCurrAreaJsonObj()).reportDivBorderColor : defaultColorB);
	dom.val(getAreaDbdStyle(controlUtil.getCurrAreaJsonObj()).reportDivBorderWidth);
}

function showColorBoard(type, dom){
	if(dom == null) {
		var dlg = art.dialog({
			id : "colorpicker"+type,
			title : '选择颜色-'+type == 0 ? '主体' : type == 1 ? '报表' : '边框' ,
		    content: '<input id="cb" type="text" value="" autocomplete="off"/><br/><span id="color"></span>'
		});
	}
	var defaultColor = 'rgb(255, 255, 255)';
	if(type == 0){
		defaultColor = dbdStyles.mainColor != null ? dbdStyles.mainColor : defaultColorM;
	}else if(type == 1){
		defaultColor = getAreaDbdStyle(controlUtil.getCurrAreaJsonObj()).reportDivColor != null ? getAreaDbdStyle(controlUtil.getCurrAreaJsonObj()).reportDivColor : defaultColorR;
	}else if(type == 2){
		defaultColor = getAreaDbdStyle(controlUtil.getCurrAreaJsonObj()).reportDivBorderColor != null ? getAreaDbdStyle(controlUtil.getCurrAreaJsonObj()).reportDivBorderColor : defaultColorB;
	}
	if(dom == null) dom = $('#cb');
	dom.val(defaultColor);
	dom.attr('cbtype',type).colorpicker({
		color:dom.val()
	});
	dom.on('blur', function (event) {
		pageBgColorChange(dom, event.target.value);
    });
}

function checkMB(c){
	$('.checkMark'+c).show();
}

function uncheckMB(c){
	$('.checkMark'+c).hide();
}

//选择div时候修改选项勾选和灰显状态
//dashboard.js引用
function refreshReportStyleOptions(area){
	/*if(area == null){
		$('#reportStyleLi').hide();
		$('#leftReportStyleLi').hide();
		$('.reportSettingsMenuTop').css('color','rgb(160,160,160)');
		return;
	}
	$('#reportStyleLi')[0].style.display="";
	$('.reportSettingsMenuTop').css('color','black');*/
	var dbdStyle = getAreaDbdStyle(area);
	changeCheckMarkStatus(dbdStyle.hideTitle,'.hideTitle');
}

function changeCheckMarkStatus(b,c){
	if(b) checkMB(c);
	else uncheckMB(c);
}

//2020.11.19 e传入的是areas集合
function initAreaStyle(areas){
	for(var i = 0; i < areas.length; i++){
		refreshReportStyle(areas[i]);
	}
}

function initStyle(e){
	if( e != null ) dbdStyles = e;
	initMainStyle(dbdStyles);
	initAreaStyle(controlUtil.areas);
}

function initMainStyle(dbdStyles){
	if(dbdStyles == null) dbdStyles = {};
	if(dbdStyles.mainColor != null) $('.main').css('background-color',dbdStyles.mainColor);
	else {
		if(previewDbd || finalView) $('.main').css('background-color','white');
	}
	if(dbdStyles.mainImage != null)
		$('.main').css('background-image',null).css('background-image','url(\''+dbdStyles.mainImage+'\')').css("background-size","auto");
	else 
		$('.main').css('background-image','');
	
	pageBgColorChangeEnd($('#page_bg'), dbdStyles.mainColor)
}

function pageBgColorChange(dom, color){
	console.log('-----'+color+'------');
	 dom.css('background-color', color);
    $('.colorExample').css('background-color', color);
    $("#color").text(color);
    if(dom.attr('cbtype') == 0){
		dbdStyles.mainColor = color;
		initMainStyle(dbdStyles);
	}else if(dom.attr('cbtype') == 1){
		getAreaDbdStyle(controlUtil.getCurrAreaJsonObj()).reportDivColor = color;
	}else if(dom.attr('cbtype') == 2){
		getAreaDbdStyle(controlUtil.getCurrAreaJsonObj()).reportDivBorderColor = color;
	}
    refreshReportStyle(controlUtil.getCurrAreaJsonObj());
}

function pageBgColorChangeEnd(dom, color){
	dom.css('background-color', color);
	dom.val(color);
    $('.colorExample').css('background-color', color);
    $("#color").html(color);
    if(dom.attr('cbtype') == 0){
		dbdStyles.mainColor = color;
	}else if(dom.attr('cbtype') == 1){
		getAreaDbdStyle(controlUtil.getCurrAreaJsonObj()).reportDivColor = color;
	}else if(dom.attr('cbtype') == 2){
		getAreaDbdStyle(controlUtil.getCurrAreaJsonObj()).reportDivBorderColor = color;
	}
    refreshReportStyle(controlUtil.getCurrAreaJsonObj());
}


//渲染单个div
function refreshReportStyle(area){
	if(area == null) return;
	var jdiv = $('#'+area.inDivCell).find('.singleArea');
	var dbdStyle = area.dbdStyle;
	if(dbdStyle.reportDivColor) jdiv.children('iframe').css('background-color',dbdStyle.reportDivColor);
	else jdiv.children('iframe').css('background-color','');
	if(dbdStyle.reportDivBorderWidth) jdiv.parent('div').parent('div').css('border-width',dbdStyle.reportDivBorderWidth+"px");
	else jdiv.parent('div').parent('div').css('border-width',1+"px");
	
	if(dbdStyle.reportDivBorderWidth == 0){
		jdiv.parent('div').parent('div').removeClass('box-inner');
	}else{
		jdiv.parent('div').parent('div').addClass('box-inner');
	}
	try{
		if(dbdStyle.reportDivBorderColor) jdiv.parent('div').parent('div').css('border-color',dbdStyle.reportDivBorderColor);
		else jdiv.parent('div').parent('div').css('border-color','');
	}catch(e){console.log(e);}
	
	if(dbdStyle.reportDivImage)
		jdiv.find('iframe').css('background-image',null).css('background-image','url(\''+dbdStyle.reportDivImage+'\')').css("background-size","auto");
	else
		jdiv.find('iframe').css('background-image','');
	if((finalView || previewDbd) && dbdStyle.hideTitle){
		jdiv.find('.rmbar').hide();
	}
}

function resetPageBg(dom){
	//$('.main').css('background-color','');
	dom.css('background-color', "");
	$('#color').html(defaultColorM);
	dbdStyles.mainColor=defaultColorM;
}

