(function($, ko) {
	'use strict';

	function navMenuItem(text, url, subNavMenu) {
		var self = {
			text: ko.observable(text),
			url: ko.observable(url ? url : '#'),
			subNavMenu: ko.observable(subNavMenu)
		};
		return self;
	};

	function navMenu(navMenuItems) {
		return {
			navMenuItems: ko.observableArray(navMenuItems),
			displayTemplate: function(navMenuItem) {
				return (navMenuItem.subNavMenu() && navMenuItem.subNavMenu().navMenuItems() && navMenuItem.subNavMenu().navMenuItems().length > 0) ? "complexNavMenuTemplate" : "singleNavMenuTemplate";
			}
		};
	};
	/*
	var globalNavMenu = navMenu([
		new navMenuItem("MVC"),
		new navMenuItem("Client", "#", navMenu([
			new navMenuItem("CSS"),
			new navMenuItem("JavaScript", "#", navMenu([
				new navMenuItem("jQuery"),
				new navMenuItem("knockout.js")
			])),
			new navMenuItem("HTML")
		]))
	]);
 	*/

	var globalNavMenu = navMenu([
		new navMenuItem("MVC"),
		new navMenuItem("Client", "#", navMenu([
			new navMenuItem("CSS"),
			new navMenuItem("JavaScript"),
			new navMenuItem("jQuery"),
			new navMenuItem("knockout.js"),
			new navMenuItem("HTML")
		]))
	]);



	$(function() {
		ko.applyBindings(globalNavMenu, document.getElementById("globalNavMenu"));
	});

})(jQuery, ko);