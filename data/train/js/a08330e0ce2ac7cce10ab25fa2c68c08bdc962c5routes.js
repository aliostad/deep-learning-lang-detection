'use strict';

var api = require('./controllers/api'),
    index = require('./controllers');

/**
 * Application routes
 */
module.exports = function(app) {

  // Server API Routes
  app.get('/api/awesomeThings', api.awesomeThings);
  app.get('/api/issue', api.issues);
  app.post('/api/issue', api.createIssue);
  app.put('/api/issue', api.updateIssue);
  app.post('/api/vote', api.vote);
  app.put('/api/proposal', api.updateProposal);
  app.post('/api/proposal', api.proposal);
  app.get('/api/reports/ranking', api.rankedVotes);

  // All undefined api routes should return a 404
  app.get('/api/*', function(req, res) {
    res.send(404);
  });

  // All other routes to use Angular routing in app/scripts/app.js
  app.get('/partials/*', index.partials);
  app.get('/*', index.index);
};