'use strict';

describe('<%= components.service %>', function () {
  var <%= components.service %>;

  beforeEach(module('<%= modules.service %>'));
  beforeEach(module(initMocks));
  beforeEach(inject(initService));

  it('should exist', function () {
    expect(<%= components.service %>).to.be.an('Object');
  });

  it('should write more tests', function () {
    expect(false).to.eql(true);
  });

  function registerService($provide) {

    return function (name, mock) {
      $provide.service(name, function () {
        return mock;
      });
    };

  }

  function initMocks($provide) {
    var addMockService = registerService($provide);
  }

  function initService(_<%= components.service %>_) {
    <%= components.service %> = _<%= components.service %>_;

  }

});

