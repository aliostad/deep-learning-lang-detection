var MessageHandler = require('../messagehandler');
var Commands = require('../commands').CommandEnum;
var Message = require('./message');

//Format:
//Log type(string)
//Log message(string)

//This message has no reply

//Parser for GetGame messages
function messageLogParser(message, server)
{
	message.logType = message.readString();
	message.logMessage = message.readString();
	
	//Emit parsed message event
	server.emit('parsedMessageLog', message);
}

//Register parser with MessageHandler
MessageHandler.registerMessageParser(Commands.Log, messageLogParser);