var app = angular.module('myApp', ['ngRoute']);

app.config(function ($routeProvider) {
    $routeProvider.when('/', {
        templateUrl: "app/partials/List.html",
        controller: "ListGenreController"
    })
    .when('/AddGenre', {
        templateUrl: "app/partials/NewGenre.html",
        controller: "NewGenreController"
    })
    .when('/EditGenre/:GenreId', {
        templateUrl: "app/partials/UpdateGenre.html",
        controller: "UpdateGenreController"
    })
    .otherwise({ redirectTo: '/' });
});

app.controller("ListGenreController", ListGenreController)
    .controller("NewGenreController", NewGenreController)
    .controller("UpdateGenreController", UpdateGenreController);