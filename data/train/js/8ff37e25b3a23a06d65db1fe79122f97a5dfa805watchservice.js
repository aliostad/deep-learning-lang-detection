'use strict';

/**
 * @ngdoc service
 * @name angularPlaygroundApp.watchService
 * @description
 * # watchService
 * Service in the angularPlaygroundApp.
 */
angular.module('angularPlaygroundApp')
    .service('Watchservice', function Watchservice($timeout) {
        // AngularJS will instantiate a singleton by calling "new" on this function
        var service = {};
        service.watchProp = 'watch service';
        service.watchArray = [];
        service.watchObj = {
            name: 'duderino'
        };

        service.changeProp = function(change) {
            service.watchProp = change;
            service.watchObj = {
                name: 'truth'
            };

        };

        $timeout(function() {

            // service.watchProp = 'something';

            service.watchArray.push({
                name: 'idan'
            });
            // service.changeProp('watched');

        }, 5000);


        return service;

    });
