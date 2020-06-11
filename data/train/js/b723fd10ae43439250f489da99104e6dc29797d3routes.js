'use strict';

var api = require('./controllers/api'),
    index = require('./controllers');

/**
 * Application routes
 */
module.exports = function(app) {

  // Server API Routes
  app.get('/api/strengths', api.strengths);
  app.get('/api/people', api.people);
  app.post('/api/people', api.updatePerson);
  app.get('/api/getUser', api.getUser);
  app.get('/api/dump', api.dump);

  // All other routes to use Angular routing in app/scripts/app.js
  app.get('/partials/*', index.partials);
  app.get('/*', index.index);
};