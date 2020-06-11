'use strict';

var	logUtil = require('util');

function customConsole(identifier, obj, showHidden, showColors) {
	if(typeof window !== "undefined") {
		console.info(identifier, obj);
	}
	else {
		showHidden = showHidden ? showHidden : true;
		showColors = showColors ? showColors : true;
		obj = obj ? obj : {};
		console.info("0-------- ", identifier, " ---------0");
		console.info(logUtil.inspect(obj, {"showHidden": showHidden, "depth": null, "colors": showColors}));
		console.info("1-------- ", identifier, " ---------1\n\n");
	}
}

//TODO ---------
customConsole.enableLogging = function() {

}

module.exports = customConsole;
