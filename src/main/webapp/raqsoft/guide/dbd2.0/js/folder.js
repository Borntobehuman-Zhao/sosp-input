var serverFolder = 'WEB-INF/files/dbd';
var folderInfo = {
	currFolderId : '0',
	currFolderName : ''
}
Array.prototype.deleteIndex = function(index){
	return this.slice(0, index).concat(this.slice(parseInt(index, 10) + 1));
};

var back = new Array();
var currFolderId = '';


function goback(){
	if(back.length == 0) return;
	var lastBackInfo = back[back.length - 1];
	showFolder(folderInfo.data, lastBackInfo.currLevel, lastBackInfo.toFolderId, true);
	choosedFile = null;
	$('#cutBut').css('cursor','no-drop');
}

function findFolder(data, folderId, currLevelNum){
	var upperLevelFolders = data.folders["level"+(currLevelNum - 1)]
	for(var f = 0; f < upperLevelFolders.length; f++){
		if(upperLevelFolders[f].id == folderId){
			return upperLevelFolders[f];
		}
	}
}

function createBackArray(data, tfo, currLevelNumber){//dbd浏览返回时候，url跳转目录使用，模仿生成多层back
	//从1层开始，第2层应该有1个back
	var tback = [];
	if(tfo.id == 0) return tback;
	for(var i = currLevelNumber; i > 1 ; i--){
		tfo = findFolder(data, tfo.belong, i - 1);
		if(i == 2) tback.push({order:i - 1,toFolderId:tfo.id,currLevel:'level'+(i-1),folderName:""});
		else if(i == currLevelNumber) tback.push({order:currLevelNumber,toFolderId:tfo.id,currLevel:'level'+(i-1),folderName:tfo.name});
		else tback = tback.insert(0,{order:currLevelNumber,toFolderId:tfo.id,currLevel:'level'+(i-1),folderName:tfo.name});
	}
	return tback;
}