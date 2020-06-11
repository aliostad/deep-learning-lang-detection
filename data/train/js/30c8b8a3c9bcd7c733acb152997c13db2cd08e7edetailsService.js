'use strict';

angular
  .module('app')
  .service('DetailsService', DetailsService);

  DetailsService.$inject = [];

  function DetailsService() {
    var service = this;
    console.log("Here's ya song");
    service.showingDetails = false;

    service.showDetails = function(song) {
      console.log("Showing Song!");
      service.showingDetails = true;
    }

    service.hideDetails = function() {
      service.showingDetails = true;
    }

    service.getDetailsStatus = function() {
      return service.showingDetails;
    }

    console.log("Serviec doing stuff");

  };