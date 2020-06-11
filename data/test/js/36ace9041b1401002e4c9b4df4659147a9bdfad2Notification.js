var Notification = ( function () {
    "use strict";

    var KEY_MESSAGE = 'Later.message',
        currentTabId;

    function setMessage(message) {
        localStorage[KEY_MESSAGE] = message;
    }

    function getMessage() {
        return localStorage[KEY_MESSAGE];
    }
    
    function hasMessage() {
        return localStorage[KEY_MESSAGE] !== undefined;
    }

    function clearMessage() {
        localStorage.removeItem(KEY_MESSAGE);
    }

    return {
        'setMessage': setMessage,
        'getMessage': getMessage,
        'hasMessage': hasMessage,
        'clearMessage': clearMessage
    }
} ());