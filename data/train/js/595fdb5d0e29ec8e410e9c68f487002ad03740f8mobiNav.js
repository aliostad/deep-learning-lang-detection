$(document).ready(function(){
	$.fn.mobiNav = function(){
		$('.mobi_nav_layout').animate({opacity:0}, 0);
	   
		$(this).click(function(){
			var navLayout = $('.mobi_nav_layout');
			if(navLayout.css('display') == 'none'){
				$('.mobi_nav_layout').stop();
				navLayout.css('display', 'block');
				navLayout.animate({opacity:1}, 200);
			} else {
				navLayout.stop();
				navLayout.animate({opacity: 0}, 200,function(){ navLayout.css('display', 'none'); })
			}
		})
		$('.mobi_nav_layout a').click(function(){
			$('.mobi_nav_layout').stop();
			$('.mobi_nav_layout').animate({opacity:0}, 200, function(){ $('.mobi_nav_layout').css('display', 'none'); });
		})
	}
})