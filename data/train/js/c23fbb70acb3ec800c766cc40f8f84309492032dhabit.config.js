;(function() {
  "use strict";
  angular.module('trackerApp')
    .config(function($routeProvider){
      $routeProvider
        .when('/habits', {
          templateUrl: "views/habits.html",
          controller: "HabitController",
          controllerAs: "habitCtrl",
          private: true
        })
        .when('/newhabit', {
          templateUrl: "views/newhabit.html",
          controller: "HabitController",
          controllerAs: "habitCtrl",
          private: true
        })
        .when('/habits/:id', {
          templateUrl: "views/show.html",
          controller: "ShowController",
          controllerAs: "show",
          private: true
        })
        .when('/habits/:id/edit', {
          templateUrl: "views/newhabit.html",
          controller: "EditController",
          controllerAs: "habitCtrl",
          private: true
        })
        .when('/grid', {
          templateUrl: "views/grid.html",
          controller: "HabitController",
          controllerAs: "habitCtrl",
          private: true
        })
        .when('/stats', {
          templateUrl: "views/stats.html",
          controller: "HabitController",
          controllerAs: "habitCtrl",
          private: true
        })
    })
}());
