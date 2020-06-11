var clc = require('cli-color');

/**
 * Display an error message
 * @param  {string} message
 */
exports.error = function(message) {
    console.error(clc.red.bold('[error]') + ' ' + message);
}

/**
 * Display a fatal message
 * @param  {string} message
 */
exports.fatal = function(message) {
    console.error(clc.whiteBright.bgRed.bold('[FATAL]') + ' ' + message);
}

/**
 * Display a info message
 * @param  {string} message
 */
exports.info = function(message) {
    console.log(clc.yellow.bold('[info ]') + ' ' + message);
}

/**
 * Display an OK message
 * @param  {string} message
 */
exports.ok = function(message) {
    console.log(clc.green.bold('[ OK  ]') + ' ' + message);
}