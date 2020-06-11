/**
 * Main application routes
 */

'use strict';

var errors = require('./components/errors');
var path = require('path');

module.exports = function(app) {

  // Insert routes below
  app.use('/api/dashboard', require('./api/dashboard'));
  app.use('/api/ec8', require('./api/ec8'));
  app.use('/api/ec7', require('./api/ec7'));
  app.use('/api/ec6', require('./api/ec6'));
  app.use('/api/ec5', require('./api/ec5'));
  app.use('/api/ec4', require('./api/ec4'));
  app.use('/api/ec3', require('./api/ec3'));
  app.use('/api/ec2', require('./api/ec2'));
  app.use('/api/ec19', require('./api/ec19'));
  app.use('/api/ec18', require('./api/ec18'));
  app.use('/api/ec17', require('./api/ec17'));
  app.use('/api/ec14', require('./api/ec14'));
  app.use('/api/ec13', require('./api/ec13'));
  app.use('/api/ec11', require('./api/ec11'));
  app.use('/api/ec10', require('./api/ec10'));
  app.use('/api/ec1', require('./api/ec1'));
  app.use('/api/en9', require('./api/en9'));
  app.use('/api/en8', require('./api/en8'));
  app.use('/api/en7', require('./api/en7'));
  app.use('/api/en6', require('./api/en6'));
  app.use('/api/en5', require('./api/en5'));
  app.use('/api/en4_9', require('./api/en4_9'));
  app.use('/api/en4', require('./api/en4'));
  app.use('/api/en3', require('./api/en3'));
  app.use('/api/en2', require('./api/en2'));
  app.use('/api/en11', require('./api/en11'));
  app.use('/api/en10', require('./api/en10'));
  app.use('/api/en1', require('./api/en1'));
  app.use('/api/lu5', require('./api/lu5'));
  app.use('/api/lu4', require('./api/lu4'));
  app.use('/api/lu3', require('./api/lu3'));
  app.use('/api/lu2', require('./api/lu2'));
  app.use('/api/lu1', require('./api/lu1'));
  app.use('/api/t19', require('./api/t19'));
  app.use('/api/t18', require('./api/t18'));
  app.use('/api/t17', require('./api/t17'));
  app.use('/api/t16', require('./api/t16'));
  app.use('/api/t5', require('./api/t5'));
  app.use('/api/t4', require('./api/t4'));
  app.use('/api/t2', require('./api/t2'));
  app.use('/api/geo', require('./api/geo'));
  app.use('/api/t3', require('./api/t3'));
  app.use('/api/t13', require('./api/t13'));
  app.use('/api/t12', require('./api/t12'));
  app.use('/api/t11', require('./api/t11'));
  app.use('/api/t1', require('./api/t1'));
  app.use('/api/t15', require('./api/t15'));
  app.use('/api/t14', require('./api/t14'));
  app.use('/api/t9', require('./api/t9'));
  app.use('/api/t8', require('./api/t8'));
  app.use('/api/t7', require('./api/t7'));
  app.use('/api/t6', require('./api/t6'));
  
  // All undefined asset or api routes should return a 404
  app.route('/:url(api|auth|components|app|bower_components|assets)/*')
   .get(errors[404]);

  // All other routes should redirect to the index.html
  app.route('/*')
    .get(function(req, res) {
      res.sendFile(path.resolve(app.get('appPath') + '/index.html'));
    });
};
