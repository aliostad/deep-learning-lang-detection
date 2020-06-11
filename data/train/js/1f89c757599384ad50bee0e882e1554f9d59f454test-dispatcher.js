var assert     = require("assert"),
    _          = require("underscore"),
    thicket    = require("../../../../lib-node/thicket/index"),
    Dispatcher = thicket.c("dispatcher");

describe("Dispatcher", function() {
  it("should dispatch to provided delegate per mT", function() {
    var dispatchCount = 0,
        dispatcher = new Dispatcher({
          prefix: "onBob",
          elseSuffix: "Loblaw",
          malformedSuffix: "notBob",
          delegate: {
            onBobLoblaw: function(msg) {
              assert.equal(msg.mT, "NOTFOUND");
              dispatchCount++;
            },
            onBobNotBob: function(msg) {
              assert.ok(!msg.mT);
              dispatchCount++;
            },
            onBobBob: function(msg) {
              assert.equal(msg.mT, "bob");
              dispatchCount++;
            }
          }
        });

    dispatcher.dispatch({
      mT: "NOTFOUND"
    });

    dispatcher.dispatch({
      mT: null
    });

    dispatcher.dispatch({
      mT: "bob"
    });

    assert.equal(dispatchCount, 3);
  });
});
