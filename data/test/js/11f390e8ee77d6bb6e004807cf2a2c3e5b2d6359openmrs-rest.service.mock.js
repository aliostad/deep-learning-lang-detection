/*
jshint -W098, -W117, -W003, -W026
*/
(function () {
	'use strict';

	var mockedModule = angular
		.module('mock.openmrsRestServices');

	mockedModule.factory('OpenmrsRestService', OpenmrsRestService);

	OpenmrsRestService.$inject = ['$q', 'LocationResService'];

	function OpenmrsRestService($q, LocationResService) {
		var service = {
			isMockService: true,
			getLocationResService: getLocationService,
		}
		return service;
		
		function getLocationService() {
			//console.log("Get locations called");
			return LocationResService;
		}
	}

})();