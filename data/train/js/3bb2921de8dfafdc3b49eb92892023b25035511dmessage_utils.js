
var Q = require('q');

var MessageUtils = {};

MessageUtils.stripFields = function(message) {

   if (message.sessionID) {
       delete message.sessionID;
   }

   return message;
}

MessageUtils.stringify = function(message) {

    var deferredMessage = Q.defer();

    // Ensure the message is a string
    if (typeof message == 'object') {
        var jsonMessage = JSON.stringify(message);
    } else if (typeof message == 'string') {
        var jsonMessage = message;
    } else {
        deferredMessage.reject('This message is not an object or a string', message)
    }
    deferredMessage.resolve(jsonMessage);
    return deferredMessage.promise;
}

MessageUtils.parse = function(jsonMessage) {

    // Ensure the message is a string
    if (typeof message == 'string') {
        var message = JSON.parse(jsonMessage);
    } else if (typeof message == 'object') {
        var message = jsonMessage;
    } else {
        logger.error('This message is not an object or a string', jsonMessage);
        return;
    }
    return message;
}

module.exports = MessageUtils;
