(function() {
  'use strict';
  
  angular.module('PDRClient')
      .service('AlertService', AlertService);
  
  function AlertService() {
    var service = this;

    service.alerts = [];

    service.addAlert = function(type, message) {
      service.alerts.push({type: type, message: message});
    };

    service.closeAlert = function(index) {
      service.alerts.splice(index, 1);
    };

    service.getAlerts = function() {
      return service.alerts;
    };

    service.flush = function() {
      service.alerts = [];
    };
  }
})();