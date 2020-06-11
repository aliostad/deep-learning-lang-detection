var WebSocketServer = require('ws').Server,
    wss = new WebSocketServer({ port: 8080 });

wss.on('connection', function connection(ws) {

    ws.on('message', function(messageString) {

        var message = JSON.parse(messageString),
            incomingMessage = message.data.message;

        console.log('message received: ', message);

        broadcastNewMessage(incomingMessage);
    });

    function broadcastNewMessage(message) {
        wss.clients.forEach(function each(client) {

            var response = JSON.stringify({ event: 'newMessage', data: message });

            console.log('broadcasting message: ', response);

            client.send(response);
        });
    }
});
