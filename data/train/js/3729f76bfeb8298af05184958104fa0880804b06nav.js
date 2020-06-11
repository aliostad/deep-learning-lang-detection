$(function init_nav(){
	var nav = $("#nav");
	var nav_items = $(".nav-item");
	// nav_items._jq_cache = [];
	var nav_content_items = $(".nav-content-item");
	nav_content_items._jq_cache = [];
	nav_content_items.each(function(i,nav_content_item){
		nav_content_item = $(nav_content_item);
		var height = nav_content_item._cache_height = nav_content_item.height();
		var width = nav_content_item._cache_width = nav_content_item.width();
		var offset = nav_content_item._cache_offset = nav_content_item.offset();
		nav_content_item.css({height:0,minHeight:0,overflow:"hidden",display:"none",opacity:1});
		nav_content_items._jq_cache[nav_content_item.data("nav-content")] = nav_content_item;
	});
	var start_line = nav.offset().left,
		end_line = start_line+nav.width()-2;
	nav_items.each(function(i,nav_item){
		nav_item = $(nav_item);
		i = nav_item.data("nav-index");
		var nav_content_item = nav_content_items._jq_cache[i];
		if (i!==undefined&&nav_content_item) {
			var offset_start = nav_content_item._cache_offset.left;
			var offset_end = offset_start+nav_content_item._cache_width;
			console.log(start_line,offset_start,end_line)
			if (offset_start<start_line) {
				nav_content_item.css({
					marginLeft:start_line-offset_start
				})
			}else if(offset_end>end_line){
				nav_content_item.css({
					marginLeft:end_line-offset_end
				})
			}else{
				var half_margin = -(nav_content_item._cache_width/2)+nav_item.width()/2;
				if ((offset_start+half_margin)<start_line) {
					nav_content_item.css({
						marginLeft:start_line-offset_start
					})
				}else{
					nav_content_item.css({
						marginLeft:half_margin
					})
				}
			}
			nav_item.on("mouseenter",function(){
				nav_item.addClass("nav-item-hover");
				nav_content_item.stop().css({
					display:"block"
				}).animate({
					height:nav_content_item._cache_height
				},130);
			}).on("mouseleave",function(){
				nav_item.removeClass("nav-item-hover");
				nav_content_item.stop().css({
					display:"none"
				}).animate({
					height:0
				},130);
			});
		}
	});

	nav_items.last().css({
		paddingRight:"20px",
		marginRight:"-20px"
	})
});
