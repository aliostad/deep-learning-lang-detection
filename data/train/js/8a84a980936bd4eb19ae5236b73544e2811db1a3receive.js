"use strict";

var Command = function () {
};

module.exports = Command;

// This function will handle the event in which a connected socket 
// receives a message from another user.
Command.prototype.handle = function (socket, message) {
    if (message.fromUser && message.message) {
        socket.emit("Message.Receive.new", {
            fromUser: message.fromUser,
            message: message.message
        });
    } else if (message.toUser && message.message) {
        socket.emit("Message.Send.new", {
            toUser: message.toUser,
            message: message.message
        });
    }
};
