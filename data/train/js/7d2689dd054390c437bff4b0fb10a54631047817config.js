;(function(){
  'use strict';
  angular.module('addressBook')
  .config(function($routeProvider){
    $routeProvider
    .when('/login', {
       templateUrl: 'views/login.html',
       controller: 'LoginController',
       controllerAs: 'login'
    })
    .when('/', {
        templateUrl: 'views/table.html',
        controller: 'addressBookController',
        controllerAs: 'ab'
    })
    .when('/new', {
      templateUrl : 'views/form.html',
      controller: 'addressBookController',
      controllerAs: 'ab'
    })
    .when('/:id', {
      templateUrl: 'views/show.html',
      controller: 'ShowController',
      controllerAs: 'show'
    })
    .when('/:id/edit', {
      templateUrl: 'views/form.html',
      controller: 'EditController',
      controllerAs: 'ab'
    })
    .otherwise({redirectTo: '/'});
    })
})();