'use strict';

var _ = require('lodash');
var util = require('util');
var clone = require('safe-clone-deep');

function normalizeMessageArray(message) {
  if (message.length === 0) return '';
  if (message.length === 1) return normalizeMessage(message[0]);

  return util.format.apply(util,clone(message));
}

function normalizeMessageObject(message) {
  message = _.assign({}, clone(message), { 
    name:message.name || undefined, 
    message:message.message || undefined, 
    stack:message.stack || undefined 
  });
  return JSON.stringify(message, null, 4);
}

function normalizeMessage(message) {
  if (typeof message === "string") return message;
  if (_.isArray(message)) return normalizeMessageArray(message);
  if (_.isObject(message)) return normalizeMessageObject(message);
  return (message || '').toString();
}

module.exports = normalizeMessage;