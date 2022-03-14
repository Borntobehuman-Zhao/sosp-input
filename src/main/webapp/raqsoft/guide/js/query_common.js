
var dsInputFilesChange = function dsInputFilesChange(){
	$.ajax({
		url:contextPath + "/DLServletAjax?d="+new Date().getTime(),
		type:'POST',
		data:{action:2,srcFiles:$('#inputFiles').val(),oper:'getInputTableNames'},
		success:function(data){
			if(data == null || data.indexOf('[') != 0) {
				alert('未发现数据集中有任何表名称');
				alert(data);
				return;  
			}
			var j = [];
			try{
				j = eval(data);
			}catch(e){console.log(data);}
			if($('#selDom_insideFileTable').length != 0) {
				$('#selDom_insideFileTable').remove();
				$('#selDom_insideFileTable_label').remove();
			}
			add_SelDom_insideFileTable(j);//getSelectDom(j,j,j != null && j.length > 0? j[0]:null);
			//selDom_insideFileTable.attr('id','selDom_insideFileTable');
			//$('#inputFile').append('<label id="selDom_insideFileTable_label">&nbsp;填报文件中的表：</label>').append(selDom_insideFileTable);
		}
	});
}

function add_SelDom_insideFileTable(j){
	var selDom_insideFileTable = getSelectDom(j,j,j != null && j.length > 0? j[0]:null);
	selDom_insideFileTable.attr('id','selDom_insideFileTable');
	$('#inputFile').append('<label id="selDom_insideFileTable_label">&nbsp;填报文件中的表：</label>').append(selDom_insideFileTable);
}