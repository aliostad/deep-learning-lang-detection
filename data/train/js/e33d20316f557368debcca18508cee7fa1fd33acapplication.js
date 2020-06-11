
var Application;
(function(Application) {
    (function(Controller) {
        var HuntController = (function() {
            function HuntController($scope, $http, $location, $sce) {
                this.$scope = $scope;
                this.$http = $http;
                this.$location = $location;
                this.$sce = $sce;
                $scope.getClass = function(path) {
                    return ($location.path().substr(0, path.length) === path) ? "active" : "";
                };
            }
            HuntController.$inject = ['$scope', '$http', '$location', '$sce'];
            return HuntController;
        })();
        Controller.HuntController = HuntController;
    })(Application.Controller || (Application.Controller = {}));
    var Controller = Application.Controller;
})(Application || (Application = {}));

var app = angular.module('Application', [
    'ngRoute'
]);

app.config(['$routeProvider', function($routeProvider) {
        $routeProvider.
                when('/home', {
                    templateUrl: './home.html',
                    controller: 'HuntController'
                }).
                when('/blog', {
                    templateUrl: './blog.html',
                    controller: 'HuntController'
                }).
                when('/blog/:article', {
                    templateUrl: './blog.html',
                    controller: 'HuntController'
                }).
                when('/documentation', {
                    templateUrl: './documentation.html',
                    controller: 'HuntController'
                }).
                when('/contact', {
                    templateUrl: './contact.html',
                    controller: 'HuntController'
                }).
                otherwise({
                    redirectTo: '/home'
                });
    }]);

app.controller('HuntController', Application.Controller.HuntController);

