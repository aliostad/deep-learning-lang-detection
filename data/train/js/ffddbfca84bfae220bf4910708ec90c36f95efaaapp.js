$(document).ready(function(){
	// Detect webkit browsers to alter letterspacing in CSS
	
	if ($.browser.webkit) {
		$('body').addClass('webkit');
	}
	
	$.localScroll({duration:400, offset:-78});
	
	
	var $nav = $('ul.indexNav'),
		navFixedTop = 36, /* this is how far we want the nav to stay from the top of the page when it's fixed */
		navFixedLeft = $nav.offset().left,
		navPosLeft = $nav.css('left'),
		navPosTop = $nav.css('top'),
		scrollTopLimit = $nav.offset().top - navFixedTop;
	
	// Make the Index nav scroll with the page
	
	$(window).scroll(function() {
		var scrollTop = $(window).scrollTop();
		if(scrollTop<=scrollTopLimit) {
			if($nav.css('position')==="fixed") {
				$nav.css({
					position: 'absolute',
					top: navPosTop,
					left: navPosLeft
				});
			}
		} else if(scrollTop>scrollTopLimit) {
			if($nav.css('position')==="absolute") {
				$nav.css({
					position: 'fixed',
					top: navFixedTop,
					left: navFixedLeft
				});
			}
		}
	});
	
	
});