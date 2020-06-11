/**
 * services.
 * @file services.js.
 * @copyright Copyright ©
 */
define([
        'angular', 'angular-resource', 'core/core', 'common/common',
        'user/menu/services/userMenuService',
        'user/menu/services/orderService',
        'user/menu/services/userMenuApiService',
        'user/menu/services/userMenuApiMappingService',
        'user/menu/services/boxCapacityService'
    ],
    function(angular, ngResource, core, common, userMenuService, orderService, userMenuApiService, userMenuApiMappingService, boxCapacityService) {
        'use strict';

        var dependencies = [
            'ngResource',
            core.name,
            common.name
        ];

        var services = angular.module('lunchtime.user.menu.services', dependencies);
        services.service('userMenuService', userMenuService);
        services.service('orderService', orderService);
        services.service('userMenuApiService', userMenuApiService);
        services.service('userMenuApiMappingService', userMenuApiMappingService);
        services.service('boxCapacityService', boxCapacityService);

        return services;
    });