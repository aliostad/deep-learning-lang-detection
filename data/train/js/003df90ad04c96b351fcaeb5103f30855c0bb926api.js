var api = (function() {
    var ChromeApi = require('./api/chrome.js').ChromeApi;
    var SafariApi = require('./api/safari.js').SafariApi;
    var FirefoxApi = require('./api/firefox.js').FirefoxApi;

    var instance;

    function init() {
        if (typeof chrome !== "undefined") {
            return new ChromeApi();
        } else if (typeof safari !== "undefined") {
            return new SafariApi();
        } else {
            return new FirefoxApi();
        }
    }

    return {
        get: function() {
            if (!instance) {
                instance = init();
            }

            return instance;
        }
    }
})();

exports.api = api;