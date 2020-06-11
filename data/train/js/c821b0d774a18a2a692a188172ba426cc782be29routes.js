
// routes
vetoApp.config(function($routeProvider) {
    $routeProvider
    .when('/' , {
        templateUrl: 'pages/home.htm',
        controller: 'homeController'
    })
    .when('/join' , {
        templateUrl: 'pages/join.htm',
        controller: 'joinController'
    })
    .when('/join/code' , {
        templateUrl: 'pages/join.htm',
        controller: 'joinController'
    })
    .when('/veto' , {
        templateUrl: 'pages/veto.htm',
        controller: 'vetoController'
    })
    .when('/forecast/:days' , {
        templateUrl: 'pages/forecast.htm',
        controller: 'forecastController'
    })
});