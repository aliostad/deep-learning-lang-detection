define(['./controllers/home', './controllers/park', './controllers/reservation'], function(homeController, parkController, reservationController) {
  var routes;
  routes = function($routeProvider, $locationProvider, $httpProvider) {
    $locationProvider.html5Mode(true);
    return $routeProvider.when('/', {
      templateUrl: './templates/home.html',
      controller: 'homeController'
    }).when('/park', {
      templateUrl: './templates/park.html',
      controller: 'parkController'
    }).when('/reservation', {
      templateUrl: './templates/reservations.html',
      controller: 'reservationController'
    }).when('/confirmation', {
      templateUrl: './templates/confirmation.html',
      controller: 'reservationController'
    });
  };
  return function(app) {
    app.config(routes);
    app.controller('homeController', homeController);
    app.controller('parkController', parkController);
    return app.controller('reservationController', reservationController);
  };
});
