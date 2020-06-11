/**
 * @class MarkupWebService
 * @classdesc the majority of work is done in the abstract class.  this concrete
 * implementation provides a platform to extend or override methods, routes, etc
 *
 * @author: darryl.west@raincitysoftware.com
 * @created: 8/12/14 7:58 PM
 */
var serviceName = 'AccessWebService',
    AbstractWebService = require('node-service-commons').services.AbstractWebService;

var AccessWebService = function(options) {
    'use strict';

    var service = this,
        log = options.log,
        dataService = options.dataService,
        modelName = options.modelName,
        domain = options.domain;

    AbstractWebService.extend( this, options );

    this.serviceName = options.serviceName || serviceName;

};

AccessWebService.SERVICE_NAME = serviceName;

module.exports = AccessWebService;
