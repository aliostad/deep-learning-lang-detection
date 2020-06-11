var Controller = require('../controllers/gateway.controller');
var express = require('express');
var Router = express.Router();

Router
  .post('/signup', Controller.signUp)

  .post('/login', Controller.login)

  // .get('/:user', Controller.getUser)

  .get('/comments', Controller.getAllComments)

  .post('/comments', Controller.createComment)

  .get('/comments/:name', Controller.getUserComment)

  .put('/comments/:name', Controller.updateUserComment)

  .delete('/comments/:name', Controller.deleteUserComment);

module.exports = Router;