'use strict';

var cmApp = angular.module('cmApp', ['ngCookies','ngSanitize']);



// Application Routes

cmApp.config(function($routeProvider){
    $routeProvider.
        when('/',{
            controller: 'DashboardController',
            templateUrl: '/views/dashboard.html'}).
        when('/customers',{
            controller: 'CustomersController',
            templateUrl: '/views/customers.html'}).
        when('/projects',{
            controller: 'ProjectsController',
            templateUrl: '/views/projects.html'}).
        when('/calender',{
            controller: 'CalenderController',
            templateUrl: '/views/calender.html'}).
        otherwise({ redirectTo: '/'});
});


cmApp.controller('CmAppController', function($scope){

});

cmApp.controller('DashboardController', function($scope){

});

cmApp.controller('CustomersController', function($scope, customerService){
    $scope.customers = customerService.getCustomers();

});

cmApp.controller('ProjectsController',function($scope){

});

cmApp.controller('CalenderController',function($scope){

});

