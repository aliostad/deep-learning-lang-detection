'use strict';

import config from '../config.js';
import fs from 'fs';

/**
 * Logger class. For the time being it appends everything to a file.
 */

const log = function(message) {
    message += '\n';
    if (false) {
        fs.appendFile(config.log.file, message + '\n', function(err) {
            if (err) {
                throw 'Error writing log to file: ' + err;
            }
        });        
    } else {
        fs.appendFileSync(config.log.file, message);
    }
};

class Logger {
    constructor() {
        console.log(`Temp dir is ${config.log.file}`);
    }

    _sanitize(message) {
        if (!message) {
            return 'undefined';
        } else if (message.constructor === Array ||
            message.constructor === Object) {
                return JSON.stringify(message);
        } else {
            return String(message);
        }
    }

    warn(message) {
        message = this._sanitize(message);
        log('W: ' + message);
    }

    info(message) {
        message = this._sanitize(message);
        log('I: ' + message);
    }

    debug(message) {
        message = this._sanitize(message);
        log('D: ' + message);
    }

    error(message) {
        message = this._sanitize(message);
        log('E: ' + message);
    }

    verbose(message) {
        message = this._sanitize(message);
        log('V: ' + message);
    }

    // shortcuts
    w(message) {
        this.warn(message);
    }

    i(message) {
        this.info(message);
    }

    d(message) {
        this.debug(message);
    }

    e(message) {
        this.error(message);
    }

    v(message) {
        this.verbose(message);
    }
}

export default new Logger();