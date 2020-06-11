$('html').removeClass('no-js');

// Collapse mobile nav on JS devices
//$('.nav-control, .nav-menu').removeClass('open');

var metro = metro || {};

// Setup nav bindings, then return a fn for resetting the menu
metro.resetMenu = (function(){
	$(document).on('click', '.nav-control, .nav-menu', function (e) {
		if($(this).hasClass('open')) {
			$(this).parent().find('.nav-control, .nav-menu').removeClass('open');
		}
		else {
			$(this).parent().find('.nav-control, .nav-menu').addClass('open');
		}
	});
	return function(){
		$('.nav-control, .nav-menu').removeClass('open')
	}
}())

metro.resetMenu();
