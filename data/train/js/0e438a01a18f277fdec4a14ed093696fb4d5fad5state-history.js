(function (undefined) {
  
  'use strict';


  function StateHistoryService(sessionService) {
    this.sessionService = sessionService;
  }

  StateHistoryService.prototype.set = function(key, state) {
    var history, _ref;
    history = (_ref = this.sessionService.stateHistory()) !== null ? _ref : {};
    history[key] = state;
    return this.sessionService.stateHistory(history);
  };

  StateHistoryService.prototype.get = function(key) {
    var _ref;
    return (_ref = this.sessionService.stateHistory()) !== null ? _ref[key] : void 0;
  };

  angular.module('angsturm.services').service(
    'stateHistoryService', [
      
      'sessionService',
      StateHistoryService
    
    ]
  );

}).call(this);