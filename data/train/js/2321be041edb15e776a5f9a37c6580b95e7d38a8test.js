var recorder = require('.');
var keycode = require('keycode');
var events = require('events');

describe('recorder', function () {

  it('should capture a valid shortcut', function (done) {
    i = 0;
    recorder.start()
      .on('end', function (res) {
        res.should.eql(['ctrl', 'x']);
        i++;
      });
    dispatch('keydown', 'ctrl');
    dispatch('keydown', 'x');
    dispatch('keydown', 'y');
    recorder.start()
      .on('end', function (res) {
        res.should.eql(['ctrl', 'alt', 'y']);
        i++;
      });
    dispatch('keydown', 'alt');
    dispatch('keydown', 'ctrl');
    dispatch('keydown', 'y');
    dispatch('keydown', 'x');
    recorder.start()
      .on('end', function (res) {
        res.should.eql(['ctrl', 'command', 'x']);
        if(i == 2) done();
      });
    dispatch('keydown', 'command');
    dispatch('keydown', 'ctrl');
    dispatch('keydown', 'x');
  });

  it('should update unpressed pfx keys', function (done) {
    recorder.start()
      .on('end', function (res) {
        res.should.eql(['ctrl', 'x']);
        done();
      });
    dispatch('keydown', 'alt');
    dispatch('keydown', 'shift');
    dispatch('keyup', 'shift');
    dispatch('keyup', 'alt');
    dispatch('keydown', 'ctrl');
    dispatch('keydown', 'x');
  });

  it('should not end when only shift is pressed', function (done) {
    recorder.start()
      .on('end', function (res) {
        res.should.eql(['shift', 'command', 'y']);
        done();
      });
    dispatch('keydown', 'shift');
    dispatch('keydown', 'x');
    dispatch('keyup', 'x');
    dispatch('keydown', 'command');
    dispatch('keydown', 'y');
  });

  it('should cancel explicitly', function (done) {
    recorder.start()
      .on('cancel', function () {
        done();
      });
    dispatch('keydown', 'ctrl');
    recorder.cancel();
  });

  it('should cancel implicitly', function (done) {
    recorder.start()
      .on('cancel', function () {
        done();
      });
    recorder.start();
  });

  it('should cancel upon a single esc', function (done) {
    recorder.start()
      .on('end', function (res) {
        res.should.eql(['ctrl', 'esc']);

        recorder.start()
          .on('cancel', function () {
            done();
          });
        dispatch('keydown', 'ctrl');
        dispatch('keyup', 'ctrl');
        dispatch('keydown', 'esc');

      });
    dispatch('keydown', 'ctrl');
    dispatch('keydown', 'esc');
  });

});


function dispatch (type, key) {
  var code = keycode(key),
  e = document.createEvent('Event');
  e.initEvent(type, true, true);
  e.keyCode = e.which = code;
  document.dispatchEvent(e);
}