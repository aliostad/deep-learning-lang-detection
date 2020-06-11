/**
 * Basic console.log wrapper
 *
 * @author Andrew Higginson <me@drewzh.com>
 */

class Logger {

	log($message, $type){
		var messageFormatted = `[${type}] - ${message}`

		console.log(arguments);

		switch($type){
			case 'info':
				console.info(messageFormatted);
				break;
			case 'warn':
				console.warn(messageFormatted);
				break;
			case 'error':
				console.error(messageFormatted);
				break;
			case 'debug':
				console.debug(messageFormatted);
				break;
			default:
				console.log(messageFormatted);
				break;
		}
	}

	info($message){
		this.log($message, 'info');
	}

	warn($message){
		this.log($message, 'warn');
	}

	error($message){
		this.log($message, 'error');
	}

	debug($message){
		this.log($message, 'debug');
	}

}
