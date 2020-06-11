!function ($) {

	"use strict";

	var s;
	var app = {
		settings: {
			site: $('.site').find('.inner'), // The site wrapper
			nav_state: 'closed', // Current 'state' of the navigation
			menu_toggle: $('.menu-toggle'), // Menu toggle button
			nav_w: $('nav.navigation').width(), // Width of the navigation
			touch_down: 0, // Start location of swipe
			nav_move: 0, // The movement of the swipe
			nav_watch: false, // Watch for swipe
			nav_threshold: 40 // This is the minimum movement of the menu before an action
		},
		init: function(){
			s = this.settings;
			this.bindUIActions();
		},
		navToggle: function(){
			if( s.site.hasClass('opened-nav') ){
				s.site.animate({'left': '0px'},150).removeClass('opened-nav');
				s.nav_state = 'closed';
			} else {
				s.site.animate({'left': '-200px'},150).addClass('opened-nav');
				s.nav_state = 'open';
			}
		},
		touchStart: function(event){
			var touch = event.touches[0];
				s.touch_down = touch.pageX;
				s.nav_watch = true;
		},
		touchMove: function(event){
			if( s.nav_watch === true )
				app.navMove(event);
		},
		touchEnd: function(event){
			if( s.nav_watch === true )
				app.navSnap();
		},
		navMove: function(event){
			var touch = event.touches[0];
			if( s.nav_move > (s.touch_down+s.nav_threshold) || s.nav_move < (s.touch_down-s.nav_threshold) ){
				if( s.nav_state === 'closed' ){
					s.nav_move = touch.clientX - s.touch_down;
					if( s.nav_move < 0 && s.nav_move > -s.nav_w ){
						event.preventDefault();
						s.site.css({'left': s.nav_move+'px'});
					}
				} else {
					s.nav_move = (touch.clientX - s.nav_w) - s.touch_down;
					if( s.nav_move < 0 && s.nav_move > -s.nav_w ){
						event.preventDefault();
						s.site.css({'left': s.nav_move+'px'});
					}
				}
			}
		},
		navSnap: function(){
			if( s.nav_move < -50 ){
				s.site.css({'left': '-200px'}).addClass('opened-nav');
				s.nav_state = 'open';
			} else {
				s.site.css({'left': '0px'}).removeClass('opened-nav');
				s.nav_state = 'closed';
			}
			s.nav_watch = false;
		},
		bindUIActions: function(){
			menu_toggle.on('click', this.navToggle);

			document.addEventListener('touchstart', app.touchStart, false);
			document.addEventListener('touchmove', app.touchMove, false);
			document.addEventListener('touchend', app.touchEnd, false);
		}

	};
	app.init();

}(window.jQuery);