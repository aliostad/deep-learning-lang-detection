var app = angular.module('app', []);
 
app.factory('ChatService', function() {
  var service = {};
 
  service.connect = function() {
    if(service.ws) { return; }
 
    var ws = new WebSocket("ws://localhost:8000/socket/");
 
    ws.onopen = function() {
      service.callback("Succeeded to open a connection");
    };
 
    ws.onerror = function() {
      service.callback("Failed to open a connection");
    }
 
    ws.onmessage = function(message) {
      service.callback(message.data);
    };
 
    service.ws = ws;
  }
 
  service.send = function(message) {
    service.ws.send(message);
  }
 
  service.subscribe = function(callback) {
    service.callback = callback;
  }
 
  return service;
});
 
 
function AppCtrl($scope, ChatService) {
  $scope.messages = [];
 
  ChatService.subscribe(function(message) {
    $scope.messages.push(message);
    $scope.$apply();
  });
 
  $scope.connect = function() {
    ChatService.connect();
  }
 
  $scope.send = function() {
    ChatService.send($scope.text);
    $scope.text = "";
  }
}