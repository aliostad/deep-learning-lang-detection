'use strict';

var compassDirective = require('./directives/compassDirective');
var lazyImageDirective = require('./directives/lazyImageDirective');
var StringUtilService = require('./services/StringUtilService');
var PostalOracleService = require('./services/PostalOracleService');
var PersistenceService = require('./services/PersistenceService');
var DateUtilsService = require('./services/DateUtilsService');
var RoutingService = require('./services/RoutingService');
var RandomService = require('./services/RandomService');
var ServerTime = require('./services/ServerTime');
var ItemStorageService = require('./services/ItemStorageService');
var TrayStorageService = require('./services/TrayStorageService');
var PageLockService = require('./services/PageLockService');
var LastPageService = require('./services/LastPageService');
var EnvironmentService = require('./services/EnvironmentService');
var NumberFixedLength = require('./filters/numberFixedLength');

module.exports = angular.module('common', [])
  .directive('compass', compassDirective)
  .directive('lazyImage', lazyImageDirective)
  .service('StringUtilService', StringUtilService)
  .service('PostalOracleService', PostalOracleService)
  .service('PersistenceService', PersistenceService)
  .service('DateUtilsService', DateUtilsService)
  .service('RoutingService', RoutingService)
  .service('TrayStorageService', TrayStorageService)
  .service('ItemStorageService', ItemStorageService)
  .service('RandomService', RandomService)
  .service('PageLockService', PageLockService)
  .service('LastPageService', LastPageService)
  .service('EnvironmentService', EnvironmentService)
  .service('ServerTime', ServerTime)
  .filter('numberFixedLength', NumberFixedLength);
