'use strict';

var wciApp = angular.module(
    'WCI',
    [
        'ui.bootstrap',
        'ngRoute',
        'ngSanitize',
        'ui.select'
    ]
);

wciApp.config(function ($routeProvider, $locationProvider) {
    $routeProvider
    .when('/changelog',
    {
        templateUrl: 'Views/changelog.html',
        controller: 'ChangelogController',
        controllerAs: 'cl'
    })
    .when('/ia',
    {
        templateUrl: 'Views/internalAffairs.html',
        controller: 'CountryController',
        controllerAs: 'countryCtrl'
    })
    .when('/structure',
    {
        templateUrl: 'Views/structures.html',
        controller: 'StructureController',
        controllerAs: 'structureCtrl'
    })
    .when('/military',
    {
        templateUrl: 'Views/military.html',
        controller: 'MilitaryController',
        controllerAs: 'militaryCtrl'
    })
    .when('/research',
    {
        templateUrl: 'Views/research.html',
        controller: 'ResearchController',
        controllerAs: 're'
    })
    .when('/war',
    {
        templateUrl: 'Views/war.html',
        controller: 'WarController',
        controllerAs: 'war'
    })
    .otherwise({
        redirectTo: '/ia'
    });
    
});

