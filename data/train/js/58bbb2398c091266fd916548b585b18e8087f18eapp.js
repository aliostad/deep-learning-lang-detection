var app = angular.module('MyApp', ['ngRoute']);

app.config(function ($routeProvider) {
    $routeProvider.when('/',
        {
            templateUrl: "/views/partials/NewGenre.html",
            controller: "NewGenreController"
        })
        .when('/List',
        {
            templateUrl: "/views/partials/ListGenres.html",
            controller: "ListGenresController"
        })
        .when('/Put/:param',
        {
            templateUrl: "/views/partials/UpdateGenre.html",
            controller: "UpdateGenreController"
        })
});

app.controller('NewGenreController', NewGenreController)
    .controller('ListGenresController', ListGenresController)
    .controller('UpdateGenreController', UpdateGenreController);