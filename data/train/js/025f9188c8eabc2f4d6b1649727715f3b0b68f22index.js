var Dispatcher = require('../index')
  , test_dispatcher = new Dispatcher()

describe('Flux Dispatcher', function() {

  it('should work', function() {
    var counter = 0;

    test_dispatcher.register(function() {
      counter++
    })

    test_dispatcher.dispatch()
    test_dispatcher.dispatch()
    test_dispatcher.dispatch()

    counter.should.equal(3)
  })

  it('should share dispatches', function() {
    var dispatch_1 = new Dispatcher()
      , dispatch_2 = new Dispatcher()
      , counter_1 = 0
      , counter_2 = 0

    dispatch_1.register(function() {
      counter_1++
    })

    dispatch_2.register(function() {
      counter_2++
    })

    dispatch_1.dispatch()
    dispatch_1.dispatch()
    dispatch_1.dispatch()
    dispatch_2.dispatch()
    dispatch_2.dispatch()
    dispatch_2.dispatch()

    counter_1.should.equal(6)
    counter_2.should.equal(6)

  })

})
