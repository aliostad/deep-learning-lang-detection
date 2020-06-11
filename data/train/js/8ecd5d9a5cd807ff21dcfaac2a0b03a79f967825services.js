/**
 * services.
 * @file services.js.
 * @copyright Copyright ©
 */
define(
    [
        'angular',
        'admin/sales/services/adminSalesService',
        'admin/sales/services/adminSalesApiService',
        'admin/sales/services/adminSalesApiMappingService',
        'admin/sales/services/adminSalesCardReaderService',
        'admin/sales/services/adminSalesQueueApiService',
        'admin/sales/services/adminSalesDateWatcherService'
    ],
    function (angular, adminSalesService, adminSalesApiService, adminSalesApiMappingService, adminSalesCardReaderService, adminSalesQueueApiService, adminSalesDateWatcherService) {
        'use strict';

        var dependencies = [];
        var services = angular.module('lunchtime.admin.sales.services', dependencies);
        services.service('adminSalesService', adminSalesService);
        services.service('adminSalesApiService', adminSalesApiService);
        services.service('adminSalesApiMappingService', adminSalesApiMappingService);
        services.service('adminSalesCardReaderService', adminSalesCardReaderService);
        services.service('adminSalesQueueApiService', adminSalesQueueApiService);
        services.service('adminSalesDateWatcherService', adminSalesDateWatcherService);

        return services;
    });