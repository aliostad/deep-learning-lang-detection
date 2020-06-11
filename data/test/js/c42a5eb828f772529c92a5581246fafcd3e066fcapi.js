angular.module('app').factory('api', [
          '$http', 'path', 
  function($http, path) {
    var api = {};
    var token = null;

    api.get = function(uri) {
      return $http.get(uri);
    };

    api.post = function(uri, data) {
      return $http.post(uri, JSON.stringify(data));
    };

    api.init = function() {
      return api.get(path.api.route.init());
    };

    api.logout = function() {
      return api.get(path.api.route.logout());
    };

    api.login = function(id, password) {
      return api.post(path.api.route.login(), {id: id, password: password});
    };

    return api;
}]);