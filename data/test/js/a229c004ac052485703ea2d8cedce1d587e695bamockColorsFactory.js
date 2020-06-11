'use strict';

module.exports = function() {
	return {
		debug: function(message) { return '<debug>' + message + '</debug>'; },
		info: function(message) { return '<info>' + message + '</info>'; },
		warning: function(message) { return '<warning>' + message + '</warning>'; },
		error: function(message) { return '<error>' + message + '</error>'; },
		success: function(message) { return '<success>' + message + '</success>'; },

		path: function(message) { return '<path>' + message + '</path>'; },
		package: function(message) { return '<package>' + message + '</package>'; },
		task: function(message) { return '<task>' + message + '</task>'; },
		time: function(message) { return '<time>' + message + '</time>'; }
	};
};
