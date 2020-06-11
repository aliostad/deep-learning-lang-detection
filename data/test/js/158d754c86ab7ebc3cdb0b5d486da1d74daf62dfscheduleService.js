/*global homeDashboard*/

(function() {
    'use strict';
    var scheduleService = function(restService, utilityService) {
      this.restService = restService;
      this.utilityService = utilityService;
    };

    scheduleService.prototype.getSchedule = function() {
      return this.schedule;
    };

    scheduleService.prototype.loadSchedule = function(email, callback) {
      this.restService.loadSchedule(email)
        .success(function(data) {
          this.schedule = data;
          callback();
        }.bind(this))
        .error(function(){
          window.console.log('Couldn\'t load schedule data.');
      });
    };

    homeDashboard.service('scheduleService', scheduleService);
}());


