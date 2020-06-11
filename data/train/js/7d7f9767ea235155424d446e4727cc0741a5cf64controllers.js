'use strict';
define(function(require) {
  var angular = require('angular');
    return angular.module('elicit.controllers', [])
          .controller('ChooseProblemController', require('controllers/chooseProblem'))
          .controller('WorkspaceController', require('controllers/workspace'))
          .controller('OverviewController', require('controllers/overview'))
          .controller('ResultsController', require('controllers/results'))
          .controller('TransitionProbabilitiesController', require('controllers/transitionProbabilities'))
          .controller('AccountCostsController', require('controllers/accountCosts'))
          .controller('AccountEffectsController', require('controllers/accountEffects'))
          .controller('DiseaseStatesController', require('controllers/diseaseStates'))
          .controller('SimulationParametersController', require('controllers/simulationParameters'));
});