'use strict';

var angular = require('angular');
var RoutingConfig = require('./config');
var TemplateListController = require('./controller/TemplateListController');
var TemplateDetailController = require('./controller/TemplateDetailController');
var TemplateUrlController = require('./controller/TemplateUrlController');
var Template = require('./service/Template');

module.exports = angular
  .module('template', [])
  .controller('TemplateListController', TemplateListController)
  .controller('TemplateDetailController', TemplateDetailController)
  .controller('TemplateUrlController', TemplateUrlController)
  .factory('Template', Template)
  .config(function ($stateProvider, $translatePartialLoaderProvider) {
    angular.forEach(RoutingConfig, function (config, name) {
      $stateProvider.state(name, config);
    });
    $translatePartialLoaderProvider.addPart('template');
  });
