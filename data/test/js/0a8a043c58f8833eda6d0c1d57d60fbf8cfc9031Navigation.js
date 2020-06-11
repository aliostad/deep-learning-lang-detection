/*
 * (C) Elia Contini 2014-2015. All right reserved.
 */
var Navigation = {
	_nav: null,
	_showNav: false,
	
	init: function() {
		this._nav = document.getElementById("nav");
		var parent = this._nav.parentNode;
		var navButton = document.createElement("span");
		navButton.setAttribute("class", "nav-button i-menu");
		parent.insertBefore(navButton, this._nav);
		Navigation._attachEvent(navButton, "click");
		Navigation._attachEvent(navButton, "touchstart");
	},

	_attachEvent: function(node, eventType) {
		node.addEventListener(eventType, function(event) {
			event.preventDefault();
			Navigation._showNav = !Navigation._showNav;
         
			if(Navigation._showNav) {
				Navigation._nav.style.display = "block";
			}
			else {
				Navigation._nav.style.display = "none";
			}
		}, false);
	}
};
Navigation.init();
