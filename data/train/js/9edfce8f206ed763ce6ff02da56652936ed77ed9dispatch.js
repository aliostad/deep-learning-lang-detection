
if (typeof define !== 'function') {
  var define = require('amdefine')(module);
}

define(function(require) {

  var common = require('./common'),
      _  = require('underscore');

  var toJson = JSON.stringify;

  var Dispatch = function(on, exec) {
    this.on = on;
    this.exec = exec;
  };

  Dispatch.prototype = {
    is: function(v) {
      return this.on == toJson(v);
    },
    isNot: function(v) {
      return !this.is(v);
    },
    invoke: function(args) {
      return common.apply(this.exec, args);
    }
  };

  Dispatch.create = function(on, exec) {
    return new Dispatch(on, exec);
  };

  Dispatch.fromPair = function(pair) {
    return Dispatch.create(toJson(pair[0]), pair[1]);
  };

  Dispatch.is = _.partial(common.invoke, 'is');
  Dispatch.isNot = _.partial(common.invoke, 'isNot');

  Dispatch.find = function(many, v) {
    return _.find(many, Dispatch.is(v));
  };

  Dispatch.reject = function(many, v) {
    return _.reject(many, Dispatch.is(v));
  };

  Dispatch.add = function(many, pair) {
    return common.append(many, Dispatch.fromPair(pair));
  };

  return Dispatch;

});
