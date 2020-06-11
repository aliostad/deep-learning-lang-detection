(function (global) {
	"use strict";
	//-----------------------------------------------------------------------------
	function postMessage(messageObj) {		
		global.parent.postMessage(JSON.stringify(messageObj), '*');
	}
	//-----------------------------------------------------------------------------
	var messageCount = 0;
	(function repeatMessage() {
		setTimeout(function () {
			postMessage({messageCount: messageCount, hello: 'Hello there!'});
			messageCount++;
			repeatMessage();
		}, 2000);	
	})();
	
	console.log('hooking up iframe message');
	global.addEventListener("message", function (message) {
		console.log('to iframe message: ' + message.data);
	}, false);
})(this);