"use strict";

/**
 * The main controller
 *
 * @module Client
 * @class MainController
 */

function MainController($scope, config) {
  $scope.testName = config.test;
}

MainController.controllerName = "MainController";

/**
 * Builds a controller function
 *
 * @method build
 * @param config {Object} the configuration to use
 * @return {Function} Controller function
 */
var build = function(config) {
  return function($scope) {
    return new MainController($scope, config);
  };
};

var register = function(module, config) {
  module.controller(MainController.controllerName, ["$scope", build(config)]);
};

var controller = {
  Constructor: MainController,
  register: register
};

module.exports = controller;
