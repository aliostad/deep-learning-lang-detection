jQuery(document).ready(function($) {
	
	var navId = '#nav', navOpenClass = 'nav-open';

	$('#nav-menu').on('click', function (event) {
		if($(navId).hasClass(navOpenClass)) {

			$(navId).animate({
				height: 0
			  },
				300, function() {
				setTimeout(function () {
					$(navId).removeClass(navOpenClass).removeAttr('style');
				}, 320);
			});
		}
		else {
			// alert('close nav');
			// $(navId).addClass(navOpenClass);

			var newHeight = $(navId).css('height', 'auto').height();
			// alert(newHeight);
			$(navId).height(0).animate({
				height: newHeight
			},
				300, function() {
				/* stuff to do after animation is complete */
				setTimeout(function () {
					$(navId).addClass(navOpenClass).removeAttr('style');
				}, 320);
			});
		}
	});
	// $('#nav-menu') Ends

});
// jQuery(document) Ends