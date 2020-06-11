/**
 * @ngInject
 */
function AuthenticationService($window, Restangular) {
  var service = {};

  service.signin = function () {
    $window.location.href = '/oauth/signin';
  };

  service.currentUser = null;
  service.getCurrentUser = function () {
    return Restangular.one('current-user').get().then(function (data) {
      service.currentUser = data;
      return data;
    }, function () {
      service.currentUser = false;
      return false;
    });
  };

  return service;
}
angular.module("careertwin")
  .factory("AuthenticationService", AuthenticationService);
