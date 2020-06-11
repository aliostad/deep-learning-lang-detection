(function() {
    'use strict';

    angular.module('app')
        .controller('AbsController', [AbsController])
        .directive('debts', function() {
            return {
                templateUrl: 'components/debts.html',
                restrict: 'A',
                scope: {
                    debts: '='
                },
                controller: 'AbsController',
                controllerAs: 'Math'
            };
        });

    function AbsController() {
        var vm = this;

        vm.abs = Math.abs;
    }
})();