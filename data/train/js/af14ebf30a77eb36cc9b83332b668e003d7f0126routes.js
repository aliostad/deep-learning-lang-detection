/**
 * Main application routes
 */

'use strict';

var errors = require('./components/errors');
var path = require('path');
var express = require('express');
var router = express.Router();
var controller = require('./api/message/message.controller');

module.exports = function(app) {
  // Insert routes below
  app.use('/api/vikings', require('./api/viking'));
  app.use('/api/titans', require('./api/titan'));
  app.use('/api/texans', require('./api/texan'));
  app.use('/api/steelers', require('./api/steeler'));
  app.use('/api/seahawks', require('./api/seahawk'));
  app.use('/api/saints', require('./api/saint'));
  app.use('/api/redskins', require('./api/redskin'));
  app.use('/api/ravens', require('./api/raven'));
  app.use('/api/rams', require('./api/ram'));
  app.use('/api/raiders', require('./api/raider'));
  app.use('/api/patriots', require('./api/patriot'));
  app.use('/api/panthers', require('./api/panther'));
  app.use('/api/packers', require('./api/packer'));
  app.use('/api/niners', require('./api/niner'));
  app.use('/api/lions', require('./api/lion'));
  app.use('/api/jets', require('./api/jet'));
  app.use('/api/jaguars', require('./api/jaguar'));
  app.use('/api/giants', require('./api/giant'));
  app.use('/api/falcons', require('./api/falcon'));
  app.use('/api/eagles', require('./api/eagle'));
  app.use('/api/dolphins', require('./api/dolphin'));
  app.use('/api/cowboys', require('./api/cowboy'));
  app.use('/api/colts', require('./api/colt'));
  app.use('/api/chiefs', require('./api/chief'));
  app.use('/api/chargers', require('./api/charger'));
  app.use('/api/cardinals', require('./api/cardinal'));
  app.use('/api/buccaneers', require('./api/buccaneer'));
  app.use('/api/browns', require('./api/brown'));
  app.use('/api/broncos', require('./api/bronco'));
  app.use('/api/bills', require('./api/bill'));
  app.use('/api/bears', require('./api/bear'));
  app.use('/api/bengals', require('./api/bengal'));
  // app.use('/api/:teamId', require('./api/message'));


  app.use('/api/users', require('./api/user'));

  app.use('/auth', require('./auth'));

  // All undefined asset or api routes should return a 404
  app.route('/:url(api|auth|components|app|bower_components|assets)/*')
   .get(errors[404]);

  // All other routes should redirect to the index.html
  app.route('/*')
    .get(function(req, res) {
      res.sendFile(path.resolve(app.get('appPath') + '/index.html'));
    });
};
