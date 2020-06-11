'use strict';
define(function(require, exports) {
    var navTemplate = require("./templates/nav.html");

    angular.module('ecgNav', [])
    .controller('NavController', function ($scope) {
        $scope.nav = {};
        $scope.nav.getRoles = function() {
            return $scope.session.user.roles;
        };
    })
    .directive("ecgNav", ['$location', function ($location) {
        return {
            restrict: 'A',
            replace: true,
            template: navTemplate,
            controller: "NavController",
            link: function ($scope, $element, $attrs) {
            }
        };
    }]);

});