define([
  'config',
  'angular',
  'lodash',
  'routes'
], function (cfg, A, _) {
  var app,
      controller;

  controller = (function () {
    AppController.$inject = [
      '$scope',
      '$rootScope'
    ];

    function AppController (
      $scope,
      $rootScope
    ) {
      this.$scope = $scope;
      this.$rootScope = $rootScope;
      this.init();
    }

    AppController.prototype.init = function () {
      this.addScopeMethods();
    };

    AppController.prototype.addScopeMethods = function () {
    };

    return AppController;
  })();

  app = A.module(cfg.ngApp);
  app.controller('appController', controller);
});