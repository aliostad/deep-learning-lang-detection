/* messageService */

angular.module('webapp.services')
    .service('service.message', ['$log',
        function($log) {

            /*
             * Private methods
             */
            var timeSpan = 4000;
            /* 
             * Service
             */
            return {
                info: function(message) {
                    $log.info(message);
                    Materialize.toast(message, timeSpan);
                },
                warn: function(message) {
                    $log.warn(message);
                    Materialize.toast(message, timeSpan);
                },
                error: function(message) {
                    $log.error(message);
                    Materialize.toast(message, timeSpan);
                },
                debug: function(message) {
                    $log.debug(message);
                    Materialize.toast(message, timeSpan);
                }

            };

        }
    ]);
