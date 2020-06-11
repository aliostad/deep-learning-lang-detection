var app = angular.module('myApp', ['ngRoute'])

.config(function($routeProvider){
    $routeProvider.when('/',{
        controller: 'homeController',
        templateUrl: 'template/home.html'
    }).when('/about',{
        controller: 'aboutController',
        templateUrl: 'template/about.html'
    }).when('/why',{
        controller: 'whyController',
        templateUrl: 'template/why.html'
    })
})

app.controller('homeController', ['$scope',function($scope){
    
    
    
}])

app.controller('aboutController',['$scope', function($scope){
    
}])

app.controller('whyController', ['$scope', function($scope){
    
}])