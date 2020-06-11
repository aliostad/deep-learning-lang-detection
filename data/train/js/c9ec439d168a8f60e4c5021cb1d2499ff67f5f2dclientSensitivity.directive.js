(function () {
    'use strict';

    angular.module('ClientApp')
        .directive('clientSensitivityController', clientSensitivityController);

    /**
     * This is the directive for the sensitivity controller.
     * Use:
     * <client-sensitivity-controller></client-sensitivity-controller>
     * to embed to controller in the html file.
     */

    function clientSensitivityController(){
        return {
            restrict: 'E',
            scope: {},
            templateUrl: 'app/client/clientSensitivity/client-sensitivity.html',
            controller: 'initSensitivityController',
            controllerAs: 'sensitivityCtrl'
        };
    }

})();