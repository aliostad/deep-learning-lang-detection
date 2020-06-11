var app    =    angular.module('app',[]).config(function($routeProvider){
    $routeProvider.when('/',{
           templateUrl:'login.php',
           controller:'loginController' 
    })  
    $routeProvider.when('/login',{
           templateUrl:'login.php',
           controller:'loginController' 
    })  
    
    $routeProvider.when('/home',{
        templateUrl:'home.php',
        controller:'homeController'
    })
    $routeProvider.when('/gallery',{
        templateUrl:'tpl.html',
        controller:'galleryController'
    })
    $routeProvider.otherwise({
           redirectTo: '/login',
    })
});

app.controller('loginController',function(){
    
})

app.controller('homeController',function(){

})

app.controller('galleryController',function(){
    
})




