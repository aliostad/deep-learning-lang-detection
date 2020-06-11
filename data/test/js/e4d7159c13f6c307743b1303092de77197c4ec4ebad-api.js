'use strict';

(function () {

  /* @ngInject */
  function badApiFactory($resource) {
    function BadApi() {
    }

    BadApi.prototype.getResource1 = function () {
      return $resource('/some/path/1');
    };

    BadApi.prototype.getResource2 = function () {
      return $resource('/some/path/2');
    };

    var badApi = {};

    // Public API here
    badApi.create = function () {
      return new BadApi();
    };

    return badApi;
  }

  angular
    .module('contactsRetrospectiveAppInternal')
    .factory('badApi', badApiFactory);

})();
