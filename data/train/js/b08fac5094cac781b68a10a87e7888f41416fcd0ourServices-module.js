(function(define){
	"use strict";

	define(['common/common',
	        'ourServices/ourServices-route',
	        'ourServices/controllers/ourService-ctrl',
	        'ourServices/services/ourService-service'],
			function(common, OurServiceRoute, OurServiceCtrl, OurServiceService) {

		var moduleName = 'ourServicePage';
		angular.module(moduleName, [common, 'ui.grid', 'restResource', 'services.i18nNotifications'])
				.config(OurServiceRoute)
				.controller('OurServiceCtrl', OurServiceCtrl)
				.factory('OurServiceService', OurServiceService);
		return moduleName;
	});

}(define));