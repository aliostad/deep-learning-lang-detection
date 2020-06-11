angular
  .module('TrackServiceFactoryModule', ['HTTPTrackService', 'config'])
  .service(['TrackServiceFactory'], ['HTTPTrackService', 'config', function(HTTPTrackService){

  }]);


define(['HTTPTrackService'], function(HTTPTrackService, TrackService){
  function TrackServiceFactory(config) {
    var serviceType = config.trackServiceType;
    if (serviceType === 'HTTP') {
      this.service = new HTTPTrackService(config.domain);
    } 
  }
  TrackServiceFactor.prototype.getTrackService = function() {
    return this.service;
  }
});

var trackService = new TrackServiceFactory(config);
var trackService = TrackServiceFactory.getTrackService();