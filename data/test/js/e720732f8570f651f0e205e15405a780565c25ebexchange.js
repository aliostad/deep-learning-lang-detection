var assert = require('should'),
    Exchange = require('../lib/exchange'),
    Message = require('../lib/message');

describe('Exchange', function() {

  it('message should default to empty message', function() {
    var exchange = new Exchange();
    exchange.message.should.be.a.Message;
  });

  it('should set message if passed via constructor', function() {
    var message = new Message(null, 'myMessage');
    var exchange = new Exchange(message);
    assert.strictEqual(exchange.message, message);
  });

});