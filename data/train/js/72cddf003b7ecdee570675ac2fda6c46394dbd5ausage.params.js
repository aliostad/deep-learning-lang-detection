(function() {
    var app = angular.module('usageModule');

    app.controller('paramsController', [ 
        function() {
            var controller = this;
            controller.hideParams = false;
            controller.diigoUsername = 'cowaboo';
            controller.zoteroElementId = '303941';
            controller.zoteroKey = '3k89ouyqI6vYIkTsgPJTK4ek';

            controller.save = function() {
                controller.hideParams = true;
            };

            return controller;
        }
    ]);

    app.directive('params', function() {
        return {
            restrict: 'E',
            templateUrl: 'templates/params.html',
            controllerAs: 'params',
            controller: 'paramsController'
        }
    });
})()