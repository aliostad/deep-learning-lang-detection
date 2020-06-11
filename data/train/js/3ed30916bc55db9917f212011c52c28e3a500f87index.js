var path = require('path');
var assert = require('assert');
var after = require('after');

var Registry = require('../');

var service_path_1 = path.join('/', 'test', 'etcd-spaceport', '1');
var service_path_2 = path.join('/', 'test', 'etcd-spaceport', '2');

var registry_1 = undefined;
var registry_2 = undefined;

before('should create a registry', function(done) {
    registry_1 = Registry(service_path_1);
    registry_2 = Registry(service_path_2);
    done();
});

test('should create and register a new service', function(done) {
    var service_1 = registry_1.service('service-1', { ttl: 1 });

    done = after(3, done);

    service_1.start({}, function() {
        done();
    });

    var browser = registry_1.browse(function(service) {
        assert.equal('service-1', service.name);
        service.once('offline', function() {
            done();
            browser.stop();
        });
        service_1.stop(done);
    });
});

test('should have service registred after ttl', function(done) {
    var service_2 = registry_1.service('service-2', { ttl: 1 });

    done = after(2, done);

    service_2.start({}, function() {
        done();
    });

    var browser = registry_1.browse(function(service) {
        if (service.name != 'service-2') {
            return
        }

        assert.equal('service-2', service.name);

        var online = true;
        service.once('offline', function() {
            assert(!online);
            browser.stop();
        });

        setTimeout(function() {
            online = false;
            service_2.stop(done);
        }, 1500);
    });
});

test('should no longer listen for services after browser stop', function(done) {
    var service_3 = registry_1.service('service-3', { ttl: 1 });

    done = after(2, done);

    service_3.start({}, function() {
        done();
    });

    var browser = registry_1.browse(function(service) {
        assert(false);
    });

    browser.stop();

    setTimeout(function() {
        service_3.stop();
    }, 1500);

    setTimeout(function() {
        done();
    }, 1750);
});

test('should not start if already running', function(done) {
    var service_4 = registry_1.service('service-4', { ttl: 1 });
    var service_again = registry_1.service('service-4', { ttl: 1 });

    done = after(3, done);

    service_4.start({}, function() {
        done();
    });

    var browser = registry_1.browse(function(service) {
        assert.equal('service-4', service.name);

        service_again.start({}, function(err) {
            assert.equal(err.message, 'Key already exists');
            assert.equal(err.code, 105);
        });

        done();
    });

    setTimeout(function() {
        browser.stop();
        service_4.stop(done);
    }, 1500);
});

test('should have heartbeats', function(done) {
    this.timeout(12000);
    var service_1 = registry_1.service('service-1', { ttl: 1 });

    done = after(3, done);

    service_1.start({}, function() {
        done();
    });

    var online = true;
    var browser = registry_1.browse(function(service) {
        assert.equal('service-1', service.name);
        service.once('offline', function() {
            assert(!online);
            browser.stop();
            done();
        });
    });

    setTimeout(function() {
        online = false;
        service_1.stop(done);
    }, 10000);
});
