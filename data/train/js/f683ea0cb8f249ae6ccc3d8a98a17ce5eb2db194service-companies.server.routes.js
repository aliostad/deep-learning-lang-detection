'use strict';

module.exports = function(app) {
	var users = require('../../app/controllers/users.server.controller');
	var serviceCompanies = require('../../app/controllers/service-companies.server.controller');

	// Service companies Routes
	app.route('/service-companies')
		.get(serviceCompanies.list)
		.post(users.requiresLogin, serviceCompanies.create);

	app.route('/service-companies/:serviceCompanyId')
		.get(serviceCompanies.read)
		.put(users.requiresLogin, serviceCompanies.hasAuthorization, serviceCompanies.update)
		.delete(users.requiresLogin, serviceCompanies.hasAuthorization, serviceCompanies.delete);

	// Finish by binding the Service company middleware
	app.param('serviceCompanyId', serviceCompanies.serviceCompanyByID);
};
