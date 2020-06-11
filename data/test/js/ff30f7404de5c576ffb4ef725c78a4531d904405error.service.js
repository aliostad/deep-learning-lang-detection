(function () {
    'use strict';

    angular
        .module('app.error')
        .factory('errorService', errorService);

    /* @ngInject */
    function errorService(utilityService, errorConstants) {
        var service = {};

        service.unauthorizedAccess = unauthorizedAccess;
        service.uncaughtException = uncaughtException;

        return service;

        function unauthorizedAccess() {
            utilityService.redirectTo(errorConstants.unauthorizedAccessErrorPath);
        }

        function uncaughtException() {
            utilityService.redirectTo(errorConstants.uncaughtExceptionPath);
        }
    }
})();