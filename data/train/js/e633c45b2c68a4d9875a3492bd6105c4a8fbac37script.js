var app = angular.module('app', ['ngRoute']);

app.config(['routeProvider', function($routeProvider){
  $routeProvider.
   when('/main',{
     template: 'main.html',
     controller: 'MainController'
   }).
   when('/about',{
     template: 'about.html',
     controller: 'MainController'
   }).
   when('/services',{
     template: 'services.html',
     controller: 'ServicesController'
   }).when('/contact',{
     template: 'contact.html',
     controller: 'ContactController'
   }).
   otherwise({redirectTo:'/main'})
}])
.controller('ServicesController', ['$scope', "$http", function($scope, $http){
  $http.get("services.json").then(function(response){
    $scope.services = response.data;
  });

}])
.controller('ContactController', ['$scope', function($scope){


}])
.controller('MainController', ['$scope', function($scope){


}]);
