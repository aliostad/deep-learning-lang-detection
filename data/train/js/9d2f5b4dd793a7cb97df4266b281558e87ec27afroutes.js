var path                = require('path');

var OauthController     = require('./controllers/OauthController');
var UserController      = require('./controllers/UserController');
var InstagramController = require('./controllers/InstagramController');
var BoardController = require('./controllers/BoardController');
var SocketsManager = require('./controllers/SocketsManager');



module.exports.createRoutes = function (express, io) {

	OauthController.intialize();
	UserController.initialize();
  BoardController.initialize();

  //InstagramController.initialize();
  //SocketsManager.intialize();
};