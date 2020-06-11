// Develop21

$(document).ready(function() {
	
	/**
	  * jQuery powered menu
	 */
	
	// hide all sub navigation
	$(".content-nav").hide();
	$(".menu-nav").hide();
	$(".messages-nav").hide();
	$(".module-nav").hide();
	$(".user-nav").hide();
	
	// content
	$(".activate-content-nav").hover(function() {
		// show activated
		$(".content-nav").show();
		// hide other
		$(".menu-nav").hide();
		$(".messages-nav").hide();
		$(".module-nav").hide();
		$(".user-nav").hide();
	});
	
	// menu
	$(".activate-menu-nav").hover(function() {
		// show activated
		$(".menu-nav").show();
		// hide other
		$(".content-nav").hide();
		$(".messages-nav").hide();
		$(".module-nav").hide();
		$(".user-nav").hide();
	});
	
	// messages
	$(".activate-messages-nav").hover(function() {
		// show activated
		$(".messages-nav").show();
		// hide other
		$(".content-nav").hide();
		$(".menu-nav").hide();
		$(".module-nav").hide();
		$(".user-nav").hide();
	});
	
	// modules
	$(".activate-module-nav").hover(function() {
		// show activated
		$(".module-nav").show();
		// hide other
		$(".content-nav").hide();
		$(".messages-nav").hide();
		$(".user-nav").hide();
		$(".menu-nav").hide();
	});
	
	// user
	$(".activate-user-nav").hover(function() {
		// show activated
		$(".user-nav").show();
		// hide other
		$(".content-nav").hide();
		$(".messages-nav").hide();
		$(".module-nav").hide();
		$(".menu-nav").hide();
	});
	
});