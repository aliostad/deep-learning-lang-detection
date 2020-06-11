var app = require('../../app');

/**
 * API v1 route constantss
 * @type {String}
 */
app.constant('APIv1', (function() {
	/**
	 * Base URL
	 * @type {String}
	 */
	var base = window.location.origin + '/api/',

	/**
	 * API object
	 * @type {Object}
	 */
		api = {};

	/**
	 * auth
	 */
	api.auth = {};
	api.auth.base 	= base;
	api.auth.guest 	= base;
	api.auth.check 	= base;
	api.auth.data 	= base;

	/**
	 * 
	 */
	api.holiday = {};
	api.holiday.index = function(year) {
		return base + year;
	}

	return api;
})());