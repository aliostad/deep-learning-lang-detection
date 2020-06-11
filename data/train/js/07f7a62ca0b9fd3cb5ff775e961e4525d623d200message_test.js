// Themen: Optionale benannte parameter per Objektliteral, Node.js-Module kennenlernen

var assert = require('assert');
var message = require('../../js7_code/javascript_1_code/message');

assert.equal(message.create('The message'), 'The message');
assert.equal(message.create('The message', { uppercase: true }), 'THE MESSAGE');
assert.equal(message.create('The message', { prefix: 'Message: ' }), 'Message: The message');
assert.equal(message.create('The message', { prefix: 'Message: ', uppercase: true }), 'Message: THE MESSAGE');