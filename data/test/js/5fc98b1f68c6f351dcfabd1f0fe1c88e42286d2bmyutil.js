$( init );
function init(){
	
	
	$(".add_collect").mousedown(function(){
		$(".test_coll").show();
		$(".test_zone").hide();
		setTimeout(function(){
			$(".test_coll").hide();
		},3000);
	});
}
/**
* thisTag: 触发的标签
* showTag：显示的DIV
* time:停留的时间
* 说明：我的气泡
*/
function tips(thisTag,showTag,time){
	
	$(thisTag).mousedown(function(){
		var $showTag = $(showTag);
		// 控制其它的气泡隐藏
		$(".showTagTmp").hide();
		$(".showTagTmp").removeClass(".showTagTmp");
		
		$showTag.addClass("showTagTmp");
		$showTag.show();
		
		setTimeout(function(){
			$(showTag).hide();	
		},(time-1)*1000);
	});
}

