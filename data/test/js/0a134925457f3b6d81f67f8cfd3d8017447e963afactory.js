'use strict';

angular.module("services.factory", []).
  factory('serviceFactory', function($http){
    return {
      addService: function(service) {
        return $http.post('/api/service/', service); 
      },
      getServices: function() {
        return $http.get('/api/service/');
      },
      getService: function(id) {
        return $http.get('/api/service/' + id);
      },
      updateService: function(id, service) {
        return $http.put('/api/service/' + id, service);
      },
      deleteService: function(id) {
        return $http.delete('/api/service/' + id);
      }
    }
  });