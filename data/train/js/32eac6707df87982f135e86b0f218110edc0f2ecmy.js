$(document).ready(function() { 
	$('#menu-icon').sidr(); 
});

$(function($){
	"use strict";

	var MIN_WINDOW_WIDTH = 768,
		navContainer = $('nav'),
		navIsFixed = false,
		navOffsetTop = navContainer.offset().top,
		win = $(window);

	function setNavbarFixedState() {
		if (win.scrollTop() >= navOffsetTop && win.width() > MIN_WINDOW_WIDTH) {
			if (!navIsFixed) {
				navContainer.addClass('fixed');
				navContainer.after($('<div></div>')
					.css('height', navContainer.outerHeight(true))
					.addClass('nav-container'));
				navIsFixed = true;
			}
		} else if (navIsFixed) {
			navContainer.removeClass('fixed');
			navContainer.next().remove();
			navIsFixed = false;
		}
    }
    setNavbarFixedState();

    win.on('scroll', setNavbarFixedState);
});