var messageSchema = require('../schema/message');
var socketHandler = require('./socket');
var logger = require('./logger');

var saveMessageCallback = function(message, err) {
	logger.log('saveMessageCallback: start - ', message);
	
	socketHandler.emit(message.sender, 'message', message);
	socketHandler.emit(message.reciever, 'message', message);
	
	
}

var handleUserMessage = function(sender, reciever, message) {
	logger.log('handleUserMessage: start sender - ', sender, ', reciever - ', reciever, ', message - ', message);
	
	messageSchema.saveMessage(sender, reciever, message, saveMessageCallback);
}

var pushMessages = function(user) {

}


exports.handleMessage = handleUserMessage
