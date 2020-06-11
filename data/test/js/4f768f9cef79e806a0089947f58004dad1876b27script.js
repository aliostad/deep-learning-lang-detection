$(document).ready(function() {
	var nav = "#nav", navOpen = "nav-open";
		$('#nav-menu').click(function() {
			if ($(nav).hasClass(navOpen)) {
				$(nav).animate({
					opacity: 0.25,
					height: 0},
					500 );
				setTimeout(function() {
					$(nav).removeClass(navOpen).removeAttr('style');
				}, 510);
			} 
			else
			{
				var newH = $(nav).css('height', 'auto').height();
				$(nav).height(0).animate({
					opacity: 1,
					height: newH},
					500 );
				setTimeout(function() {
					$(nav).addClass(navOpen).removeAttr('style');
				}, 510);
			};
		});
	});
	
	// Using Toggle as below would add extra DOM for inline style.  
		// $('#nav-menu').click(function() {
		// 	$( "#nav" ).slideToggle( "slow" );
		// });