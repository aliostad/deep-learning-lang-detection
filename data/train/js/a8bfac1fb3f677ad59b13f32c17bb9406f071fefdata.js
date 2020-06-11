(function () {
  'use strict';
  var express = require('express');
  var router = express.Router();
  var UserController = require('./../controller/UserController');
  var PostController = require('./../controller/PostController');
  var RatingController = require('./../controller/RatingController');
  var CommentController = require('./../controller/CommentController');
  var CommentRatingController = require('./../controller/CommentRatingController');

  var routeController = function (path, Controller, io) {
    Controller.repository.handleUpdates(io.of(path));

    router.get(path, function (req, res) {
      var controller = new Controller();
      controller.req = req;
      controller.res = res;
      controller.getAll();
    });
    router.post(path, function (req, res) {
      var controller = new Controller();
      controller.req = req;
      controller.res = res;
      controller.post(req.body.data);
    });
    router.get(path + '/:id', function (req, res) {
      var id = req.params.id;
      var controller = new Controller();
      controller.req = req;
      controller.res = res;
      controller.get(id);
    });
    router.delete(path + '/:id', function (req, res) {
      var id = req.params.id;
      var controller = new Controller();
      controller.req = req;
      controller.res = res;
      controller.deleteItem(id);
    });
  };

  module.exports = function (io) {
    routeController('/users', UserController, io);
    routeController('/posts', PostController, io);
    routeController('/ratings', RatingController, io);
    routeController('/comments', CommentController, io);
    routeController('/commentRatings', CommentRatingController, io);

    return router;
  };
}());