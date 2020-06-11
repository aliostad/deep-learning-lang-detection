angular.module('app').service('AdviceViewService', [
  'ConstantsService', 'ChartService',
  function(constantsService, chartService) {

    return {
      getAdvices: function() {
        return constantsService.getAdvices();
      },
      mouseOver: function(nodeName) {
        chartService.mouseOver(nodeName);
      },
      mouseOut: function(nodeName) {
        chartService.mouseOut(nodeName);
      },
      mouseClick: function(nodeName) {
        chartService.mouseClick(nodeName);
      }
    };
  }
]);