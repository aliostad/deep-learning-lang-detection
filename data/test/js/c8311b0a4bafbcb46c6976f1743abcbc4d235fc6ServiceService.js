'use strict';

var Service = require('../models/Service.js'),
    Injct = require('injct'),
    _ = require('underscore'),
    Constants = require('../util/Constants.js'),
    Logger = require('../util/Logger.js'),
    Util = require('util');

/**
 * ServiceService constructor
 *
 * @constructor
 */
var ServiceService = function (serviceRepository) {

    this.serviceRepository = serviceRepository;
    Injct.apply(this);
};
module.exports = ServiceService;


/**
 * Get service from mongo
 *
 * @param id string
 * @param callback
 */
ServiceService.prototype.getServiceById = function (_id, callback) {
    this.serviceRepository.getServiceById(_id, callback);
};

/**
 * Get services by account id
 *
 * @param account_id string
 * @param callback
 */
ServiceService.prototype.getServicesByAccountId = function (account_id, callback) {
    this.serviceRepository.getServicesByAccountId(account_id, callback);
};


/**
 * Update a service
 *
 * @param {Service} service
 * @param {Function} callback
 */
ServiceService.prototype.updateService = function(service, callback) {
    this.serviceRepository.saveService(service, callback);
};
