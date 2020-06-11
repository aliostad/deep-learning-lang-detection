var client;
var channelHT = new Object();

exports.init = init;
exports.messageHandler = messageHandler;

function init (initArg)
{
	client = initArg.client;

	return { moduleCommand: { command: ["따라해"] }, callBack: messageHandler, promiscCallBack: promiscMessageHandler};
}

function messageHandler(message)
{
	if(message.splitedMessage[0] == "따라해")
	{
		if(channelHT[message.channel] == undefined)
		{
			channelHT[message.channel] = true;
		}
		else
		{
			channelHT[message.channel] = !channelHT[message.channel];
		}
	}
}

function promiscMessageHandler(message)
{
	if(channelHT[message.channel])
		client.privmsg(message.channel, message.content);
}

