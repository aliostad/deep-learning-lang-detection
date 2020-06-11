var app=angular.module("MyApp",['ngRoute']);
app.config(function($routeProvider){
    $routeProvider.when('/',{
        templateUrl:'views/main.html',
        controller:'HomeController'
    }).when('/login',{
        templateUrl:'views/login.html',
        controller:'LoginController'
    }).otherwise({
        redirectTo:'/'
    });
});
app.controller("MyController", function ($scope) {

});

app.controller("HomeController", function ($scope) {

});
app.controller("LoginController", function ($scope) {

});