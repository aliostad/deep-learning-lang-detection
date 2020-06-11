const
  events = require('events'),
  util = require('util'),
  MessageReader = function () {
    events.EventEmitter.call(this);
  };

util.inherits(MessageReader, events.EventEmitter);
  
MessageReader.prototype.readMessage = function (message) {
  if (message.type === 'watching') {
    this.emit('watching', message.file);
  } else if (message.type === 'changed') {
    this.emit('changed', message);
  } else {
    throw Error('Unknown message type: ' + message.type);
  }
};

exports.MessageReader = function () {
  return new MessageReader();
};

