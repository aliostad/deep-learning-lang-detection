"use strict";

var service = require("../tomato-service");

// constructor
var TomatoService = function() {
  service.createSyncData(this, 'syncTest', 123);
};

// destructor
TomatoService.prototype.destroy = function() {
  console.log('tomato service destroy');
}


TomatoService.prototype.updateTime = service.clientFunction;
TomatoService.prototype.getTime = service.clientCallable(function() {
  console.log(arguments);
  return 123;
});
TomatoService.prototype.getSyncTest = service.clientCallable(function() {
  return this.syncTest;
});

TomatoService.prototype.setTime = service.clientCallable(function(args, id) {
  console.log('client call setTime');
  this.updateTime({}, id, function(resp) {
    console.log('client updateTime callback', resp);
  });
});

TomatoService.serviceOptions = {
  standalone: true,
  singleton: true
};

module.exports = TomatoService;
