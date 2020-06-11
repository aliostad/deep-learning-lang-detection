//
// Navigation Animation
//
// Author: Erik Teichmann
// www.erikteichmann.com
//

(function($) {
	
// NAV DROPDOWN
$(function() {
	$("#nav ul li ul").css({ display: 'none' });
	$("#nav ul li").hover(function() {
		$(this).children('ul').stop(true, true).delay(50).animate({ "height": "show", "opacity": "show" }, 200 );
	}, function(){
		$(this).children('ul').stop(true, true).delay(50).animate({ "height": "hide", "opacity": "hide" }, 200 );
	});
});

// NAV AUTO PADDING - FIRST LOAD
$(function() {
	var navAClass = '#nav > ul > li > a';
	$(navAClass).css({'paddingLeft' : 0 , 'paddingRight' : 0});
	var navCount = $(navAClass).size();
	var navOW = $('#nav').outerWidth();
	var navWidth = 0;
	var navDiff = 0;
	var navPad = 0;
	$(navAClass).each(function() {
		navWidth += $(this).outerWidth();
	});
	  navDiff = navOW - navWidth - 2;
	  navPad = navDiff/navCount;
	  navPad = navPad/2;
	  navPad = Math.floor(navPad);
	  navPad = navPad;
	$(navAClass).css({'paddingLeft' : navPad , 'paddingRight' : navPad});

});

// NAV AUTO PADDING - SECOND LOAD (detect @font-face/other font modifications)

$(window).load(function() {
	var navAClass = '#nav > ul > li > a';
	$(navAClass).css({'paddingLeft' : 0 , 'paddingRight' : 0});
	var navCount = $(navAClass).size();
	var navOW = $('#nav').outerWidth();
	var navWidth = 0;
	var navDiff = 0;
	var navPad = 0;
	$(navAClass).each(function() {
		navWidth += $(this).outerWidth();
	});
	  navDiff = navOW - navWidth - 2;
	  navPad = navDiff/navCount;
	  navPad = navPad/2;
	  navPad = Math.floor(navPad);
	  navPad = navPad;
	$(navAClass).css({'paddingLeft' : navPad , 'paddingRight' : navPad});

});
}(jQuery));
