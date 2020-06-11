
;(function($) {

	// DOM ready
	$(function() {
		$('.nav').append($('<div class="nav-mobile"></div>'));
		$('.nav').append($('<span class="name">Menu</span>'));
		$('.nav-item').has('ul').prepend('<span class="nav-click"><i class="nav-arrow"></i></span>');
		$('.nav-submenu-item').has('ul.nav-submenu2').prepend('<span class="nav-click"><i class="nav-arrow"></i></span>');
		$('.nav-mobile').click(function(){
			$('.nav-list').slideToggle();
		});
		$('.nav-list').on('click', '.nav-click', function(){
			$(this).siblings('.nav-submenu').slideToggle();
			$(this).siblings('.nav-submenu2').slideToggle();
			$(this).children('.nav-arrow').toggleClass('nav-rotate');
		});
	});
	})(jQuery);
	
	

