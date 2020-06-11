var MessageManager=cc.Class.extend({
	
	messageList:null,
	
	ctor : function(message){
		messageList=message;
	},
	
	addMessage:function(up,portrait,text){
		var message={
				'up':up,
				'portrait':portrait,
				'text':text
		};
		messageList.push(message);
	},
	
	addMessage:function(message){
		messageList=messageList.concat(message);
		return messageList;
	},
	
	getMessage:function(){
		if(messageList.length==0)
			return null;
		else {
			return messageList.shift();
		}
	},
	
	getMessageLength:function(){
		return messageList.length;
	}
})

