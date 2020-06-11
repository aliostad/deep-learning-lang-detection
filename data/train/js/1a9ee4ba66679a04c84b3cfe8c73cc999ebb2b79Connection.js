namespace("Brain");

/**
 abstract connection.
*/
Brain.Connection = Backbone.Model.extend({

	send: function(){
		
		console.error("Connection: send, unimplemented");
	}, 

	onMessage: function(messageEvent){

		var message = JSON.parse(messageEvent.data);

		// console.log("onMessage", message);

		this.trigger("message", {
			connection: this, 
			message: message, 
			messageEvent: messageEvent
		});
	}, 

	preSend: function(message){
		if(_.isString(message)){
			console.trace();
			console.warn("unnecessarily pre converted to string")
			return message
		}else if(_.isObject(message)){
			return JSON.stringify(message);
		}else{
			throw "Type not supported"
		}
	}

});
