var app = angular.module("portfolioApp", ['ngRoute']);


app.config(function($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'partials/home.html',
        controller: 'HomeController'
      })
      .when('/bio', {
        templateUrl: 'partials/bio.html',
        controller: 'BioController'
      })
      .when('/resume', {
        templateUrl: 'partials/resume.html',
        controller: 'ResumeController'
      })
      .when('/projects', {
        templateUrl: 'partials/projects.html',
        controller: 'ProjectsController'
      })
      .otherwise ({
        templateUrl: 'partials/home.html',
        controller: 'HomeController'
      })
});
