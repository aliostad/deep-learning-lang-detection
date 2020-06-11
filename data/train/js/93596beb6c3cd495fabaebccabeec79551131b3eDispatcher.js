var logger = require("./Logger");
var Dispatch = require('./Dispatch');
var events = require('events');
var util = require('util');

var Dispatcher = function(connHandler) {
    this.ConnectionHandler = connHandler;
    logger.debug("Dispatcher created");
    events.EventEmitter.call(this);
}
util.inherits(Dispatcher, events.EventEmitter);

/**
 * Takes a dispatch paket, resolves all recipients and forwards it for delivery
 * @param dispatch
 * @returns {boolean}
 */
Dispatcher.prototype.dispatch = function(dispatch) {
    logger.debug("Now I'm resolving it!");
    this.ConnectionHandler.resolve(dispatch);

    logger.debug("Now I'm dispatchin it!");
    var targetConnections = dispatch.getTargetConnections();
    for (var connId in targetConnections) {
        var conn = targetConnections[connId];
        conn.send("EVENT", {
            event: dispatch._event,
            payload: dispatch._payload
        });
    }
    this.emit(dispatch._event, dispatch._payload);
    return true;
};

Dispatcher.prototype.dispatchEventDataTarget = function(event, data, targets) {
    var dispatch = new Dispatch(event, data, targets);
    this.dispatch(dispatch);
}

module.exports = Dispatcher;
