var api = require('../api');

module.exports = function(server) {
  server.get('/api/switches', api.requestHandler(api.switches.getAll));
  server.get('/api/switches/:id', api.requestHandler(api.switches.get));
  server.post('/api/switches', api.requestHandler(api.switches.add));
  server.put('/api/switches/:id', api.requestHandler(api.switches.edit));
  server.put('/api/switches/turn/:id', api.requestHandler(api.switches.turn));
  server.delete('/api/switches/:id', api.requestHandler(api.switches.delete));
  
}
