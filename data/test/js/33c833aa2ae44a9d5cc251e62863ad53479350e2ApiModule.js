/* global define */
(function() {
    'use strict';
    define(['angular', 'services/cluster-svc', 'services/server-svc', 'services/volume-svc', 'services/osd-svc', 'services/pool-svc', 'services/request-svc', 'services/util-svc', 'services/user-svc'], function(angular, ClusterService, ServerService, VolumeService, OSDService, PoolService, RequestService, UtilService, UserService) {
        var moduleName = 'usmAPIModule';
        // This module loads all the USM network API services.
        angular.module(moduleName, ['restangular'])
            .factory('ClusterService', ClusterService)
            .factory('ServerService', ServerService)
            .factory('VolumeService', VolumeService)
            .factory('OSDService', OSDService)
            .factory('PoolService', PoolService)
            .factory('RequestService', RequestService)
            .factory('UtilService', UtilService)
            .factory('UserService', UserService);
        return moduleName;
    });
})();
