var io = require('socket.io');

exports.initialize = function (server) {
    io = io.listen(server);
    io.sockets.on("connection", function (socket) {
        socket.send(JSON.stringify({type:'serverMessage', message:'Welcome to the most interesting chat room'}));
	socket.on("message", function (message) {
	    message = JSON.parse(message);
	    	if (message.type == "userMessage") {
		    socket.broadcast.send(JSON.stringify(message));
		    message.type = "myMessage";
		    socket.send(JSON.stringify(message));
		}	
 	});
    });
};
