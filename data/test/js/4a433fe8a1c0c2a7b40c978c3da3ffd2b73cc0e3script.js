var gepetoApp = angular.module('gepeto', [ 'ngRoute' ]);

gepetoApp.config(function($routeProvider) {
  $routeProvider

  .when('/', {
    templateUrl : 'pages/home.html',
    controller  : 'mainController'
  })

  .when('/about', {
    templateUrl : 'pages/about.html',
    controller  : 'aboutController',
  })

  .when('/contact', {
    templateUrl : 'pages/contact.html',
    controller  : 'contactController'
  })
  ;
});

gepetoApp.controller('mainController', function($scope) {
  $scope.message = 'Hello World, main controller';
});

gepetoApp.controller('aboutController', function($scope) {
  $scope.message = 'about Handler';
});

gepetoApp.controller('contactController', function($scope) {
  $scope.message = 'contact us';
});
