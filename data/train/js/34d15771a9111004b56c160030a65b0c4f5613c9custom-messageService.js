'use strict';

angular.module('suitApp.home')

.factory('CustomMessageService', ['messageCenterService', function(messageCenterService){
  var self = this;

  self.addMessage = function(type, message) {
    messageCenterService.add(type, message, { status: messageCenterService.status.shown, timeout: 7000 });
  };

  self.addInfoMessage = function(message) {
  	self.addMessage('info', message);
  };

  self.addWarningMessage = function(message) {
  	self.addMessage('warning', message);
  };

  self.addDangerMessage = function(message) {
  	self.addMessage('danger', message);
  };

  self.addSuccessMessage = function(message) {
  	self.addMessage('success', message);
  };

  return {
    message: function(type, message) {
      self.addMessage(type, message);
    },
    dangerMessage: function(message) {
      self.addDangerMessage(message);
    },
    successMessage: function(message) {
      self.addSuccessMessage(message);
    },
    infoMessage: function(message) {
      self.addInfoMessage(message);
    },
    warningMessage: function(message) {
      self.addWarningMessage(message);
    }
  };
}]);