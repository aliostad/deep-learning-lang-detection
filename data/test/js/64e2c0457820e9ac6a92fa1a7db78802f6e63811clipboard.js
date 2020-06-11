'use strict';

/* Directives */
var clipboardModule = angular.module('myApp.clipboard', ['ngRoute', 'ngResource']);

clipboardModule.run(['ClipboardService', function(clipboardService) {
}]);

clipboardModule.factory('ClipboardService', ['$rootScope', '$http', 'Storage', function($rootScope, $http, Storage) {
  var service = {};
  service.content = null;
  
  service.init = function() {
  };
  
  service.setContent = function(content) {
    service.content = content;
  };
  
  service.setContent = function(content) {
    return service.content;
  };
  
  service.copy = function(content) {
    service.setContent(content);
  };
  
  service.paste = function(content) {
    return service.content;
  };
  
  return service;
  
}]);