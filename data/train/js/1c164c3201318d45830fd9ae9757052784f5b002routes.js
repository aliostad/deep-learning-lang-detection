// ROUTES
picalApp.config(function ($routeProvider) {
   
    $routeProvider
    
    .when('/', {
        templateUrl: 'pages/home.htm',
        controller: 'homeController'
    })
    
    .when('/splash', {
        templateUrl: 'pages/splash.htm',
        controller: 'splashController'
    })

    .when('/sync', {
        templateUrl: 'pages/sync.htm',
        controller: 'syncController'
    })
    
    .when('/login', {
        templateUrl: 'pages/login.htm',
        controller: 'loginController'
    })
    
    .when('/login/signup', {
        templateUrl: 'pages/login-signup.htm',
        controller: 'loginController'
    })
    
    .when('/past', {
        templateUrl: 'pages/past.htm',
        controller: 'pastController'
    })

    .when('/next', {
        templateUrl: 'pages/next.htm',
        controller: 'nextController'
    })

    .when('/future', {
        templateUrl: 'pages/future.htm',
        controller: 'futureController'
    })

    .when('/settings', {
        templateUrl: 'pages/settings.htm',
        controller: 'settingsController'
    })

});
