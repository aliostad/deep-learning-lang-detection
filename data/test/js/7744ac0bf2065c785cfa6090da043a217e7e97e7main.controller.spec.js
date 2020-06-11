'use strict';

describe('Controller: FlightMainController', function () {

	// load the controller's module
	beforeEach(module('flightLogApp.flight.main'));

	var controller;
	var scope;

	// Initialize the controller and a mock scope
	beforeEach(inject(function ($controller, $rootScope) {
		scope = $rootScope.$new();
		controller = $controller('FlightMainController', {
			// $scope: scope
		});
	}));

	it('object should exist', function () {
		Should.exist(controller);
		controller.should.be.an.instanceof(Object);
	});

});
