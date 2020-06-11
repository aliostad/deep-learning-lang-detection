var assert = require('assert');
var env = require('../lib/env');

var title = 'Environment';
var account = 'testAccount';
var realm = 'testRealm';
var realmPath = '/' + account + '/realms/' + realm;

function localhostServiceCheck(service, scheme, host, port, path) {
    //console.log(service);
    assert(service);
    assert.equal(service.getScheme(), scheme);
    assert.equal(service.getHostname(), host);
    assert.equal(service.getReferrer(), scheme + '://' + host);
    assert.equal(service.getInternalHost(), scheme + '://' + host + port);
    assert.equal(service.getExternalURL(), scheme + '://' + host + port + path);
    assert.equal(service.getInternalURL(), scheme + '://' + host + port + path);
    if( service.getName() !== 'proxy'){
        assert.equal(service.getExternalURLForRealm(account, realm), scheme + '://' + host + port + path + realmPath);
        assert.equal(service.getInternalURLForRealm(account, realm), scheme + '://' + host + port + path + realmPath);
    }
}

function devServiceCheck(service, scheme, externalHost, internalHost, path) {
    //console.log(service);
    assert(service);
    assert.equal(service.getScheme(), scheme);
    assert.equal(service.getHostname(), externalHost);
    assert.equal(service.getReferrer(), scheme + '://' + externalHost);
    assert.equal(service.getInternalHost(), scheme + '://' + internalHost);
    assert.equal(service.getExternalURL(), scheme + '://' + externalHost + path);
    assert.equal(service.getInternalURL(), scheme + '://' + internalHost + path);
    if( service.getName() !== 'proxy'){
        assert.equal(service.getExternalURLForRealm(account, realm), scheme + '://' + externalHost + path + realmPath);
        assert.equal(service.getInternalURLForRealm(account, realm), scheme + '://' + internalHost + path + realmPath);
    }
}

describe(title, function () {

    describe('env', function () {

        it('basic', function (done) {
            assert(env);
            //console.log(env);
            assert(env.usingAuthProxy() === false);
            assert(env.isLocalhost() === true);
            assert(env.isProduction() === false);
            assert(env.getHostname);
            assert(env.getHostname() === env.HOSTNAMES.LOCALHOST);
            done();
        });

    });

    describe('localhost', function () {

        it('configure', function (done) {
            env.hostname = 'localhost';
            done();
        });

        it('proxy', function (done) {
            var serviceName = 'proxy';
            var service = env.getService(serviceName);
            localhostServiceCheck(service, 'http', 'localhost', ':55010', '');
            done();
        });

        it('auth', function (done) {
            var serviceName = 'auth';
            var service = env.getService(serviceName);
            localhostServiceCheck(service, 'http', 'localhost', ':55010', '/' + serviceName);
            done();
        });

        it('locate', function (done) {
            var serviceName = 'locate';
            var service = env.getService(serviceName);
            localhostServiceCheck(service, 'http', 'localhost', ':55020', '/' + serviceName);
            done();
        });

        it('context', function (done) {
            var serviceName = 'context';
            var service = env.getService(serviceName);
            localhostServiceCheck(service, 'http', 'localhost', ':55060', '/' + serviceName);
            done();
        });

        it('docs', function (done) {
            var serviceName = 'docs';
            var service = env.getService(serviceName);
            localhostServiceCheck(service, 'http', 'localhost', ':55080', '/' + serviceName);
            done();
        });

        it('push', function (done) {
            var serviceName = 'push';
            var service = env.getService(serviceName);
            localhostServiceCheck(service, 'http', 'localhost', ':8080', '/' + serviceName + '/rest');
            done();
        });

        it('db', function (done) {
            var serviceName = 'db';
            var service = env.getService(serviceName);
            localhostServiceCheck(service, 'mongodb', 'localhost', ':27017', '');
            done();
        });

    });


    describe('authproxy', function () {

        it('configure', function (done) {
            env.setUsingAuthProxy(true);
            done();
        });

        it('proxy', function (done) {
            var serviceName = 'proxy';
            var service = env.getService(serviceName);
            localhostServiceCheck(service, 'http', 'localhost', ':55010', '');
            done();
        });

        it('auth', function (done) {
            var serviceName = 'auth';
            var service = env.getService(serviceName);
            localhostServiceCheck(service, 'http', 'localhost', ':55010', '/' + serviceName);
            done();
        });

        it('locate', function (done) {
            var serviceName = 'locate';
            var service = env.getService(serviceName);
            localhostServiceCheck(service, 'http', 'localhost', ':55010', '/' + serviceName);
            done();
        });

        it('context', function (done) {
            var serviceName = 'context';
            var service = env.getService(serviceName);
            localhostServiceCheck(service, 'http', 'localhost', ':55010', '/' + serviceName);
            done();
        });

        it('docs', function (done) {
            var serviceName = 'docs';
            var service = env.getService(serviceName);
            localhostServiceCheck(service, 'http', 'localhost', ':55010', '/' + serviceName);
            done();
        });

        it('push', function (done) {
            var serviceName = 'push';
            var service = env.getService(serviceName);
            localhostServiceCheck(service, 'http', 'localhost', ':55010', '/' + serviceName + '/rest');
            done();
        });

        it('db', function (done) {
            var serviceName = 'db';
            var service = env.getService(serviceName);
            localhostServiceCheck(service, 'mongodb', 'localhost', ':27017', '');
            done();
        });

    });


    describe('dev', function () {

        it('configure', function (done) {
            env.setHostname('dev.bridgeit.io');
            done();
        });

        it('proxy', function (done) {
            var serviceName = 'proxy';
            var service = env.getService(serviceName);
            devServiceCheck(service, 'http', 'dev.bridgeit.io', 'web1', '');
            done();
        });

        it('auth', function (done) {
            var serviceName = 'auth';
            var service = env.getService(serviceName);
            devServiceCheck(service, 'http', 'dev.bridgeit.io', 'web1', '/' + serviceName);
            done();
        });

        it('locate', function (done) {
            var serviceName = 'locate';
            var service = env.getService(serviceName);
            devServiceCheck(service, 'http', 'dev.bridgeit.io', 'web1', '/' + serviceName);
            done();
        });

        it('context', function (done) {
            var serviceName = 'context';
            var service = env.getService(serviceName);
            devServiceCheck(service, 'http', 'dev.bridgeit.io', 'web1', '/' + serviceName);
            done();
        });

        it('docs', function (done) {
            var serviceName = 'docs';
            var service = env.getService(serviceName);
            devServiceCheck(service, 'http', 'dev.bridgeit.io', 'web1', '/' + serviceName);
            done();
        });

        it('push', function (done) {
            var serviceName = 'push';
            var service = env.getService(serviceName);
            devServiceCheck(service, 'http', 'dev.bridgeit.io', 'web1', '/' + serviceName + '/rest');
            done();
        });

        it('db', function (done) {
            var serviceName = 'db';
            var service = env.getService(serviceName);
            devServiceCheck(service, 'mongodb', 'dev.bridgeit.io', 'db1:27017', '');
            done();
        });

    });


});


