var fs = require('fs');

var MessageBuilder = function () { }

var Message        = function (type, argv) {
  this.type = type;

  for (var prop in argv) {
    this[prop] = argv[prop];
    //Object.defineProperty(this, prop, {value: argv[prop]});
  }
}

MessageBuilder.build = function (message_type, argv) {
  var message = new Message(message_type, argv);
  return message;
}

MessageBuilder.from = function (raw_message) {
  m = JSON.parse(raw_message.toString());
  var message = new Message(m.type, m);
  return message;
}

exports = module.exports = {"MessageBuilder": MessageBuilder, "Message": Message};
