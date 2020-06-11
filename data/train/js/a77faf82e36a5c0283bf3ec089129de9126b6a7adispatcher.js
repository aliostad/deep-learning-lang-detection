var EventEmitter = require("event_emitter");


var dispatcher = new EventEmitter(-1),

    DISPATCH = "dispatch",

    VIEW_ACTION = "VIEW_ACTION",
    SERVER_ACTION = "SERVER_ACTION";


dispatcher.register = function(callback) {
    return dispatcher.on(DISPATCH, callback);
};

dispatcher.unregister = function(callback) {
    return dispatcher.off(DISPATCH, callback);
};

dispatcher.dispatch = function(payload) {
    return dispatcher.emit(DISPATCH, payload);
};

dispatcher.handleViewAction = function(action) {
    dispatcher.dispatch({
        source: VIEW_ACTION,
        action: action
    });
};

dispatcher.handleServerAction = function(action) {
    dispatcher.dispatch({
        source: SERVER_ACTION,
        action: action
    });
};


module.exports = dispatcher;
