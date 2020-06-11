/*global homeDashboard*/

(function() {
  'use strict';
  var instagramService = function(restService, utilityService) {
    this.restService = restService;
    this.utilityService = utilityService;
  };

  instagramService.prototype.getInstagram = function() {
    return this.instagram;
  };

  instagramService.prototype.loadInstagram = function(callback) {
    this.restService.loadInstagram()
      .success(function(data) {
        this.instagram = data;
        callback();
      }.bind(this))
      .error(function(){
        window.console.log('Couldn\'t load instagram data.');
      });
  };

  homeDashboard.service('instagramService', instagramService);
}());


