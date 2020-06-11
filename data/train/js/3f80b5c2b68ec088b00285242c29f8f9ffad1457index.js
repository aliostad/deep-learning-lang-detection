// setup custom logging
var utils = require('./utils');
var util = require('util');

var log = utils.replaceObject(console, 'log', function (message, object) {
    log(formatMessage(message, object, 'INFO'));
});

var error = utils.replaceObject(console, 'error', function (message, object) {
    error(formatMessage(message, object, 'ERROR'));
});

var debug = utils.replaceObject(console, 'debug', function (message, object) {
    if (!debug) {
        debug = log;
    }
    debug(formatMessage(message, object, 'DEBUG'));
});

function formatMessage(message, object, type) {
    if (!message) {
        message = '';
    } else if (typeof message !== 'string') {
        object = message;
        message = '';
    }
    if (object) {
        if (message !== '') {
            message += '\n';
        }
        if (object instanceof Error) {
            message += object.stack;
        } else {
            message += JSON.stringify(object);
        }
    }
    return '[' + utils.timestamp() + '][' + type + '] ' + message;
}

var server = require("./server");
server.start();