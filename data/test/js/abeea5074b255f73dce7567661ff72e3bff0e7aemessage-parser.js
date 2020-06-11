define([], function () {
	var parser = (function () { 
		'use strict';
		
		function parseMessage(message) {
			var parsedMessage = '',
				laughingEmoticon = '<img src="media/laughing.png"/>', 
				likeEmoticon = '<img src="media/like.png"/>', 
				sadEmoticon = '<img src="media/sad.png"/>', 
				smileEmoticon = '<img src="media/smile.png"/>', 
				winkEmoticon = '<img src="media/wink.png"/>'; 
			
			for (var i = 0; i < message.length; i += 1) {
				if (message[i] === ':' && (message[i + 1] === 'D' || message[i + 1] === 'd')) {
					parsedMessage += laughingEmoticon;
					i += 1;
				} else if (message[i] === ':' && message[i + 1] === ')') {
					parsedMessage += smileEmoticon;
					i += 1;
				} else if (message[i] === ':' && message[i + 1] === '(') {
					parsedMessage += sadEmoticon;
					i += 1;
				} else if (message[i] === ';' && message[i + 1] === ')') {
					parsedMessage += winkEmoticon;
					i += 1;
				} else if (message[i] === '(' && (message[i + 1] === 'y' || message[i + 1] === 'Y') && message[i + 2] === ')') {
					parsedMessage += likeEmoticon;
					i += 2;
				} else {
					parsedMessage += message[i];
				}
			}
			
			return parsedMessage;
		}
		
		return {
			parseMessage: parseMessage
		};
	} ());
	
	return parser;
});