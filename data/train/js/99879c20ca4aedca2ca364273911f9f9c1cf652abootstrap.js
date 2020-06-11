var expressController = require('./controllers/express_controller'),
    socketController  = require('./controllers/socket_controller');

/* Express routes */
(function() {
  var controller = new expressController;

  app.express.get('/',        controller.index);
  app.express.get('/message', controller.message);
  app.express.get('/source',  controller.source);
  app.express.get('/edit',    controller.edit);
})();

/* IO routes */
app.io.sockets.on('connection', function (socket) {
  var controller = new socketController(socket);

  socket.on('message',      controller.receiveMessage);
  socket.on('client',       controller.receiveClient);
  socket.on('disconnect',   controller.disconnect);
});