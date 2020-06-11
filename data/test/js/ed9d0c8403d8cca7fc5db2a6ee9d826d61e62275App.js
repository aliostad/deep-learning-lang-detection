var app = angular.module('MyApp', ['ngRoute']);

app.config(function($routeProvider, $locationProvider) {
    $routeProvider.when('/New',
        {
            templateUrl: '/app/partials/New.html',
            controller: 'NewEntryController'
        })
        .when('/', {
            templateUrl: '/app/partials/List.html',
            controller: 'AllEntriesController'
        })
        .when('/Edit/:id', {
            templateUrl: '/app/partials/Edit.html',
            controller: 'EditEntryController'
        })
        .otherwise({
            redirectTo: '/'
        });

    $locationProvider.html5Mode({ enable: true });
});

app.controller('AllEntriesController', AllEntriesController).controller('EditEntryController', EditEntryController).controller('NewEntryController', NewEntryController);