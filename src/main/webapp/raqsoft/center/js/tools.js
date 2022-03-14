/**
 * 
 */
var ua = navigator.userAgent;
var bannedChars = ['<','>',';','"'];
function tool_closeFrameLayer(frame,saveItemId){
	var index = $("#"+saveItemId).val();
	var frameWin = top.document.getElementById(frame).contentWindow;
	frameWin.layer.close(index);
}

function tool_cancelLayerFrameJump(frameId,url){
	if(ua.toLowerCase().indexOf("mobile") >= 0){
		
	}
	window.location = url;
}

function tool_bindCharCheck(elm, b){
	//var bans = b == null ? ['<','>',';','\"'] : b;
	var bans = bannedChars;
	var ta = "以下字符被禁止:";
	for(var i = 0; i < bans.length; i++){
		ta += bans[i] + " ";
	}
	var t = $(elm).attr("title");
	$(elm).attr("title", (t == null ? "" : (t +",") )+ta);
	var l = $(elm).length;
	$(elm).bind('keyup',function(e){
		var v = e.target.value;
		for(var j = 0; j < bans.length; j++){
			if(v.indexOf(bans[j]) >= 0){
				v = removeCharForElm(e.target, v, bans[j]);
			}
		}
	});
	$(elm).change(function(e){
		var v = e.target.value;
		for(var j = 0; j < bans.length; j++){
			if(v.indexOf(bans[j]) >= 0){
				v = removeCharForElm(e.target, v, bans[j]);
			}
		}
	});
}

function removeCharForElm(elm, v, b){
	v = v.replace(eval("/"+b+"/g"),"");
	$(elm).val(v);
	return v;
}

function invalidChar(v){
	var exp = '/[';
	for(var c = 0; c < bannedChars.length; c++){
		exp += bannedChars[c];
	}
	exp += ']/gm'
	var reg = eval(exp);
	return reg.test(v)
}


function contains(arr, value){
	  var index = $.inArray(value,arr);
	    if(index >= 0){
	        return true;
	    }
	    return false;
}

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
	};