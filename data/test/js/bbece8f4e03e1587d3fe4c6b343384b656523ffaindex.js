var express = require('express');
var debug = require('debug')('shim:server');
var api = express();
var db = require('./database');

var port = process.env.PORT || 3000;
db.init();

/** Configuration **/


/** Routing **/
var realms = require('./lib/realms'),
  character = require('./lib/character'),
  guild = require('./lib/guild'),
  quest = require('./lib/quests'),
  item = require('./lib/items');

api.get('/api/realms', realms.list);
api.get('/api/pvp/:bracket', character.list);
api.get('/api/character/:realm/:name', character.detail);
api.get('/api/guild/:realm/:name', guild.detail);
api.get('/api/quest/:id', quest.detail);
api.get('/api/item/:itemId', item.detail);

api.get('/api/profiles', character.findAll);
api.get('/api/profiles/:id', character.findById);
api.post('/api/profiles/:name', character.create);
api.put('/api/profiles/:id', character.update);
api.delete('/api/profiles/:id', character.destroy);

api.listen(port);
debug('Listening on %d', port);
