/**
 * Training Session Player Actions Definition
 */

var dispatcher = require('./dispatcher');

exports.play = function() {
    dispatcher.dispatch({
        actionType: 'start'
    });
};

exports.stop = function() {
    dispatcher.dispatch({
        actionType: 'stop'
    });
};

exports.pause = function() {
    dispatcher.dispatch({
        actionType: 'pause'
    });
};

exports.resume = function() {
    dispatcher.dispatch({
        actionType: 'resume'
    });
};

exports.reset = function() {
    dispatcher.dispatch({
        actionType: 'reset'
    });
};

exports.pushData = function(data) {
    dispatcher.dispatch({
        actionType: 'data',
        data: data
    });
};
