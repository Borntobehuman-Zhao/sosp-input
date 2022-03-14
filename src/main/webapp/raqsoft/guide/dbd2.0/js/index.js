var frameType = 0;

function init(){
	var baseHeight = parseInt(window.innerHeight) - 41;
	$('.side').css('background-color','gray').css('height',baseHeight+'px');
	var height = parseInt($('.side').css('width'))*1.2;
	$('.sideMenu').css('height',height+'px');
	$('.dbd-west').css('margin-left','0px');
	//toData($('.sideMenu')[0]);
	toFolder($('.sideMenu')[0]);
	var mainMarginLeft = $('#topMain').css('margin-left');
	$('#topMain').css('margin-left','0px')
		.css('height',baseHeight+'px');
	$("#logopic").css("width",(parseInt($('.side').css("width"))+30)+"px")
	.css("background-color","rgb(80, 164, 237)");
	$($("#logopic").parents("div")[0]).css("padding-left","0px");
}

function toFolder(e){
	frameType = 1;
	toPageSign(e);
	$('#mf')[0].src = "./folder.jsp";
}

function toData(e){
	//if(frameType == 2) return;
	frameType = 2;
	toPageSign(e);
	var selectedDbd = null;
	try{
		selectedDbd = getSelectedDbdFile();
	}catch(E){}
	var page = "./olaptabs.jsp";
	var parameters = "";
	if(selectedDbd != null) {
		p_olap = selectedDbd;
		parameters += "olap="+encodeURI(p_olap);
	}
	/*var parameters = "";
	parameters += "dataSource="+p_dataSource;
	if(p_view != "") parameters += "&view="+p_view;
	
	if(p_olap != "") parameters += "&olap="+p_olap;
	if(p_ql != "") parameters += "&ql="+p_ql;
	if(p_dfxFile != "") parameters += "&dfxFile="+p_dfxFile;
	if(p_dfxScript != "") parameters += "&dfxScript="+p_dfxScript;
	if(p_dfxParams != "") parameters += "&dfxParams="+p_dfxParams;
	if(p_inputFiles != "") parameters += "&inputFiles="+p_inputFiles;
	if(p_fixedTable != "") parameters += "&fixedTable="+p_fixedTable;
	if(p_dataFileType != "") parameters += "&dataFileType="+p_dataFileType;
	if(p_dct != "") parameters += "&dct="+p_dct;
	if(p_vsb != "") parameters += "&vsb="+p_vsb;
	if(p_filter != "") parameters += "&filter="+p_filter;
	if(p_macro != "") parameters += "&macro="+p_macro;*/
	window.open(page+"?" + parameters, "_blank");
}

function toPreview(e){
	if(frameType == 3) return;
	frameType = 3;
	toPageSign(e);
}

function toPageSign(iconDiv){
	return;
	$('.icon').parent().removeClass('activeSideMenu');
	$(iconDiv).addClass('activeSideMenu');
}

