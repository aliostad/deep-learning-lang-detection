module.exports = MessageList;

function MessageList(){
	this.messageList = [];
};

MessageList.prototype.addMessage = function(from, message){
	this.messageList.push(new ChatMessage(from, message));
};

MessageList.prototype.getMessageList = function(){
	return this.messageList;
};

function ChatMessage(from, message){
	this.from = from;
	this.message = message;
	this.time = new Date();
};

ChatMessage.prototype.toString = function(){
	return "[" + this.time.getHours() + ":" + this.time.getMinutes() + "] " + this.from + "  :  " + this.message;
};

