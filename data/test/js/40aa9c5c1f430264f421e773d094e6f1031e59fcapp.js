/**
 * Created by xuewenwen on 6/3/2015.
 */

var myModule = angular.module("elvenApp", [ 'ngRoute' ]);

myModule.config(function($routeProvider, $locationProvider) {
    $routeProvider.when("/", {
        templateUrl : "main",
        controller : "MongoController",
        controllerAs: "mongoController"
    }).when('/edit', {
        templateUrl : "edit",
        controller : "EditController",
        controllerAs: 'editController'
    }).when('/subjects', {
        templateUrl : "subjects",
        controller : "SubjectsController",
        controllerAs: 'subjectsController'
    }).when('/comments', {
        templateUrl : "comments",
        controller : "CommentsController",
        controllerAs: 'commentsController'
    }).when('/about', {
        templateUrl : "about",
        controller : "AboutController",
        controllerAs: 'aboutController'
    }).otherwise({
        redirectTo : '/'
    });
});