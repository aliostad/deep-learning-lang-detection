'use strict';

const debug = require('debug')('iframe-bridge:iframe');
const MessageHandler = require('./MessageHandler');

let messageHandler = new MessageHandler();

messageHandler.init(window.parent);
window.addEventListener('message', function (event) {
    try {
        let data = JSON.parse(event.data);
        debug('message received', data);
        messageHandler.handleMessage(data);
    } catch (e) {}
});

exports.postMessage = function (type, message) {
    return messageHandler.postMessage(type, message);
};

exports.onMessage = function (cb) {
    messageHandler.on('message', cb);
};

exports.ready = function () {
    messageHandler.handlePendingMessages();
};
