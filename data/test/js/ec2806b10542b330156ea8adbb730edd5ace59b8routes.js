/**
 * Main application routes
 */

'use strict';

var errors = require('./components/errors');

module.exports = function(app) {

  // Insert routes below
  app.use('/api/easyposts', require('./api/easypost'));
  app.use('/api/chats', require('./api/chat'));
  app.use('/api/address', require('./api/address'));
  app.use('/api/conditions', require('./api/condition'));
  app.use('/api/categorys', require('./api/category'));
  app.use('/api/brands', require('./api/brand'));
  app.use('/api/products', require('./api/product'));
  app.use('/api/likes', require('./api/like'));
  app.use('/api/reviews', require('./api/review'));
  app.use('/api/orders', require('./api/order'));
  app.use('/api/things', require('./api/thing'));
  app.use('/api/users', require('./api/user'));

  app.use('/auth', require('./auth'));
  
  // All undefined asset or api routes should return a 404
  app.route('/:url(api|auth|components|app|bower_components|assets)/*')
   .get(errors[404]);

  // All other routes should redirect to the index.html
  app.route('/*')
    .get(function(req, res) {
      res.sendfile(app.get('appPath') + '/index.html');
    });
};
