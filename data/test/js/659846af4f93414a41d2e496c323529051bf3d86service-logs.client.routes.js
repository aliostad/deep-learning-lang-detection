'use strict';

//Setting up route
angular.module('service-logs').config(['$stateProvider',
	function($stateProvider) {
		// Service logs state routing
		$stateProvider.
		state('listServiceLogs', {
			url: '/service-logs',
			templateUrl: 'modules/service-logs/views/list-service-logs.client.view.html'
		}).
		state('createServiceLog', {
			url: '/service-logs/create',
			templateUrl: 'modules/service-logs/views/create-service-log.client.view.html'
		}).
		state('viewServiceLog', {
			url: '/service-logs/:serviceLogId',
			templateUrl: 'modules/service-logs/views/view-service-log.client.view.html'
		}).
		state('editServiceLog', {
			url: '/service-logs/:serviceLogId/edit',
			templateUrl: 'modules/service-logs/views/edit-service-log.client.view.html'
		});
	}
]);