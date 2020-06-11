"use strict";
angular.module("myApp", ["ng"])
    .factory("counterService", function() {
        var counterService = {};
        var counter = 1;
        counterService.increase = function() {
            counter += 1;
        };
        counterService.value = function() {
            return counter;
        };

        window.counterService = counterService;
        return counterService;
    })

    .controller( "Ctrl", function($scope, counterService) {
        $scope.counter = 0;
        $scope.click = function() {
            counterService.increase();
            $scope.counter = counterService.value();
        };
    });