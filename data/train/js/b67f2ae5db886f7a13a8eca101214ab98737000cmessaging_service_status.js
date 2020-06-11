MessagingStatus = require('./messaging_status');

var codes = {
	DEFAULT : 'UNKNOWN_ERROR',
	SUCCESS : 'MESSAGE_SENT',
	QUEUED : 'MESSAGE_QUEUED',
	LIMIT_EXCEEDED : 'LIMIT_EXCEEDED_ERROR',
	SERVICE_DOWN : 'SERVICE_DOWN_ERROR'
}

function MessagingServiceStatus(service) {
	MessagingStatus.call(this, codes);
	this.state.service = service;
}

MessagingServiceStatus.prototype = Object.create(MessagingStatus.prototype);
MessagingServiceStatus.prototype.constructor = MessagingServiceStatus;

module.exports = MessagingServiceStatus;