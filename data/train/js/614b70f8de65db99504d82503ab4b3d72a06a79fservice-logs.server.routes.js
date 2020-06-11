'use strict';

module.exports = function(app) {
	var users = require('../../app/controllers/users.server.controller');
	var serviceLogs = require('../../app/controllers/service-logs.server.controller');

	// Service logs Routes
	app.route('/service-logs')
		.get(serviceLogs.list)
		.post(users.requiresLogin, serviceLogs.create);

	app.route('/service-logs/:serviceLogId')
		.get(serviceLogs.read)
		.put(users.requiresLogin, serviceLogs.hasAuthorization, serviceLogs.update)
		.delete(users.requiresLogin, serviceLogs.hasAuthorization, serviceLogs.delete);

	// Finish by binding the Service log middleware
	app.param('serviceLogId', serviceLogs.serviceLogByID);
};
