'use strict';

var express = require('express');
var API = express.Router();
var apiCtrl = require('../controllers/apiCtrl');

/**
 * API routes
 */

API.get('/messages', apiCtrl.getAllMessages);

API.post('/messages', apiCtrl.createMessages);

API.get('/messages/:message_id', apiCtrl.getOneMessage);

API.delete('/messages/:message_id', apiCtrl.deleteMessage);

// All undefined api routes should return a 404
API.get('/*', function(req, res) {
      res.json({error: "This route not exist, please consult the api docs"});
    });



module.exports = API;
