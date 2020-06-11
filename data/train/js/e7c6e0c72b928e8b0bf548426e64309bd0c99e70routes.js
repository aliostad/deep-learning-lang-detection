'use strict';

var api = require('./controllers/api');
var index = require('./controllers');

module.exports = function (app) {
  // server API routes
  app.get('/api/rides', api.rides);
  app.get('/api/rides/:id', api.ride);
  app.post('/api/rides', api.createRide);
  app.put('/api/rides/:id', api.updateRide);
  app.delete('/api/rides/:id', api.deleteRide);
  app.get('/api/rides/:id/route', api.route);
  app.post('/api/rides/:id/route', api.uploadRoute);
  app.get('/api/rides/:id/track', api.track);

  // all other routes to use Angular routing in app/scripts/app.js
  app.get('/partials/*', index.partials);
  app.get('/*', index.index);
};
