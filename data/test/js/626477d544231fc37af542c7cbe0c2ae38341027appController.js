angular.module('app').controller('AppController', [
    '$scope',
    '$http',
    'api',
    function($scope, $http, api) {
        $scope.options = {
            apiUrl: 'http://petstore.swagger.wordnik.com/api/api-docs',
            apiName: 'Petstore'
        };

        $scope.discover = function(apiUrl, apiKey) {
            apiUrl += apiKey ? '?api_key=' + apiKey : '';
            $http.get(apiUrl).then(
                function(response) {
                    $scope.discovered = response.data;
                },
                function(error) {
                    $scope.discovered = error;
                }
            );
        };

        $scope.process = function(options) {
            api.postProcessorJob({
                options: options
            });
        };
    }
]);