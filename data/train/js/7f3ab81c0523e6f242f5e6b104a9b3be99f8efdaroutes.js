'use strict';

var customerApi = require('./controllers/customerApi'),
    index = require('./controllers'),
    usersApi = require('./controllers/usersApi'),
    commentApi = require('./controllers/commentApi'),
    employeeApi = require('./controllers/employeeApi'),
    session = require('./controllers/session'),
    middleware = require('./middleware'),
    serviceApi = require('./controllers/serviceApi'),
    fs = require('fs');

/**
 * Application routes
 */
module.exports = function(app) {

  // Server API Routes
  app.route('/api/customers')
    .get(customerApi.all)
    .post(customerApi.add);

  app.route('/api/customers/:id')
    .get(customerApi.get)
    .put(customerApi.update);

  app.route('/api/comments')
    .post(commentApi.add);

  app.route('/api/services')
    .get(serviceApi.all)
    .post(serviceApi.add);

  app.route('/api/services/:id')
    .get(serviceApi.get);

  app.route('/api/employees')
    .post(employeeApi.add);

  app.route('/api/employees/:id')
    .delete(employeeApi.remove)
    .post(employeeApi.update);

  app.route('/api/users')
    .get(usersApi.all)
    .post(usersApi.create)
    .put(usersApi.changePassword);

  app.route('/api/users/me')
    .get(usersApi.me);

  app.route('/api/users/:id')
    .delete(usersApi.remove)
    .put(usersApi.update)
    .post(usersApi.resetPassword)
    .get(usersApi.show);

  app.route('/api/session')
    .post(session.login)
    .delete(session.logout);

  // All undefined api routes should return a 404
  app.route('/api/*').get(function(req, res) {
    res.send(404);
  });


  // All other routes to use Angular routing in app/scripts/app.js
  app.route('/partials/*')
    .get(index.partials);
  app.route('/*')
    .get( middleware.setUserCookie, index.index);
};