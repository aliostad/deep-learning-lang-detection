'use strict';

describe('Controller: TimmersController', function() {

    // load the controller's module
    beforeEach(module('flipkartApp'));

    var trimmersController,
        scope;

    // Initialize the controller and a mock scope
    beforeEach(inject(function($controller, $rootScope) {
        scope = $rootScope.$new();
        trimmersController = $controller('TrimmersController', {
            $scope: scope
        });
    }));

    it("injection tests", function() {
        expect(trimmersController).toBeDefined();
    });

});