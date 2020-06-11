var express = require('express');
var notebook = require('./notebook');

var service = express();

service.use(express.bodyParser());

service.get('/notebooks', notebook.read);
service.post('/notebooks', notebook.create);
service.put('/notebooks/:id', notebook.create);

service.get('/nominals', notebook.read);
service.post('/nominals', notebook.create);
service.put('/nominals/:id', notebook.create);

service.get('/vehicles', notebook.read);
service.post('/vehicles', notebook.create);
service.put('/vehicles/:id', notebook.create);

service.use(express.static(__dirname + '/../../client/'));

service.listen(3000);

console.log('listening on port 3000');