'use strict';
define(function(require) {
  var angular = require('angular');
    return angular.module('elicit.controllers', [])
          .controller('ChooseProblemController', require('mcda/controllers/chooseProblem'))
          .controller('WorkspaceController', require('mcda/controllers/workspace'))
          .controller('ScenarioController', require('mcda/controllers/scenario'))
          .controller('OverviewController', require('mcda/controllers/overview'))
          .controller('ScaleRangeController', require('mcda/controllers/scaleRange'))
          .controller('PartialValueFunctionController', require('mcda/controllers/partialValueFunction'))
          .controller('OrdinalSwingController', require('mcda/controllers/ordinalSwing'))
          .controller('IntervalSwingController', require('mcda/controllers/intervalSwing'))
          .controller('ExactSwingController', require('mcda/controllers/exactSwing'))
          .controller('ResultsController', require('mcda/controllers/results'));
});
