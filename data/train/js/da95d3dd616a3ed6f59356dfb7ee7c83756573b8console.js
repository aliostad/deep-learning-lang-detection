(function() {
	
	var TYPE = { LOG: 0,  ERROR: 1 };
	var POOL = { log: [], error: [] };
	
	function launchMessage(type, message) {
		switch(type) {
			case TYPE.LOG :
				POOL.log.push(message);
				print("console.log : " + message);
				break;
				
			case TYPE.ERROR :
				POOL.error.push(message);
				print("console.error : " + message);
				break;
		}
	}
	
	function print(message) {
		if (console.remote)
			window.pumpikin.send(JSON.stringify({ "call" : "CONSOLE", "message" : message }));
		else
			alert("####### " + message);
	}

	window.console = {
		
		'remote': false,
		
		'log' : function(message) {
			launchMessage(TYPE.LOG, message);
		},
		
		'error' : function(message) {
			launchMessage(TYPE.ERROR, message);
		}
	};

})();