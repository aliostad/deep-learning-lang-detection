(function($) {

	$.fn.gallery = function(o) {
		'use strict';

		var $nav = $(this),
		    $navList = $nav.children(),
		    $nav_w = $navList.width(),
		    $nav_h = $navList.height(),
		    $navLength = $nav.children().length,

		    $view = $('.view'),
		    $viewList = $view.children(),
		    viewNum = 5;

		$nav.parent().css({'width': $nav_w * viewNum + 'px', 'height' : $nav_h + 'px'});
		$nav.css('width' , $nav_w * $navLength + 'px');

		$nav.find('li a').click(function() {
			var $navIndex = $(this).parent().index() + 1;
			$view.find('li:nth-child(' + $navIndex +')').show();
		});

		var $btnPrev = $('.btn_prev');
		var $btnNext = $('.btn_next');
		var $navLeft = $('.nav').css('left','0');

		$btnPrev.click(function(){
			var navPos = $navLeft.position().left;
			$('.nav').animate({left: navPos - $nav_w + 'px'}, 200);
		});

		$btnNext.click(function(){
			var navPos = $navLeft.position().left;
			$('.nav').animate({left: navPos + $nav_w + 'px'}, 200);
		});



	};
})(jQuery);