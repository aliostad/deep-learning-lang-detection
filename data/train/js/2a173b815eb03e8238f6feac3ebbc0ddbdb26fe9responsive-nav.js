//-----------------------------------------------------------
// responsive nav, based on https://github.com/MartinBlackburn/responsive-nav and https://github.com/twelve20/Responsive-Menu
//-----------------------------------------------------------
(function($){
	
	$.fn.responsiveNav = function(options) {
	
		// default settings
		var settings = $.extend({
			'breakPoint': 640,
			'navControlText': 'Menu'
		}, options);
		
		
		return this.each(function() {
		
			var docWidth = $(document).width(),
				wrapper = $(this),
				navUL = wrapper.find("ul").first();
			
			//add open class to nav
			wrapper.addClass("nav-open");
		
			//add nav controls
			var navControl = $('<div class="navControl" id="navControl"/>').prependTo(wrapper);
			var navControlLink = $('<a/>', {"text": settings.navControlText}).prependTo(navControl);
		
			function init() {
				checkNav();
			}

			init();

			//open or close nav
			function toggleNav() {
				//toggle open class
				wrapper.toggleClass("open");
		
				//open or close nav
				navUL.slideToggle();
			}
		
			$('#navControl a').on('click', function() {
				toggleNav();
			});
		
			//hide or show nav controls depending on breakpoint
			function checkNav() {
				if( docWidth > settings.breakPoint ) {
					navControl.hide();
		
					//if nav is hidden, open it
					if( !wrapper.hasClass("nav-open") ) {
						navUL.css("display", "block");
						wrapper.addClass("nav-open");
					}
				}
				else {
					navControl.show();
		
					//if nav is open, hide it
					if( wrapper.hasClass("nav-open") ) {
						navUL.css("display", "none");
						wrapper.removeClass("nav-open");
					}
				}
			}
		
			//listener for screen width
			$(window).resize(function() {
				docWidth = $(document).width();
				checkNav();
			});
			
		});
	};
	
})(jQuery);
// end jquery plugin
