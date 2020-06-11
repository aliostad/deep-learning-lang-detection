var sinon = require('sinon'),
    Service = require('../lib/service.js'),
    expect = require('chai').expect;

describe('service.js', function() {
  it('Correctly load the service', function() {
    var trello = require('../lib/services/trello.js');
        service = new Service("trello", {"services": {"trello": {}}}, "foobar")._load_service();
    expect(service).to.equal(trello); 
  });

  it('Correctly execute the service', function() {
    var service = new Service("trello", {"services": {"trello": {}}}, "foobar"),
        obj = sinon.spy();

    sinon.stub(service, "_load_service", function() {
      return function(){return obj;};
    });

    expect(service.execute()).to.equal(obj); 

    service._load_service.restore();
  });
});
