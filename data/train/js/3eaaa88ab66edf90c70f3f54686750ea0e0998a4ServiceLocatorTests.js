var assert = require('assert'); 
var servicelocator = require('../ServiceLocator');

describe("Service Locator capable of taking in different injector adaptors for different libraries", function () {

    beforeEach(function() {
    });

    it("Can get instance using jsInject adaptor", function () {
        var locator = new servicelocator(new jsInjectAdaptor());
        var serviceAmessage = 'Service A here I am';
        var serviceA = function() { return serviceAmessage; };
        
        locator.register('service A', serviceA);
        var serviceARef = locator.get('service A');
        assert.equal(serviceARef(), serviceAmessage, "Did't get the service returning the message we were looking for");
        
    });
    
});