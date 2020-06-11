(function() {
    'use strict';
    angular.module('module.service').factory('$resourceService', $resourceService);

    $resourceService.$inject = ['$resource', 'resourceServiceConfig'];

    function $resourceService($resource, resourceServiceConfig) {
        return {
            request: request
        }

        function request(url) {
            return $resource(
                resourceServiceConfig.remoteURL + resourceServiceConfig[url].url,
                resourceServiceConfig[url].params,
                resourceServiceConfig[url].actions,
                resourceServiceConfig[url].options
            );
        }
    }

})();
