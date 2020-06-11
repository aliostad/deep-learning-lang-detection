require(['application'], function (application) {
  application.controller('ApiController', [
    '$rootScope', '$scope', '$http',
    function ($rootScope, $scope, $http) {
      function loadApiTokens() {
        $http.get('/api/api_tokens')
          .success(function (response) {
            $scope.apiTokens = response.api_tokens;
          });
      }

      $rootScope.bodyClass = 'api_tokens';
      $scope.hideSidebar();

      $scope.newApiToken = {};
      $scope.saveApiToken = function () {
        $scope.savingApiToken = true;
        $http.post('/api/api_tokens', { model: $scope.newApiToken })
          .success(function () {
            loadApiTokens();
            $scope.savingApiToken = false;
          })
          .error(function () {
            $scope.savingApiToken = false;
          });
      };

      $scope.deleteApiToken = function (token) {
        if (!confirm('Are you sure?')) { return; }
        $http['delete']('/api/api_tokens/' + token.id)
          .success(function () {
            loadApiTokens();
          });
      };

      loadApiTokens();
    }
  ]);
});
