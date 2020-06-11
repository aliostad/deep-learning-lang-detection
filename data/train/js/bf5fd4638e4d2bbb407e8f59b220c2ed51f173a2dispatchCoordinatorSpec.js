var expect = require('chai').expect;
var buildMarty = require('../../../test/lib/buildMarty');
var DispatchCoordinator = require('../dispatchCoordinator');

describe('DispatchCoordinator', () => {
  var Marty, coordinator;

  beforeEach(() => {
    Marty = buildMarty();
    coordinator = new DispatchCoordinator('Test', { });
  });

  describe('when you try to dispatch something without a type', () => {
    it('should throw an error', () => {
      expect(dispatchingWithoutAType).to.throw(Error);

      function dispatchingWithoutAType() {
        coordinator.dispatch(null, 'foo');
      }
    });
  });
});