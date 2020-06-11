angular.module('flapperNews')

.service('UserSession', ['Auth', 
  function(Auth) {
    var service = {};

    service.auth = Auth;
    service.signedIn = Auth.isAuthenticated;
    service.logout = Auth.logout;

    Auth.currentUser()
    .then(function(user) {
      service.user = user;
    })
    .catch(function() {
    });

    service.login = function(user) {
      return Auth.login(user).then(function(response) {
        service.user = response;
      });
    }

    service.register = function(user) {
      return Auth.register(user).then(function(response) {
        service.user = response;
      });
    }
    
    service.logout = function(user) {
      return Auth.logout(user).then(function() {
        service.user = null;
      });
    }

    return service;
  }]);