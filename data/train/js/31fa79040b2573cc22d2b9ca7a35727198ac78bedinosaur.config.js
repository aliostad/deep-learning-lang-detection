;(function(){
  'use strict';
  angular.module('TTT')
  .config(function($routeProvider){
    $routeProvider
    .when('/dino',{
      templateUrl: 'views/dino.html',
      controller: 'dinosaurController',
      controllerAs: 'dino'
    })
    .when('/', {
      templateUrl: 'views/_home.html',
      controller: 'mainController',
      controllerAs: 'main'
    })
    .when('/van', {
      templateUrl: 'views/van.html',
      controller: 'vanController',
      controllerAs: 'van'
    })
    .when('/end', {
      templateUrl: 'views/_end.html',
      controller: 'endController',
      controllerAs: 'end'
    });
  });
})();
