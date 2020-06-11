var log4js = require('log4js');
var log = log4js.getLogger("message-dispatch");

log.setLevel("info");

function handleCameraMessage( message ) {
    log.debug("Got camera message:\n%s", JSON.stringify(message) );
};

function handleClientMessage( message ) {
    log.debug("Got client message:\n%s", JSON.stringify(message) );
};

function handleAssetMessage( message ) {
    log.debug("Got asset message:\n%s", JSON.stringify(message) );
};

var dispatchers = {
    cam: handleCameraMessage,
    ass: handleAssetMessage,
    clt: handleClientMessage,
};

function dispatchMessage( message ) {
    try {
        var dfunc = dispatchers[message.t];
        if (dfunc) {
            dfunc(message);
        } else {
            log.warn("Encountered unknown message: ");
            log.warn(message);
        }
    } catch (error) {
        log.error(error);
    }
};

module.exports = {
    dispatchMessage: dispatchMessage
};
