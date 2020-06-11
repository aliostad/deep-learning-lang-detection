/**
 * Main application routes
 */

'use strict';

var errors = require('./components/errors');
var path = require('path');

module.exports = function(app) {

  // Insert routes below
  app.use('/api/things', require('./api/thing'));
  app.use('/api/aFash', require('./api/aFash'));
  app.use('/api/bFash', require('./api/bFash'));
  app.use('/api/cFash', require('./api/cFash'));
  app.use('/api/mesurment', require('./api/mesurment'));
  app.use('/api/plant', require('./api/plant'));
  app.use('/api/sort', require('./api/sort'));
  app.use('/api/machine', require('./api/machine'));
  app.use('/api/marketer', require('./api/marketer'));
  app.use('/api/raw', require('./api/raw'));
  app.use('/api/store', require('./api/store'));
  app.use('/api/parapono', require('./api/parapono'));
  app.use('/api/evaluation', require('./api/evaluation'));
  app.use('/api/menu', require('./api/menu'));
  app.use('/api/techInfo', require('./api/techInfo'));
  app.use('/api/worker', require('./api/worker'));
  app.use('/api/advice', require('./api/advice'));
  app.use('/api/calories', require('./api/calories'));
  app.use('/api/GDA', require('./api/GDA'));
  app.use('/api/switchboard', require('./api/switchboard'));
  app.use('/api/dromologio', require('./api/dromologio'));
  app.use('/api/generalDamage', require('./api/generalDamage'));
  app.use('/api/label', require('./api/label'));
  app.use('/api/prodDate', require('./api/prodDate'));
  app.use('/api/prodProcudeurs', require('./api/prodProcudeurs'));
  app.use('/api/program', require('./api/program'));
  app.use('/api/WP', require('./api/WP'));
  app.use('/api/year', require('./api/year'));

  // All undefined asset or api routes should return a 404
  app.route('/:url(api|auth|components|app|bower_components|assets)/*')
   .get(errors[404]);

  // All other routes should redirect to the index.html
  app.route('/*')
    .get(function(req, res) {
      res.sendFile(path.resolve(app.get('appPath') + '/index.html'));
    });
};
