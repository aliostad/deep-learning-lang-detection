var EncryptedMessageEntity = require('../../encrypted-message-entity');

function save(messageGateway, message, done) {
  if (messageGateway === null || messageGateway === undefined) {
    return done(new Error('No message gateway provided'));
  }

  if (message === null || message === undefined) {
    return done(new Error('No message provided'));
  }

  if (!(message instanceof EncryptedMessageEntity)) {
    return done(new Error('Not a MessageEntity'));
  }

  messageGateway.save(message.toJSON(), function (err, data) {
    if (err) {
      return done(err);
    }

    var savedMessage = new EncryptedMessageEntity();
    savedMessage.setId(data.id);
    savedMessage.setData(data.data);
    savedMessage.setName(data.name);
    savedMessage.addFields(data.fields || {});

    done(null, savedMessage);
  });
}

module.exports = save;