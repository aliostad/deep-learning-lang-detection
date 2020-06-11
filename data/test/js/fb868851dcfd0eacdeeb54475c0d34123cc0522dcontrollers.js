angular.module('HRP')

//Controller for nav bar
.controller('LinksController',['$scope', function(scope){
  scope.nav = [
    { name: 'home', title: 'Home' },
    { name:'addproject', title: 'Add Project' },
    { name:'myprojects', title:'My Projects' },
    { name:'interested', title: 'Tracked Projects' }
  ];
}])

//Controller for home state
.controller('HomeController',['$scope', function(scope){}])

//Controller for addproject state
.controller('AddController',['$scope', function(scope){}])

//Controller for myprojects state
.controller('MyController',['$scope', function(scope){}])

//Controller for interested state
.controller('IntController',['$scope', function(scope){}])

//Controller for login and authentication
.controller('AuthController',['$scope', 'Auth', function(scope, Auth){
  scope.authGoogle = function(){
    Auth.google()
      .success(function(){
        console.log('success');
      })
      .error(function(){
        console.log('failure');
      });
  };

  scope.authGithub = function(){
    console.log('success');
  }
}]);