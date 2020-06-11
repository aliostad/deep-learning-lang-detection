var app = angular.module('aplus', ['ngRoute','ui.bootstrap']);

app.config(['$routeProvider', function($routeProvider) {
    $routeProvider
        .when('/main', {
            templateUrl: 'partials/main.html',
            controller: 'AplusController'
        }).when('/about', {
            templateUrl: 'partials/about.html',
            controller: 'AplusController'
        }).when('/clients', {
            templateUrl: 'partials/clients.html',
            controller: 'AplusController'
        }).when('/contact', {
            templateUrl: 'partials/contact.html',
            controller: 'AplusController'
        }).when('/legal', {
            templateUrl: 'partials/legal.html',
            controller: 'AplusController'
        }).when('/privacy', {
            templateUrl: 'partials/privacy.html',
            controller: 'AplusController'
        }).when('/careers', {
            templateUrl: 'partials/careers.html',
            controller: 'AplusController'
        }).when('/login', {
            templateUrl: 'partials/login.html',
            controller: 'AplusController'
        }).when('/protections', {
            templateUrl: 'partials/protections.html',
            controller: 'AplusController'
        }).when('/coverage', {
            templateUrl: 'partials/coverage.html',
            controller: 'AplusController'
        }).when('/risk', {
            templateUrl: 'partials/risk.html',
            controller: 'AplusController'
        })
        .otherwise({
            templateUrl: 'partials/main.html',
            controller: 'AplusController'
        });

}]);

app.controller('AplusController', function($scope) {

    $scope.sendmail = function(){
        alert("Your message has been send!");
    };

    $scope.slides = [
        {image: 'images/1.jpg'},
        {image: 'images/2.jpg'},
        {image: 'images/3.jpg'}
    ];
});
