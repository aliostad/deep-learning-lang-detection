;(function () { 'use strict';

	angular.module('smuFactories')
		.factory('ApiUriFactory', ApiUriFactory);

	ApiUriFactory.$inject = [
		'$location',
		'configApi'
	];

	function ApiUriFactory($location, configApi) {

		return {
			make: function (path) {
				var protocol = configApi.protocol ? configApi.protocol : $location.protocol();
				var host     = configApi.host     ? configApi.host     : $location.host();
				var uri = protocol + '://' + host + configApi.path + path;

				return uri;
			}
		}

	}

})();
