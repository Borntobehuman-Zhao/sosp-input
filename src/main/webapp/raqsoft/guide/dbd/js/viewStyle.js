var dbdStyles = {//默认值与最后dbd展现为准
	hideTitle:false,//false
	mainColor:null,//rgb(255, 255, 255)
	mainImage:null,
	reportDivColor:null,//rgb(255, 255, 255)
	reportDivImage:null,
	reportDivBorderColor:null,//rgb(238, 238, 238)
	reportDivBorderWidth:null//1
}

var defaultColorM = 'rgb(255, 255, 255)';
var defaultColorR = 'rgb(255, 255, 255)';
var defaultColorB = 'rgb(238, 238, 238)';


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
								var resultPath = "../img/dbdStyleImage/"+fakeFile;
								if(uploadDbdStyleImage.attr('upType') == 0){
									dbdStyles.mainImage = resultPath;
								}else{
									dbdStyles.reportDivImage = resultPath;
								}
								initFileStyle();
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
							var resultPath = "../img/dbdStyleImage/"+fakeFile;
							if(uploadDbdStyleImage.attr('upType') == 0){
								dbdStyles.mainImage = resultPath;
							}else{
								dbdStyles.reportDivImage = resultPath;
							}
							chooseFile.val('');
							initFileStyle();
						}
					});
				}
			});
		});
		$('html').append(uploadDbdStyleImage);
	}
	uploadDbdStyleImage.attr('upType',type);
	uploadDbdStyleImage.find('input[name=file]').click();
}

function defaultBG(type){
	if(type == 0){
		dbdStyles.mainColor = null;
		dbdStyles.mainImage = null;
	}else{
		dbdStyles.reportDivColor = null;
		dbdStyles.reportDivImage = null;
	}
}

function switchShowTitle(){
	dbdStyles.hideTitle = !dbdStyles.hideTitle;
	changeCheckMarkStatus(dbdStyles.hideTitle,'.hideTitle')
}

function showBorderBoard(){
	var dlg = art.dialog({
		id : dialogCount++,
		title : '设置边框',
	    content: '<table>'+
	    	'<tr><td>边框颜色:</td><td><button type="button" onclick="showColorBoard(2);" class="btn btn-default">选择颜色</button><div class="colorExample"></div></td></tr>'+
	    	'<tr><td>边框宽度:</td><td><input style="width:56px" type="text" id="setBorderWidth"/></td></tr>'
	    +'</table>'
	});
	$('#setBorderWidth').on('change', function (event) {
		dbdStyles.reportDivBorderWidth = event.target.value;
		initFileStyle();
	});
	$('.colorExample').css('background-color', dbdStyles.reportDivBorderColor != null ? dbdStyles.reportDivBorderColor : defaultColorB);
	$('#setBorderWidth').val(dbdStyles.reportDivBorderWidth);
}

function showColorBoard(type){
	var dlg = art.dialog({
		id : dialogCount++,
		title : '选择颜色',
	    content: '<input id="cb" type="text" value=""/><br/><span id="color"></span>'
	});
	var defaultColor = 'rgb(255, 255, 255)';
	if(type == 0){
		defaultColor = dbdStyles.mainColor != null ? dbdStyles.mainColor : defaultColorM;
	}else if(type == 1){
		defaultColor = dbdStyles.reportDivColor != null ? dbdStyles.reportDivColor : defaultColorR;
	}else if(type == 2){
		defaultColor = dbdStyles.reportDivBorderColor != null ? dbdStyles.reportDivBorderColor : defaultColorB;
	}
	$('#cb').attr('cbtype',type).colorpicker({
		color:defaultColor
	});
	$('#cb').on('change', function (event) {
        $('#cb').css('background-color', event.color.toString()).val('');
        $('.colorExample').css('background-color', event.color.toString());
        $("#color").text(event.color.toString());
        if($('#cb').attr('cbtype') == 0){
			dbdStyles.mainColor = event.color.toString();
		}else if($('#cb').attr('cbtype') == 1){
			dbdStyles.reportDivColor = event.color.toString();
		}else if($('#cb').attr('cbtype') == 2){
			dbdStyles.reportDivBorderColor = event.color.toString();
		}
    });
}

function checkMB(c){
	$('.checkMark'+c).show();
}

function uncheckMB(c){
	$('.checkMark'+c).hide();
}

function changeCheckMarkStatus(b,c){
	if(b) checkMB(c);
	else uncheckMB(c);
}

function initFileStyle(e){
	if(e){
		dbdStyles = e;
		changeCheckMarkStatus(dbdStyles.hideTitle,'.hideTitle');
	}
	$('.divCell').css('background-color',dbdStyles.reportDivColor)
		.css('border-width',dbdStyles.reportDivBorderWidth+"px")
		.css('border-color',dbdStyles.reportDivBorderColor);
	if(dbdStyles.reportDivImage)
		$('.divCell').css('background-image',null).css('background-image','url(\''+dbdStyles.reportDivImage+'\')').css("background-size","cover");
	
	$('#contents').css('background-color',dbdStyles.mainColor);
	if(dbdStyles.mainImage)
		$('#contents').css('background-image',null).css('background-image','url(\''+dbdStyles.mainImage+'\')').css("background-size","cover");
	if(finalView && dbdStyles.hideTitle){
		$('.rmbar').hide();
	}
}

