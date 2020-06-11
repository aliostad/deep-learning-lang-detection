'use strict';

/**
 * ServiceProviderBuilder.
 *
 * @module zoologist
 */

var ServiceProvider = require('./ServiceProvider');

var DEFAULT_PROVIDER_STRATEGY = 'RoundRobin';

function ServiceProviderBuilder() {
  this.serviceProvider = {};
  this.strategy        = DEFAULT_PROVIDER_STRATEGY;
};

function builder() {
  return new ServiceProviderBuilder();
};

ServiceProviderBuilder.prototype.serviceDiscovery = function(serviceDiscovery) {
  this.serviceProvider.serviceDiscovery = serviceDiscovery;
  return this;
};

ServiceProviderBuilder.prototype.serviceName = function(serviceName) {
  this.serviceProvider.serviceName = serviceName;
  return this;
};

ServiceProviderBuilder.prototype.providerStrategy = function(strategy) {
  this.strategy = strategy;
  return this;
};

ServiceProviderBuilder.prototype.build = function() {
  return new ServiceProvider(
      this.serviceProvider.serviceDiscovery,
      this.serviceProvider.serviceName,
      this.strategy);
};

module.exports.builder = builder;
