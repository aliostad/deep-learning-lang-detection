var fs = require('fs');
var file;

module.exports.init = function Log(path) {
    file = fs.openSync(path, 'w');
}

module.exports.i = function info(message) {
    writeMessage("[I]", message);
}

module.exports.w = function warning(message) {
    writeMessage("/!\ [W]", message);
}

module.exports.e = function error(message) {
    writeMessage("!! [E]", message);
}

function writeMessage(head, message) {
    fs.write(file, head + " " + dateNow() + " - " + message + "\n");
}

function dateNow() {
    return new Date().toISOString()
        .replace(/T/, ' ')
        .replace(/\..+/, '');
}
