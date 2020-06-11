/**
 * Example module module
 *
 * $author       Richard Bultitude
 * $email        richard.bultitude@gmail.com
 * $copyright    Copyright (c) 2013, thisiszone.com. All rights reserved.
 * $version      1.0
 *
 * $notes        Notes
 */

var requireLocalized = requireLocalized || {};

define(['jquery'], function($) {
    'use strict';

    var mobileNav = {

	    $button: $('.btn-nav'),
	    $nav: $('.btn-nav').siblings('[role="list"]'),

	    init: function mobileNavInit(){
	        mobileNav.$button.on('click', function(e) {
	            e.preventDefault();
	            if (mobileNav.$nav.is(':visible') || mobileNav.$nav.hasClass('open')) {
	                mobileNav.$nav.removeClass('open');
	            } else {
	            	mobileNav.$nav.addClass('load');
	                setTimeout(function() {
	                	mobileNav.$nav.addClass('open').removeClass('load');
	                },50);
	            }
	        });
	    }
	}

    return mobileNav;

});