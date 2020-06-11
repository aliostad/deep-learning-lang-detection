
var _ = require('lodash');

var fileServer = require('./servers/FileServer');
fileServer.on('error', function (error) {
    console.log(error);
});
fileServer.listen(8080);

var OctreeController = require('./controllers/OctreeController');
var SocketController = require('./servers/SocketServer');
var ClientController = require('./controllers/ClientController');

var octreeController = new OctreeController(new SocketController(fileServer, function (socket) {
    var clientController = new ClientController(socket);
    clientController.Reemit('insertValue', octreeController);
    clientController.Reemit('query', octreeController);

    octreeController.emit('newClient', socket);
}));
