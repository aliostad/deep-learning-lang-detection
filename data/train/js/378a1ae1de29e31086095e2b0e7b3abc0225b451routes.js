/**
 * Main application routes
 */

'use strict';

var errors = require('./components/errors');

module.exports = function(app) {

  // Insert routes below
  app.use('/api/invoices', require('./api/invoice'));
  app.use('/api/workOrders', require('./api/workOrder'));
  app.use('/api/bids', require('./api/bid'));
  app.use('/api/taskCats', require('./api/taskCat'));
  app.use('/api/productCats', require('./api/productCat'));
  app.use('/api/ratings', require('./api/rating'));
  app.use('/api/comments', require('./api/comment'));
  app.use('/api/tasks', require('./api/task'));
  app.use('/api/sizes', require('./api/size'));
  app.use('/api/tools', require('./api/tool'));
  app.use('/api/features', require('./api/feature'));
  app.use('/api/themes', require('./api/theme'));
  app.use('/api/colors', require('./api/color'));
  app.use('/api/patterns', require('./api/pattern'));
  app.use('/api/products', require('./api/product'));
  app.use('/api/roles', require('./api/role'));
  app.use('/api/sites', require('./api/site'));
  app.use('/api/styles', require('./api/style'));
  app.use('/api/themes', require('./api/theme'));
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
