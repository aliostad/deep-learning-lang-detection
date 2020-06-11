'use strict';

module.exports = function Parser() {

	/**
	 * Incoming utf-8 encoded message
	 */
	this.parseMessage = function(_message, serialized) {
		var message = {};
		if(serialized) {
			var _message = JSON.parse(_message);
		}
		if('event' in _message) {
			message.isEvent = true;
			message.event = _message.event;
			message.data = _message.data;
			return message;
		}
		else {
			message.isRequest = true;
			message.uri = _message[0];
			if(message.uri === undefined) {
				return false;
			}
			message.props = _message[1];
			message.id = _message[2];
			if(message.props.method) {
				var method = message.props.method.toUpperCase();
				delete message.props.method;
			}
			else {
				var method = 'GET';
			}
			('params' in message.props) ? message.props = message.props : message.props = {};

		}
		return message;
	}

	/**
	 * Incoming binary message with routing metadata
	 */
	this.parseBinaryMessage = function(data) {
		var metalength = data[1] << 8 | data[0];
		var metadata = '';
		for(var i=0; i<metalength; i++) {
			metadata += String.fromCharCode(data[2+i]);
		}
		var binData = data.slice(2+metalength, data.length);
		var message = JSON.parse(metadata);
		return {bin: binData, message: message};
	}

}