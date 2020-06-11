var LogMessage = require('./LogMessage').message,
    extend = require('../../node_modules/extend');

function DatabaseLogMessage (messageType, options) {
    this.type = messageType;
    extend(this, options);
}

DatabaseLogMessage.prototype = new LogMessage();
DatabaseLogMessage.prototype.constructor = DatabaseLogMessage;

DatabaseLogMessage.prototype.type = -1;
DatabaseLogMessage.prototype.user = null; // obj
DatabaseLogMessage.prototype.taskId = 'UNDEFINED';
DatabaseLogMessage.prototype.taskCount = -1;
DatabaseLogMessage.prototype.description = 'UNDEFINED';
DatabaseLogMessage.prototype.position = -1;
DatabaseLogMessage.prototype.startPosition = -1;
DatabaseLogMessage.prototype.endPosition = -1;
DatabaseLogMessage.prototype.shift = -1;
DatabaseLogMessage.prototype.progress = -1;

exports.message = DatabaseLogMessage;
