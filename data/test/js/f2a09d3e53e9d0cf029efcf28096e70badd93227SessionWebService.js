/**
 * @class SessionWebService
 *
 * @author: darryl.west@roundpeg.com
 * @created: 10/28/14 7:51 AM
 */
var serviceName = 'SessionWebService',
    AbstractWebService = require('node-service-commons').services.AbstractWebService;

var SessionWebService = function(options) {
    'use strict';

    var service = this,
        log = options.log,
        dataService = options.dataService,
        modelName = options.modelName,
        domain = options.domain;

    AbstractWebService.extend( this, options );

    this.serviceName = options.serviceName || serviceName;
};

SessionWebService.SERVICE_NAME = serviceName;

module.exports = SessionWebService;