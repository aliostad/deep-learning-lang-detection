'use strict';
angular.module('StressApp').config(['$routeProvider', function($routeProvider){
  $routeProvider
    .when('/',{
      templateUrl: 'views/main.html',
      controller: 'HomeController'
    })
    .when('/login',{
      templateUrl: 'views/partials/login.html'
    })
    .when('/signup',{
      templateUrl: 'views/partials/signup.html'
    })
    .when('/resources',{
      templateUrl: 'views/resources.html',
      controller: 'ImageController',
      controllerAs: 'imageController'
    })
    .when('/profile',{
      templateUrl: 'views/profile.html',
      controller: 'ProfileController',
      controllerAs: 'profileController'
    })
    .when('/profile/create-update',{
      templateUrl: 'views/partials/profile-create-update.html',
      controller: 'ProfileController',
      controllerAs: 'profileController'
    })
     .when('/journal',{
      templateUrl: 'views/journals.html',
      controller: 'JournalController',
      controllerAs: 'journalController'
    })
    .when('/journal/create',{
      templateUrl: 'views/partials/create.html',
      controller: 'JournalController',
      controllerAs: 'journalController'
    })
    .when('/chat',{
      templateUrl: 'views/firebase.html',
      controller: 'ChatController',
      controllerAs: 'chatController'
    })
    .otherwise({
      redirectTO: '/'
    });
}]);
