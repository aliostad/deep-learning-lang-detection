var MessageHandler = require('../messagehandler');
var Commands = require('../commands').CommandEnum;
var Message = require('./message');


//Message from one player to another in a game.

//Format:
//Sender player id(int)
//Recipient player id(int)
//Message(byte[]) - The serialized message

//Parser for Broadcast messages
function messageSendMessageParser(message, server)
{
    console.log("Got SendMessage request");
    
    message.senderUserId = message.readInt();
    message.recipientUserId = message.readInt();
	
	//Emit parsed message event
	server.emit('parsedMessageSendMessage', message);
}

//Register parser with MessageHandler
MessageHandler.registerMessageParser(Commands.SendMessage, messageSendMessageParser);