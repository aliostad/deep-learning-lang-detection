myApp.factory('wsService', function() {
    var service = {};

    service.connect = function() {
        if(service.ws) { return; }

        var ws = new WebSocket("ws://localhost:1234/client");

        ws.onopen = function() {
            service.callback("Succeeded to open a connection");
        };

        ws.onerror = function() {
            service.callback("Failed to open a connection");
        }

        ws.onmessage = function(message) {
            service.callback(JSON.parse(message.data));
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