'use strict';

var angular = require('angular');
var RoutingConfig = require('./config');
var LoginController = require('./controller/LoginController');
var RegistrationController = require('./controller/RegistrationController');
var ConfirmController = require('./controller/ConfirmController');
var Security = require('./service/Security');
var RouteChecker = require('./service/RouteChecker');

module.exports = angular
  .module('security', [])
  .controller('LoginController', LoginController)
  .controller('RegistrationController', RegistrationController)
  .controller('ConfirmController', ConfirmController)
  .factory('Security', Security)
  .config(function ($stateProvider, $translatePartialLoaderProvider) {
    angular.forEach(RoutingConfig, function (config, name) {
      $stateProvider.state(name, config);
    });
    $translatePartialLoaderProvider.addPart('security');
  })
  .run(RouteChecker);

