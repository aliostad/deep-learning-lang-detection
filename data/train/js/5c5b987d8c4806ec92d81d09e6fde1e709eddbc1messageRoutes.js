/**
 * Created by ahmad on 06/06/2015.
 */

var express = require('express');


var routes = function(Message) {
    var messageRouter = express.Router();

    var messageController = require("../controllers/messageController")(Message);

    messageRouter.route('/')
        .post(messageController.post)
        .get(messageController.get)
        .delete(messageController.deleteall);


    messageRouter.use('/:messageId', messageController.findById);

    messageRouter.route('/:messageId')
        .get(messageController.getByID)
        .patch(messageController.patch)
        .delete(messageController.delete)
        .put(messageController.put);

    return messageRouter;
};

module.exports =  routes;
