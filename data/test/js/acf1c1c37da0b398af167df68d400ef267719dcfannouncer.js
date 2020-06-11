var services = require('./services.js'),
	sockets = require('./sockets');

function distance(a, b) {
	return Math.sqrt(Math.pow(b[0] - a[0], 2) + Math.pow(b[1] - a[1], 2));
}

function contains(service, client) {
	return distance([service.x, service.y], [client.x, client.y]) < service.range;
}

function reposition(client) {
	services.forEach(function each(service) {
		var client_has_service = client.services.indexOf(service) !== -1;
		if (contains(service, client)) {
			if (!client_has_service) {
				client.services.push(service);
				client.socket.send(JSON.stringify({
					address: 'announce',
					id: service.id,
					x: service.x,
					y: service.y,
					host: service.host || 'localhost',
					port: service.port
				}));
			}
		} else {
			if (client_has_service) {
				client.services.splice(client.services.indexOf(service), 1);
				client.socket.send(JSON.stringify({
					address: 'unannounce',
					id: service.id
				}));
			}
		}
	});
}


sockets.on('reposition', reposition);
