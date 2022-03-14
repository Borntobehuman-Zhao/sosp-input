var entered = false;
var reportEditorShowed = false;
function bindWestEvent(){
	$('#dbd-west-report').mouseleave(function(){
		entered = false;
		reportEditorShowed = false;
		setTimeout(function(){
			if(entered) return;
			animate_(true,'slideOutDown','slideInUp',$('#dbd-west-report'),'');
			setTimeout(function(){
				$('#dbd-west-report').css("bottom","-275px");
				$('#dbd-west-report').removeClass("slideOutDown");
			},700);
		},1000);
	}).mouseenter(function(){
		entered = true;
		if($('#dbd-west-report').hasClass('slideInUp') || $('#dbd-west-report').css("bottom") == "0px") return;
		$('#dbd-west-report').css("bottom","0px");
		reportEditorShowed = true;
		//animate_(true,'slideInUp','slideOutDown',$('#dbd-west-report'),'flex');
	});
}

function delayWestEvent(){
	$('#dbd-west-report').css("bottom","0px");
	if(!reportEditorShowed){
		reportEditorShowed = true;
		setTimeout(function(){
			if(entered) return;
			reportEditorShowed = false;
			animate_(true,'slideOutDown','slideInUp',$('#dbd-west-report'),'');
			setTimeout(function(){
				$('#dbd-west-report').css("bottom","-275px");
				$('#dbd-west-report').removeClass("slideOutDown");
			},500);
			},2000);
	}
}

function activeReportMengBan(){
	for(var i = 0; i < $('.divCell').length; i++){
		div = $($('.divCell')[i]);
		if(div.find('.reportMengBan').length == 0 && div.find('.singleArea').find('iframe').length > 0)
			div.append('<div class="reportMengBan">mengban</div>');
	}
}

function closeReportMengBan(){
	$('.reportMengBan').remove();
}


function animate_(show,c,oldClass,dom,display){
	if(show){
		if(c == null && oldClass == null) {
			if(display) $(dom)[0].style.display = display;
			else $(dom).show();
			return;
		}
		$(dom).removeClass(oldClass);
		if(display) $(dom)[0].style.display = display;
		else $(dom).show();
		$(dom).addClass('animated').addClass(c);
	}else{
		if(c == null && oldClass == null) {
			$(dom).hide();
			return;
		}
		$(dom).removeClass(oldClass).addClass('animated').addClass(c);
		setTimeout(function(){
			$(dom).hide();
		},500);
	}
}

var propertiesOps = {
	show : function(title){
		this.setTitle(title);
	},
	setTitle : function(title){
		if(title == 'define'){
			title = "网格报表";
		}else if(title == 'choose'){
			title = "统计图";
		}else if(title == 'editor'){
			title = "参数控件";
		}else if(title == 'paramFormTop'){
			title = "参数表单";
		}else if(title == 'top'){
			title = "页面";
		}
		$('#propertiesTitle').html(title);
	},
	pend : function(id,type){
		$('#currGenEditorForm').remove();
		$('.dbd-west-part').not('#dbd-west-report').hide();//report块的隐藏在下面
		try{
			if(id == "report"){
				//animate_(true,'slideInUp','slideOutDown',$('#dbd-west-report'),'flex');
				this.show(type);
				animate_(true,null,null ,$('#dbd-west-report'),'');
			}else {
				//animate_(false,'slideOutDown','slideInUp',$('#dbd-west-report'));
				this.show(id);
				if(id == 'paramFormTop') id = "editor";
				animate_(false, null, null,$('#dbd-west-report'));
				$('#dbd-west-'+id).show();
			}
		}catch(e){}//预览视图中不考虑此
		$('#editor_list').show();
		if(id == "report"){
			selectReportType(type);
		}else if(id == "editor"){
		}else if(id == "paramFormTop"){
			if($('.singleArea[type=2]').length > 0) return;
			initParamFormCells();
		}else if(id == "top"){
			$("#selectDs").val('');
			$('.choosedDiv').removeClass('choosedDiv');
			currDiv = null;
		}
	}
};
