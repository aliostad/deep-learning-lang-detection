'use strict';

describe('MenuController', function () {
    var $scope, controllerService, controller;

    beforeEach(angular.mock.module('appModule'));

    beforeEach(inject(function ($controller, $rootScope) {
        $scope = $rootScope.$new();
        controllerService = $controller;

        createController();

    }));

    function createController() {
        controller = controllerService('MainComponentController as vm', {
            '$scope': $scope
        });
    }

    it('should be defined', function () {
        expect(controller).toBeDefined();
    });
});


