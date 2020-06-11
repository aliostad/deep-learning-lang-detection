(function () {
    'use strict';

    angular.module('ClientApp')
        .directive('clientSwitchController', clientSwitchController);

    /**
     * This is the directive for the swicth controller.
     * Use:
     * <client-switch-controller></client-switch-controller>
     * to embed to controller in the html file.
     */

    function clientSwitchController(){
        return {
            restrict: 'E',
            scope: {},
            templateUrl: 'app/client/clientSwitch/client-switch.html',
            controller: 'initSwitchController',
            controllerAs: 'switchCtrl'
        };
    }

})();