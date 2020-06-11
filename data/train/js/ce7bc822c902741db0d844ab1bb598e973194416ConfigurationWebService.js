/**
 * @class ConfigurationWebService
 *
 * @author: darryl.west@roundpeg.com
 * @created: 10/27/14 4:43 PM
 */
var serviceName = 'ConfigurationWebService',
    AbstractWebService = require('node-service-commons').services.AbstractWebService;

var ConfigurationWebService = function(options) {
    'use strict';

    var service = this,
        log = options.log,
        dataService = options.dataService,
        modelName = options.modelName,
        domain = options.domain;

    AbstractWebService.extend( this, options );

    this.serviceName = options.serviceName || serviceName;
};

ConfigurationWebService.SERVICE_NAME = serviceName;

module.exports = ConfigurationWebService;