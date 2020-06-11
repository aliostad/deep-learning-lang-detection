'use strict';
define(function(require) {
  var angular = require('angular');
  return angular.module('gemtc.services', [])
    .factory('RelativeEffectsTableService', require('gemtc-web/services/relativeEffectsTableService'))
    .factory('DevianceStatisticsService', require('gemtc-web/models/devianceStatisticsService'))
    .factory('ModelService', require('gemtc-web/models/modelService'))
    .factory('RefineModelService', require('gemtc-web/models/refineModelService'))

  .factory('NetworkPlotService', require('gemtc-web/analyses/networkPlotService'))
    .factory('AnalysisService', require('gemtc-web/analyses/analysisService'))
    .factory('DiagnosticsService', require('gemtc-web/services/diagnosticsService'))
    .factory('NodeSplitOverviewService', require('gemtc-web/models/nodeSplitOverviewService'))
    .factory('MetaRegressionService', require('gemtc-web/models/metaRegressionService'));
});
