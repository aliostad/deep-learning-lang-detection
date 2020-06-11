'use strict';

angular.module('angularChatApp')
  .factory('ChatService', function () {
    var service = {};
    service.connect = function(url) {
      if (!service.closed()) {
        console.log('socket already opened.');
        return;
      }
      var ws = new WebSocket(url);
      ws.onopen = function() {
        service.callback('Connected.');
      };
      ws.onclose = function() {
        service.callback('Disconnected.');
      };
      ws.onerror = function(event) {
        console.error(event);
        service.callback('Error');
      };
      ws.onmessage = function(event) {
        console.debug(event.data);
        service.callback(event.data);
      };
      service.ws = ws;
    };
    service.disconnect = function() {
      if (service.ws) {
        service.ws.close();
        delete service.ws;
      }
    };
    service.send = function(message) {
      service.ws.send(message);
    };
    service.subscribe = function (callback) {
      service.callback = callback;
    };
    service.closed = function() {
      return !service.ws || (service.ws && service.ws.readyState === 3);
    };
    return service;
  });
