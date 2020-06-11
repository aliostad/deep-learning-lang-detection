'use strict';

(function () {

  /* @ngInject */
  function AllArtifactsApi($http, serverApiUrl) {
    var API_URL;

    function httpGET(API_URL) {
      API_URL = serverApiUrl.PREFIX + API_URL;
      return $http.get(API_URL).then(function (response) {
        return response;
      });
    }
    // Public API here
    this.getAllArtifacts = function () {
      API_URL = serverApiUrl.LATEST_ARTIFACTS_API_URI;
      return httpGET(API_URL);
    };

    this.getVersionSummary = function (version, artifactId, groupId, event) {
      API_URL = serverApiUrl.VER_SUM_API_URL_PREFIX + version + '&artifactId=' + artifactId + '&groupId=' + groupId + '&event=' + event;
      return httpGET(API_URL);
    };
  }

  angular
    .module('postplayTryAppInternal')
    .service('allArtifactsApi', AllArtifactsApi);

})();
