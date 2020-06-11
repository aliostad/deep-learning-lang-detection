'use strict';

var logger      = require('../logger')
  , messageUtil = require('../message_util')
  , storage     = require('../storage')
  , userFilter  = require('../user_filter')
  ;

module.exports = function(request, message) {
  logger.debug('%s broadcasting message: %j', request.id, message, {});
  pimpMessage(request, message);
  request.socket.broadcast.to(message.conversation).emit('message', message);
  storage.storeMessage(message);
};


function pimpMessage(request, message) {
  message.sender = userFilter.filter(request.user);
  messageUtil.addIdAndTime(message);
  return message;
}
