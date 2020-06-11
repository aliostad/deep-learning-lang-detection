var StandardTextMessageSender = Class.create();
StandardTextMessageSender.prototype =
{
	initialize: function(internalMessageSender)
	{
		this.internalMessageSender = internalMessageSender;
		this.encoder = new StandardMessageEncoder();
	},

	sendMessage: function(message)
	{
		var m = this.encoder.encodeMessage(message);		
		
		if (Config.TestMode && Config.Lag)
		{
			setTimeout(function(m){
				this.internalMessageSender.sendMessage(m);
				chessClient.logDebugInfo("(#>" + m.messageNumber + " " + m + ")");
			}.bind(this, m), Config.Lag/2);
		}
		else
		{
			this.internalMessageSender.sendMessage(m);
		}											

		chessClient.logDebugInfo("#>" + m.messageNumber + " " + m);
	}
};
