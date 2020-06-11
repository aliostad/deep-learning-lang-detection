var client;

exports.init = init;
exports.messageHandler = messageHandler;

function init (initArg)
{
	client = initArg.client;

	return { moduleCommand: {command: ["안녕", "hello", "moi", "aiya"]}, callBack: messageHandler };
}

function messageHandler(message)
{
	if(message.splitedMessage[0] == "안녕")
	{
		client.privmsg (message.channel, "세상아!");
	}
	else if(message.splitedMessage[0] == "hello")
	{
		client.privmsg(message.channel, "world!");
	}
	else if(message.splitedMessage[0] == "moi")
	{
		client.privmsg(message.channel, "maailma!");
	}
	else if(message.splitedMessage[0] == "aiya")
	{
		client.privmsg(message.channel, "ambar!");
	}
}
