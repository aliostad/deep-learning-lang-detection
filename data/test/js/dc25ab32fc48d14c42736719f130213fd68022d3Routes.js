'use strict';

angular.module('celebNameGameApp').config(['$routeProvider',
  function($routeProvider){
    $routeProvider
      .when('/',{
        templateUrl: 'views/main.html',
        controller: 'HomeController'
      })
      .when('/search',{
        templateUrl: 'views/search.html',
        controller: 'SearchController'
      })
      .when('/results',{
        templateUrl: 'views/search-results.html',
        controller: 'SearchController'
      })
      .when('/game',{
        templateUrl: 'views/game.html',
        controller: 'GameController',
        controllerAs: 'gameController'
      })
      .otherwise({
        redirectTo: '/'
      });
    }
  ]);
