(function () {

  'use strict';

  angular
  .module('theme.core.services')
  .factory('DispatchService', DispatchService)

  DispatchService.$inject = [ '$http', '$rootScope', 'shamanConfiguration', 'UtilsService', '$log'];
  /* jshint ignore:start */
  function DispatchService($http, $rootScope, shamanConfiguration, UtilsService, $log) {

    function getDispatchPopupInformation(id, dispatch) {
      var sel = dispatch.dispatchingOptionSelected.id;
      var grade = dispatch.incident.grade;
      var loc = dispatch.incident.locality;
      return UtilsService.getPromise('api/travelincidents/getdespachopopupinformation?id=' + id +
      '&psel=' + sel +
      '&grade=' + grade +
      '&loc=' + loc);
    }

    function dispatch(dispatchData, isDispatching) {

      // --> Para optimizar tiempo ahora, uso lo mismo para Despachar
      // --> y preasignar, con esta flag veo que estoy haciendo.

      var travelIncidentVm = {
        id           : dispatchData.incident.travelIncidentId,
        incidentId   : dispatchData.incident.id,
        selectedView : dispatchData.dispatchingOptionSelected,
        movAptoGrado : dispatchData.incident.movAptoGrado,
        movZona      : dispatchData.incident.movZona,
        mobile       : dispatchData.bottomPanelFirstField,
        mobileType   : dispatchData.bottomPanelSecondField,
        state        : dispatchData.bottomPanelThirdField

      };

      if (isDispatching) {
        return $http({
          method : 'POST',
          url : shamanConfiguration.url +
          'api/travelincidents/dispatch',
          data: $.param(travelIncidentVm)
        });
      } else {
        return $http({
          method : 'POST',
          url : shamanConfiguration.url +
          'api/travelincidents/preasign',
          data: $.param(travelIncidentVm)
        });
      }



    }

    var service = {
      getDispatchPopupInformation : getDispatchPopupInformation,
      dispatch                    : dispatch

    };

    return service;

  }

})();
