var util = require('util');

var events = require('events');

function Service() {
    events.EventEmitter.call(this);

    this.error = null;
    this.status = Service.NEW;
}
module.exports = Service;
util.inherits(Service, events.EventEmitter);

Service.prototype.start = function(cb) {};
Service.prototype.stop  = function(cb) {};
Service.prototype.get   = function() {};

Service.prototype.changeStatus = function(status) {
  this.status = status;
  this.emit(status);
};

// Cycle is new, starting, running, stopping, stopped, failed
Service.NEW      = 'new';
Service.STARTING = 'starting';
Service.RUNNING  = 'running';
Service.STOPPING = 'stopping';
Service.STOPPED  = 'stopped';
Service.FAILED   = 'failed';
