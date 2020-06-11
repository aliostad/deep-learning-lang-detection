/// <reference path='_all.ts' />
/**
* The main TodoMVC app module.
*
* @type {angular.Module}
*/
var forum;
(function (forum) {
    var forumApp = angular.module('forum', ['ngRoute', 'ngCookies', 'ngAnimate']).controller("HomeController", forum.HomeController).controller("LoginController", forum.LoginController).controller("ThreadController", forum.ThreadController).controller("StatisticController", forum.StatisticController);

    forumApp.config(function ($routeProvider) {
        $routeProvider.when('/', {
            templateUrl: 'partials/home.html',
            controller: 'HomeController'
        }).when('/login', {
            templateUrl: 'partials/login.html',
            controller: 'LoginController'
        }).when('/thread/:threadId', {
            templateUrl: 'partials/thread.html',
            controller: 'ThreadController'
        }).when('/statistic', {
            templateUrl: 'partials/statistic.html',
            controller: 'StatisticController'
        }).otherwise({
            redirectTo: '/login'
        });
    });
})(forum || (forum = {}));
