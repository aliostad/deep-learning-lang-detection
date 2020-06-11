var messageTypes = {
  transient: 'transient',
  queued: 'queued'
};

exports.createDirect = function(messageIdentifier, payload) {
  return createBasicMessage(messageIdentifier, messageTypes.transient, payload);
};
exports.createQueued = function(messageIdentifier, payload) {
  return createBasicMessage(messageIdentifier, messageTypes.queued, payload);
};
exports.messageTypes = messageTypes;

function createBasicMessage(messageIdentifier, messageType, payload) {
  return {
    messageIdentifier: messageIdentifier,
    messageType: messageType,
    payload: payload
  };
}
