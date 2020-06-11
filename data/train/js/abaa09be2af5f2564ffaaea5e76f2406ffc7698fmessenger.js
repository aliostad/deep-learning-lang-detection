/**
 * Utility methods for postMessage api.
 * @author Origami Advertising, origami.advertising@ft.com
 * @module utils
 */

module.exports.messenger = {
	post: function(message, source) {
		message = (typeof message === 'string') ? message : JSON.stringify(message);
		source = arguments[1] || window.top;
		source.postMessage(message, '*');
	},
	parse: function(message) {

		// Check whether the message looks like an object before trying to parse it
		if (typeof message !== 'string' || message[0] !== '{') {
			return message;
		}

		// try returning the parsed object
		try {
			return JSON.parse(message);
		}
		// return the original message
		catch(e){
			return message;
		}
	}
};
