app.config(['$routeProvider', '$locationProvider', function ($routeProvider, $locationProvder) {
  $routeProvider
  .when('/', {
    templateUrl : '/home',
    controller : 'homeController'
  })
  .when('/work', {
    templateUrl : '/work',
    controller : 'workController'
  })
  .when('/services',{
    templateUrl : '/services',
    controller : 'servicesController'
  })
  .when('/contact', {
    templateUrl : '/contact',
    controller : 'contactController'
  })
  .when('/about', {
    templateUrl : '/about',
    controller : 'aboutController'
  })
  .otherwise({
    templateUrl : '/404',
    controller : '404Controller'
  });
}]);