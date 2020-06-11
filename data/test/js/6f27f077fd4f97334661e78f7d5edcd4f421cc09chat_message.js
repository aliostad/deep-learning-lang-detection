(function(rts) 
{
	ChatMessage = function(message)
	{
		this.super = rts.Message;
		this.message = message;
	}
	rts.ChatMessage = ChatMessage;

	ChatMessage.ID = 1;

	ChatMessage.prototype.serialize = function() 
	{
		var arr = new Uint8Array(this.message.length + 1);
		arr[0] = ChatMessage.ID;
		for (var i = 0; i < this.message.length; i++) {
			arr[i+1] = this.message.charCodeAt(i);
		}
		return arr;
	}

	ChatMessage.deserialize = function(payload) 
	{
		var result = new ChatMessage();
		result.message = "";
		for (var i = 0; i < payload.length; i++)
			result.message += String.fromCharCode(payload[i]);
		return result;
	}
})(rts);


