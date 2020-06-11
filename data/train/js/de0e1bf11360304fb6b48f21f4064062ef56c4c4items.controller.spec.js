'use strict';

describe('Controller: FlightItemsController', function () {

	// load the controller's module
	beforeEach(module('flightLogApp.flight.items'));

	var controller;
	var scope;

	// Initialize the controller and a mock scope
	beforeEach(inject(function ($controller, $rootScope) {
		scope = $rootScope.$new();
		controller = $controller('FlightItemsController', {
			// $scope: scope
		});
	}));

	it('object should exist', function () {
		Should.exist(controller);
		controller.should.be.an.instanceof(Object);
	});

});
