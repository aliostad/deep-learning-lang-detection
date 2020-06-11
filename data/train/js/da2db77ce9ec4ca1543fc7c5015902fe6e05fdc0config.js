(function (angular) {
	'use strict';

	angular.module('battlesnake.api')
		.constant('apiConfigs', apiConfigs)
		.constant('apiMode', apiMode)
		.factory('apiConfig', apiConfig)
		;

	/**
	 * @const apiMode
	 *
	 * @description
	 * API configuration to use (is merged with 'common' configuration)
	 */
	var apiMode = 'dev';

	/**
	 * @const apiConfigs
	 *
	 * @description
	 * API configurations
	 */
	var apiConfigs = {
		common: {
			secure: true,
			path: '/'
		},
		dev: {
			domain: 'api.uriel.err.ee'
		},
		live: {
			domain: 'api.err.ee'
		}
	};

	/**
	 * @const apiConfig
	 *
	 * @description
	 * Merges the selected configuration mode (apiConfigs[apiMode]) with the
	 * common configuration (apiConfigs.common) and returns it
	 */
	function apiConfig(apiConfigs, apiMode) {
		return $({}).extend(apiConfigs.common, apiConfigs[apiMode]);
	}

})(window.angular);
