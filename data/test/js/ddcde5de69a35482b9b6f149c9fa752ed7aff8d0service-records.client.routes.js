'use strict';

//Setting up route
angular.module('service-records').config(['$stateProvider',
	function($stateProvider) {
		// Service records state routing
		$stateProvider.
		state('listServiceRecords', {
			url: '/service-records',
			templateUrl: 'modules/service-records/views/list-service-records.client.view.html'
		}).
		state('createServiceRecord', {
			url: '/service-records/create',
			templateUrl: 'modules/service-records/views/create-service-record.client.view.html'
		}).
		state('viewServiceRecord', {
			url: '/service-records/:serviceRecordId',
			templateUrl: 'modules/service-records/views/view-service-record.client.view.html'
		}).
		state('editServiceRecord', {
			url: '/service-records/:serviceRecordId/edit',
			templateUrl: 'modules/service-records/views/edit-service-record.client.view.html'
		});
	}
]);