/* global describe, beforeEach, it, xit */

var expect = require('chai').expect;

var ServiceRegistryClass = require("../src/ServiceRegistryClass");
var sprintf = require("sprintf-js").sprintf;

var MESSAGES = ServiceRegistryClass.LOG_MESSAGES;

var TestServiceClass = function(int) {
	this.int = int;
}

describe("service registry class", function() {
	var serviceRegistry;
	beforeEach(function() {
		serviceRegistry = new ServiceRegistryClass();
	});
	describe("#getService", function() {
		it("throws an error if a service hasnt been registered", function() {
			expect(
				serviceRegistry.getService.bind(serviceRegistry, 'my.service')
			).to.throw(
				sprintf(MESSAGES.SERVICE_NOT_REGISTERED, 'my.service')
			);
		});
		it("returns the service that has been registered", function() {
			var myService = new TestServiceClass(1);
			serviceRegistry.registerService('my.service', myService);		
			expect( serviceRegistry.getService('my.service') ).to.be.equal(myService);
		});
		it("returns same service instance that has been registered", function() {
			var myService = new TestServiceClass(1);
			serviceRegistry.registerService('my.service', myService);
			myService.int = 1234;		
			expect( serviceRegistry.getService('my.service').int ).to.be.equal(1234);
		});
		xit("uses alias registry to access service impementations", function() {	
			var MyService = function() {};
			var aliasRegistry = require('app-alias-registry');
			aliasRegistry._aliasData = {'my.service': {'class': 'MyService', 'className': 'my.Service'}};
			assertTrue(ServiceRegistry.getService('my.service') instanceof MyService);
		});
		xit("returns the same instance if an alias was used to construct the service", function() {	
			var MyService = function() {
				this.val = 1;
			};
			var aliasRegistry = require('br/AliasRegistry');
			aliasRegistry._aliasData = {'my.service': {'class': 'MyService', 'className': 'my.Service'}};
			assertTrue(ServiceRegistry.getService('my.service') instanceof MyService);
			MyService.val = 1234;
			assertTrue(ServiceRegistry.getService('my.service') == 1234);
		});
	});
	describe("#registerService", function() {
		it("throws an error if no instance is provided", function() {
			expect(
				serviceRegistry.registerService.bind(serviceRegistry, 'my.service', undefined)
			).to.throw(
				MESSAGES.INSTANCE_UNDEFINED
			);
		});
		it("throws an error if a service has already been registered", function() {
			serviceRegistry.registerService('my.service', {});
			expect(
				serviceRegistry.registerService.bind(serviceRegistry, 'my.service', undefined)
			).to.throw(
				sprintf(MESSAGES.SERVICE_REGISTERED, 'my.service')
			);
		});
	});
	describe("#isServiceRegistered", function() {
		it("returns true if the service has been registered", function() {
			expect( serviceRegistry.isServiceRegistered('my.service') ).to.be.false;
		});
		it("returns false if the service has not been registered", function() {
			expect( serviceRegistry.isServiceRegistered('my.service') ).to.be.false;
			serviceRegistry.registerService('my.service', {});
			expect( serviceRegistry.isServiceRegistered('my.service') ).to.be.true;
		});
	});
	describe("#deregisterService", function() {
		it("allows services to be deregistered", function() {
			serviceRegistry.registerService('my.service', {});
			expect( serviceRegistry.isServiceRegistered('my.service') ).to.be.true;
			serviceRegistry.deregisterService('my.service');
			expect( serviceRegistry.isServiceRegistered('my.service') ).to.be.false;
		});
		it("completed removes service", function() {
			serviceRegistry.registerService('my.service', {});
			expect( serviceRegistry.isServiceRegistered('my.service') ).to.be.true;
			serviceRegistry.deregisterService('my.service');
			expect(
				serviceRegistry.getService.bind(serviceRegistry, 'my.service')
			).to.throw(
				sprintf(MESSAGES.SERVICE_NOT_REGISTERED, 'my.service')
			);
		});
		it("allows services to be removed and reregistered", function() {
			var myService = new TestServiceClass(1234);
			serviceRegistry.registerService('my.service', myService);
			serviceRegistry.deregisterService('my.service');
			myService = new TestServiceClass(6789);
			serviceRegistry.registerService('my.service', myService);
			expect( serviceRegistry.getService('my.service').int ).to.be.equal(6789);
		});
		it("throws an error if the service hasnt been registered", function() {
			expect(
				serviceRegistry.deregisterService.bind(serviceRegistry, 'my.service')
			).to.throw(
				sprintf(MESSAGES.SERVICE_NOT_REGISTERED, 'my.service')
			);
		});
	});
	describe("#dispose", function() {
		it("clears the registry", function() {
			serviceRegistry.registerService('service1', {});
			serviceRegistry.registerService('service2', {});
			serviceRegistry.dispose();
			expect( serviceRegistry.isServiceRegistered('service1') ).to.be.false;
			expect( serviceRegistry.isServiceRegistered('service2') ).to.be.false;
		});
		xit("calls dispose on registered services", function () {
			var serviceInterface = { dispose: function(){} };
			var mockService1 = mock(serviceInterface);
			var mockService2 = mock(serviceInterface);
			
			serviceRegistry.registerService('mock.service.1', mockService1);
			serviceRegistry.registerService('mock.service.2', mockService2);
			
			serviceRegistry.dispose();
	
			verify(mockService1).dispose();
			verify(mockService2).dispose();
			verify(logStore).onLog(anything(), 'debug', [ServiceRegistryClass.LOG_MESSAGES.DISPOSE_CALLED, 'mock.service.1']);
			verify(logStore).onLog(anything(), 'debug', [ServiceRegistryClass.LOG_MESSAGES.DISPOSE_CALLED, 'mock.service.2']);
		});
		xit("calls dispose on registered services even if first throws an error on dispose", function () {
			var serviceInterface = { dispose: function(){} };
			var mockService1 = mock(serviceInterface);
			var mockService2 = mock(serviceInterface);
			
			ServiceRegistry.registerService('mock.service.1', mockService1);
			ServiceRegistry.registerService('mock.service.2', mockService2);
			
			when(mockService1).dispose().thenThrow("ERROR!");
			
			ServiceRegistry.dispose();
	
			verify(mockService1).dispose();
			verify(mockService2).dispose();
			verify(logStore).onLog(anything(), 'error', [ServiceRegistryClass.LOG_MESSAGES.DISPOSE_ERROR, 'mock.service.1', "ERROR!"]);
			verify(logStore).onLog(anything(), 'debug', [ServiceRegistryClass.LOG_MESSAGES.DISPOSE_CALLED, 'mock.service.2']);
		});
		xit("does not call dispose on servies if service doesnt implement dispose method", function() {
			var serviceInterface = { };
			var mockService1 = mock(serviceInterface);
			
			ServiceRegistry.registerService('mock.service.1', mockService1);
			
			ServiceRegistry.dispose();
			
			verifyZeroInteractions(mockService1);
			verify(logStore).onLog(anything(), 'debug', [ServiceRegistryClass.LOG_MESSAGES.DISPOSE_MISSING, 'mock.service.1']);
		});
		xit("does not call dispose on services if service implements dispose method which accepts more than 0 args", function() {
			var disposeCalled = false; // this has to be done with a real object rather than mocks so service.dispose.length has the correct value
			var service = {
				dispose: function(arg1) {
					disposeCalled = true;
				}
			}
			
			ServiceRegistry.registerService('mock.service.1', service);
			
			ServiceRegistry.dispose();
			
			assertFalse(disposeCalled);
			verify(logStore).onLog(anything(), 'info', [ServiceRegistryClass.LOG_MESSAGES.DISPOSE_0_ARG, 'mock.service.1']);
		});
	});
});
