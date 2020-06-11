(function () {
    'use strict';

    angular.module('ClientApp')
        .directive('clientBuzzerController', clientBuzzerController);

    /**
     * This is the directive for the buzzer controller.
     * Use:
     * <client-buzzer-controller></client-buzzer-controller>
     * to embed to controller in the html file.
     */

    function clientBuzzerController(){
        return {
            restrict: 'E',
            scope: {},
            templateUrl: 'app/client/clientBuzzer/client-buzzer.html',
            controller: 'initBuzzerController',
            controllerAs: 'buzzerCtrl'
        };
    }

})();