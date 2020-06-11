/**
* Created by César Moreno
*/

(function(){
  'use strict';

  angular
    .module('app.core')
    .factory('apiConfigService', apiConfigService);

  apiConfigService.$inject = ['$http', '$q'];

  function apiConfigService($http, $q) {
  	var service = {
      apiConfiguration: apiConfiguration
    }
    
    return service;

    function apiConfiguration () {
      return $http({
        method: 'GET',
        url: configUrl.apiUrl + 'configuration',
        params: {
          api_key: configUrl.apiKey
        }
      });
    }

  }
})();
  