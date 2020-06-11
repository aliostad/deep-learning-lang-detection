'use strict';

var injct = require('injct'),
    util = require('util');

/**
 * Init all dependency injection references
 */
exports.init = function (cb) {

    console.log('Setting up dependencies');

    setupDependencies(function() {

       // injct.getInstance('redisExpireNotificationService')
       //     .monitorExpiredKeys();

       // new DatabaseSetup(cb);
        cb();
    });

};

/**
 * Setup dependencies
 *
 * @param cb
 */
function setupDependencies(cb) {

    injct.unique({
        accountService: reqService('AccountService'),
        accountRepository: reqRepository('AccountRepository'),
        bookingService: reqService('BookingService'),
        bookingRepository: reqRepository('BookingRepository'),
        formService: reqService('FormService'),
        formRepository: reqRepository('FormRepository'),
        locationService: reqService('LocationService'),
        locationRepository: reqRepository('LocationRepository'),
        providerService: reqService('ProviderService'),
        providerRepository: reqRepository('ProviderRepository'),
        serviceRepository: reqRepository('ServiceRepository'),
        serviceService: reqService('ServiceService'),
        scheduleRepository: reqRepository('ScheduleRepository'),
        scheduleService: reqService('ScheduleService'),
        timeSlotRepository: reqRepository('TimeSlotRepository'),
        timeSlotService: reqService('TimeSlotService'),
        userRepository: reqRepository('UserRepository'),
        userService: reqService('UserService'),
        widgetRepository: reqRepository('widgetRepository'),
        widgetService: reqService('widgetService')
    });

    console.log('Setup dependencies');

    if (cb) {
        cb();
    }
}
exports.setupDependencies = setupDependencies;


/**
 * Helper to require a service
 *
 * @param service
 * @returns {*}
 */
function reqService(service) {
    return req(util.format('/services/%s.js', service));
}

/**
 * Helper to require a repository
 *
 * @param repository
 * @returns {*}
 */
function reqRepository(repository) {
    return req(util.format('/repository/%s.js', repository));
}

/**
 * Helper to require relative to app
 *
 * @param pkg
 * @returns {*}
 */
function req(pkg) {
    return require('../../app' + pkg);
}