

// TESTING: http://chaijs.com
import chai from 'chai';
const expect = chai.expect;
const assert = chai.assert;

// TESTING: https://mochajs.org
import mocha from 'mocha';
let root = window.document.createElement('div');
root.setAttribute("id", "mocha");
window.document.body.appendChild(root);
mocha.setup('bdd');

import Dispatch from 'reactor2/core/Dispatch';
function dispatch() {
  describe('Dispatch', () => {
    let test_dispatch = new Dispatch();

    it('should emitt hello message', function (done) {
      test_dispatch.on('test', (msg) => {
        console.debug('test_dispatch.on.test:',msg);
        assert.equal(msg, 'hello');
        done();
      });
      test_dispatch.emit('test', 'hello');
    });
  }); // Dispatch
}

dispatch();
mocha.run();
