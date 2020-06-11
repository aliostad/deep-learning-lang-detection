'use strict';

//Setting up route
angular.module('service-companies').config(['$stateProvider',
	function($stateProvider) {
		// Service companies state routing
		$stateProvider.
		state('listServiceCompanies', {
			url: '/service-companies',
			templateUrl: 'modules/service-companies/views/list-service-companies.client.view.html'
		}).
		state('createServiceCompany', {
			url: '/service-companies/create',
			templateUrl: 'modules/service-companies/views/create-service-company.client.view.html'
		}).
		state('viewServiceCompany', {
			url: '/service-companies/:serviceCompanyId',
			templateUrl: 'modules/service-companies/views/view-service-company.client.view.html'
		}).
		state('editServiceCompany', {
			url: '/service-companies/:serviceCompanyId/edit',
			templateUrl: 'modules/service-companies/views/edit-service-company.client.view.html'
		});
	}
]);