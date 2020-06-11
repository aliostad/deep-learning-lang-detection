'use strict';

var ApiConfig = function() {
	
/* =======================================================================
	Rails API Configuration
======================================================================= */
	var apiProxy = 'api',
		apiVersion = 'v1';

	this.API = {
		DEV: {
			paths: {
				baseUrl: apiProxy + '/' + apiVersion + '/',
				login: apiProxy + '/user/login',
				signup: apiProxy + '/user/signup'
			}
		},
		PROD: {
			paths: {
				baseUrl: apiProxy + '/' + apiVersion + '/',
				login: apiProxy + '/user/login',
				signup: apiProxy + '/user/signup'
			}
		}
	};

	return this;
};

ApiConfig.$inject = [];
module.exports = ApiConfig;