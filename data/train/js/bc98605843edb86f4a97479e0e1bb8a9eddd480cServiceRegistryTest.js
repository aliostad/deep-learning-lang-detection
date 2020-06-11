var expect = require('chai').expect;

var serviceRegistry = require("../");
serviceRegistry.registerService("default-service", {});

describe("service registry", function() {
	it("is a singleton", function() {
		var serviceRegistry = require("../");
		expect(serviceRegistry.isServiceRegistered("default-service")).to.be.true;
	});
	it("can register a service", function() {
		var serviceRegistry = require("../");
		serviceRegistry.registerService("service1", {});
		expect(serviceRegistry.isServiceRegistered("service1")).to.be.true;
	});
	it("can deregister a service", function() {
		var serviceRegistry = require("../");
		serviceRegistry.registerService("service2", {});
		expect(serviceRegistry.isServiceRegistered("service2")).to.be.true;
		serviceRegistry.deregisterService("service2");
		expect(serviceRegistry.isServiceRegistered("my-service")).to.be.false;
	});
});