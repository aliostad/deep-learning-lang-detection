/**
 * Web Service Manager, configures traffic using interceptors and is responsible
 * for every request going out
 */
define([
  'shared/webServiceManager/namespace',
  'shared/webServiceManager/service/SessionManagementService',
  'shared/webServiceManager/service/PollManagementService',
  'shared/webServiceManager/config/setup'],
  function(namespace, sessionManagementService, pollManagementService, setup) {
    var module = angular.module(namespace, []);
    sessionManagementService(module);
    pollManagementService(module);
    setup(module);
  });
