/**
 *
 * Created by sparky on 7/27/15.
 */
'use strict';

describe('Controller: InventoryController', function () {

    // load the controller's module
    beforeEach(module('Backhand'));

    var InventoryController, scope, $location;

    // Initialize the controller and a mock scope
    beforeEach(inject(function ($controller, $rootScope, _$state_) {
        scope = $rootScope.$new();
        scope.authenticated = true;
        InventoryController = $controller('InventoryController', {
            $scope: scope
        });
    }));

    it('should exist', function () {
        expect(InventoryController).toBeDefined();
    });
});
