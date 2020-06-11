(function() {
    
    'use strict';

    /**
     * @name f1StatsApp.service:notifications.service
     * @description
     * # NotificationsService
     * Shared service for notifications with toaster messages
     */
    angular.module('f1StatsApp')
        .service('NotificationsService', function(toastr) {

            return {
                successMessage,
                errorMessage,
                warning
            };

            function successMessage(message) {
                var successMessage = message || 'Success';
                toastr.success(successMessage);
            }

            function errorMessage(message) {
                var errorMessage = message || 'Error';
                toastr.error(errorMessage);
            }

            function warning(message) {
                var warningMessage = message || 'Warning';
                toastr.warning(warningMessage);
            }

        });

})();
