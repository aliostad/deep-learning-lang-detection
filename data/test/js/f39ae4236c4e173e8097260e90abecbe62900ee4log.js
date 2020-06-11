
var eventbus = require("eventbus");

function parseMessage(message, args) {
    var parts = message.split("{}");
    var result = [];

    for (var i = 0; i < parts.length; ++i) {
        if (i > 0)
            result.push(args[i]);
        result.push(parts[i]);
    }

    return result.join("");
}

exports.trace = function(message) {
    /* do not print trace */
    console.log("[TRACE]", parseMessage(message, arguments));
};

exports.info = function(message) {

    message = parseMessage(message, arguments);

    console.log("[INFO]", message);

    eventbus.publish("log", {
                         level: "info",
                         message: message
                     });

};

exports.warn = function(message) {

    message = parseMessage(message, arguments);

    console.log("[WARN]", message);

    eventbus.publish("log", {
                         level: "warn",
                         message: message
                     });

};

exports.error = function(message) {

    message = parseMessage(message, arguments);

    console.log("[ERROR]", message);

    eventbus.publish("log", {
                         level: "error",
                         message: message
                     });

};
