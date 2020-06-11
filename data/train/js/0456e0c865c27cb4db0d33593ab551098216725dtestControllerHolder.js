const testControllerHolder = {
  testController: null,
  captureResolver: null,
  getResolver: null,
  capture(testController) {
    testControllerHolder.testController = testController;

    if (testControllerHolder.getResolver) {
      testControllerHolder.getResolver(t);
    }

    return new Promise(function (resolve) {
      testControllerHolder.captureResolver = resolve;
    });
  },
  free() {
    testControllerHolder.testController = null;

    if (testControllerHolder.captureResolver) {
      testControllerHolder.captureResolver();
    }
  },
  get() {
    return new Promise(function (resolve) {
      if (testControllerHolder.testController) {
        resolve(testControllerHolder.testController);
      }
      else {
        testControllerHolder.getResolver = resolve;
      }
    });
  }
};

module.exports = testControllerHolder;
