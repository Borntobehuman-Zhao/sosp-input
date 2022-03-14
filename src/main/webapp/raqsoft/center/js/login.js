function getVi(){
		$('#vimg').html("loading...");
		$.ajax({
			data: {action:81},
			url:vurl,
			type: "post",
			success:function(data){
				currSessionImg = data;
				var img = $('<img onclick="getVi();" src="'+src+'/center/images/tmp/'+currSessionImg+'?t='+new Date().getTime()+'" />');//data文件名
				$('#vimg').html("");
				$('#vimg').append(img);
				if(isMobile) var input = $('<input autocomplete="off" placeholder="验证码" onkeyup="vnChange(this);" type="text" name="validNum" id="validNum" class="texts" lay-verify="required"/>');
				else var input = $('<input autocomplete="off" placeholder="验证码" onkeyup="vnChange(this);" type="text" name="validNum" id="validNum" class="layui-input" lay-verify="required"/>');
				$('#vnInput').html("");
				$('#vnInput').append(input);
			}
		});
	}


function vnChange(e){
	var v = e.value;
	if(v.length == 5){
		v = v.substr(0,4);
	}
	$("#validNum").val(v);
}

function refreshCurrVimg(){
	var img = $('<img title="点击刷新" style="cursor:pointer" onclick="getVi();" src="'+src+'/center/images/tmp/'+currSessionImg+'?t='+new Date().getTime()+'" />');//sessionImg文件名
	$('#vimg').html("");
	$('#vimg').append(img);
	setTimeout(refreshCurrVimg,5000);
}

$(function(){
	if(enableValidImg){
		getVi();
		setTimeout(refreshCurrVimg,5000);
	}
});

