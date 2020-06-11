'use strict';

module.exports = function(socket, client) {

  socket.on('connect', function() {
    client.add();
    client.registerAsListener();
    client.emittSubscribed();
  });

  socket.on('disconnect', function() {

  });

  socket.on('new service', function(service) {
    client.emit('new service', service);
  });

  socket.on('register of service', function(service) {
    client.service = service;
  });

  socket.on('service subscribed', function(service, alias) {
    client.registerServiceSubscribed(service, alias);
  });

};
