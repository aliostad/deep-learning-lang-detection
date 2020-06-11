var helpers = require('./helpers'),
    logger = require('./logger'),
    connection = require('./connection');

helpers.subscriber.on('message', function(channel, message) {
  logger.info('Channel ' + channel + ' received: ' + message);

  // handles connections between different servers for load balancing
  if(channel === 'connection') {
    message = JSON.parse(message);

    if(message.remove) {
      connection.deleteLocalConn(message.remove);
    } else if(message.message) {
      connection.messageLocalConn(message.message.conn_id, message.message.msg);
    } else if(message.end) {
      connection.endLocalConn(message.end);
    }
  }
});