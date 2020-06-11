/**
 * Route Mappings
 * (sails.config.routes)
 *
 */

module.exports.routes = {

  '/': {
    view: 'homepage'
  },

  // Config Loader
  'GET /api/config/load/:config_file': {
    controller: 'ConfigController',
    action: 'load'
  },

  // Passport Auth Routes

  'GET /login': {
    controller: 'AuthController',
    action: 'login'
  },
  'GET /logout': {
    controller: 'AuthController',
    action: 'logout'
  },
  'GET /register': {
    controller: 'AuthController',
    action: 'register'
  },

  'POST /auth/local': {
    controller: 'AuthController',
    action: 'callback'
  },
  'POST /auth/local/:action': {
    controller: 'AuthController',
    action: 'callback'
  },

  'GET /auth/:provider': {
    controller: 'AuthController',
    action: 'provider'
  },
  'GET /auth/:provider/callback': {
    controller: 'AuthController',
    action: 'callback'
  },
  'GET /auth/:provider/:action': {
    controller: 'AuthController',
    action: 'callback'
  },

};
