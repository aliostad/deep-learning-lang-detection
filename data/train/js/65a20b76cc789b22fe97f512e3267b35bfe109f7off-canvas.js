/*====================================
=            ON DOM READY            =
====================================*/
$(function() {

	$('.toggle-nav').click(function() {
			toggleNav();
		});

    FastClick.attach(document.body);
});

/*========================================
=            CUSTOM FUNCTIONS            =
========================================*/

function toggleNav() {
	if ($('.site-wrapper').hasClass('show-nav')) {
		// Do things on Nav Close
		$('.site-wrapper').removeClass('show-nav');
	} else {
		// Do things on Nav Open
		$('.site-wrapper').addClass('show-nav');
	}
}

/*========================================
=     MAKE ESCAPE KEY CLOSE THE NAV      =
========================================*/

$(document).keyup(function(e) {
	if (e.keyCode == 27) {
		if ($('.site-wrapper').hasClass('show-nav')) {
			toggleNav();
		}
	} 
});

