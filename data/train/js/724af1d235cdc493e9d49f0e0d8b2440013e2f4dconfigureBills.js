(function () {
  'use strict';

  var controllerId = 'ConfigureBillsController';

  angular
    .module('configureBillsModule', [
      'addBillsModule',
      'editBillsModule'
    ])
    .controller(controllerId, ConfigureBillsController)
    .directive('configureBills', function () {
      return {
        restrict: 'E',
        controller: controllerId,
        controllerAs: 'vm',
        templateUrl: 'app/configureBills/configureBills.html',
        bindToController: true,
        scope: {}
      };
    });

  ConfigureBillsController.$inject = [];

  function ConfigureBillsController () {
  }
})();
