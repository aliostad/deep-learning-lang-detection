'use strict';

var skrollrModule = angular.module('skrollrModule', []);

skrollrModule.factory('skrollrService', ['$window', function($window) {
	var service = {
		skrollr: null,
		view: null,
		directive: null
	};

	service.init = function(element) {
		// there can only be one skrollr directive at a time
		if (service.skrollr) {
			service.destroy();
		}

		service.skrollr = $window.skrollr.init(null, element[0]);
	};

	service.refresh = function(element) {
		if (service.skrollr) {
			service.skrollr.refresh();
		}
	};

	service.destroy = function() {
		if (service.skrollr) {
			service.skrollr.destroy();
			service.skrollr = null;
		}
	};

	return service;
}]);
