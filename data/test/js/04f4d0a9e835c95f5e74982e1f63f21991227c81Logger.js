class Logger {

	constructor(){

	}

	log(type, message, ..items){
		var date = new Date();
		var output = date.toISOString() + ' - ' + type.toUpperCase() + ': ' + message;

		console.log(output)
	}

	debug(message, ..items){
		this.log('debug', message, ..items);
	}

	info(message, ..items){
		this.log('info', message, ..items);
	}

	warn(message, ..items){
		this.log('warn', message, ..items);
	}

	error(message, ..items){
		this.log('error', message, ..items);
	}

	crit(message, ..items){
		this.log('crit', message, ..items);
	}

}
