bookies.config(['$routeProvider', function($routeProvider){
  console.log('routes.js running: ' , $routeProvider);
  $routeProvider
    .when("/",{
     templateUrl: '/week.html',
     controller: "scheduleController"
    })
    .when("/day",{
     templateUrl: '/day.html',
     controller: "scheduleController"
    })
    .when("/month",{
     templateUrl: '/month.html',
     controller: "scheduleController"
    })
    .when("/chat",{
      templateUrl: '/chat.html',
      controller: "chatController"
    })
    .when("/adminSettings",{
      templateUrl: '/adminSettings',
      controller: "adminController"
    });

}]);
