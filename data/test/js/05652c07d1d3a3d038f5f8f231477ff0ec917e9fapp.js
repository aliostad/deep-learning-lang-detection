var app = angular.module("rentACar", ['ngRoute'])
    .controller('carsListController', carsListController)
    .controller('carsController', carsController)
    .controller('rentsController', rentsController)
    .controller('currencyController', currencyController)
    .factory('currencyService', currencyService)
    .config(function ($routeProvider) {
        $routeProvider
            .when('/', {
                templateUrl: 'app/views/carsList.html',
                controller: 'carsListController'
            })
            .when('/edit/:id', {
                templateUrl: 'app/views/Edit.html',
                controller: 'carsController',
            })
            .when('/create', {
                templateUrl: 'app/views/Edit.html',
                controller: 'carsController',
            })
            .when('/rent/:id', {
                templateUrl: 'app/views/Rent.html',
                controller: 'rentsController',
            })
            .otherwise({ redirectTo: '/' });
    })
    .constant('baseServiceUrl', 'http://localhost:58623/');