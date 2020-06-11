'use strict';

describe('myApp.grid-controller-init module', function () {

    beforeEach(module('myApp'));

    var $controller, $rootScope;

    beforeEach(inject(function (_$controller_, _$rootScope_) {
        $controller = _$controller_;
        $rootScope = _$rootScope_;
    }));

    describe('grid-controller-init controller', function () {

        it('should ....', inject(function ($controller, $rootScope, northwind) {
            //spec body
            var gridControllerInitController = $controller('GridControllerInitController',
                { $scope: $rootScope.$new(), northwind: northwind });
            expect(gridControllerInitController).toBeDefined();
        }));

    });
});