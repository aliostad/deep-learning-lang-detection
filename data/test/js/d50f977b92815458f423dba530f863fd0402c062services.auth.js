angular.module('services')
     .service('authService',['config','$http','$state','storageService','notificationService',authService]);

function authService(config,$http,$state,storageService,notificationService) {
  
  var service = {};
  service.login = login;
  service.logout = logout;
  service.postLogout = postLogout;
  return service;

  function login(username,password) {
    return $http(
      {
        'method' : 'POST',
        'url' : config.apiEndPoint + '/login',
        'data' : {
          'username' : username,
          'password' : password
        },
        'headers' : {
          'Content-Type' : 'application/json'
        } 
      }
    );
  }

  function logout() {
    return $http(
      {
        'method' : 'POST',  
        'url' : config.apiEndPoint + '/logout',
        'data' : {
          'token' : storageService.get('token')
        },
        'headers' : {
          'Content-Type' : 'application/json'
        } 
      }
    );
  }

  function postLogout() {
    storageService.clear();
    $state.transitionTo('login');
    notificationService.success('Successfully logged out');
  }
}