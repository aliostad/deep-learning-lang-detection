/**
 * services.
 * @file services.js.
 * @copyright Copyright ©
 */
define([
        'angular',
        'common/services/categoryService',
        'common/services/menuService',
        'common/services/commonApiMappingService'
    ],
    function (angular, categoryService, menuService, commonApiMappingService) {
        'use strict';

        var dependencies = [];
        var services = angular.module('lunchtime.common.services', dependencies);
        services.service('categoryService', categoryService);
        services.service('menuService', menuService);
        services.service('commonApiMappingService', commonApiMappingService);

        return services;
    });