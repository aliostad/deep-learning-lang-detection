'use strict';
function Logger() {
    var self = this;

    self.write = function (level, message) {
        
        if (typeof message != "string") {
            message = JSON.stringify(message);
        }
        console.log(level + ": " + message);
    };

    self.log = function(level, message) {
        self.write(level, message);
    }
    self.debug = function (message) {
        self.write('debug', message);
    }
    self.info = function(message) {
        self.write('info', message);
    }
    
    self.error = function(message) {
        self.write('error', message);
    }
};

var log = new Logger();