'use strict';
var express = require('express');
var router  = express.Router();
var Service = require('../models/service');
var Request = require('../models/request');
var isAdmin = require('../utility/isAdmin.js')

// services.json/...
router.get('/', listServices);
router.get(':serviceCode.json', getServiceDescription);
router.get('/metadata', getMetadata);

router.post('/', addService);
router.post('/delete', isAdmin, deleteService);
router.post('/update', updateService);

// provide a list of acceptable 311 service request types and their associated service codes. 
function listServices(req, res) {
	// The route might end up here with /services, which is invalid.
	if (req.originalUrl === '/services') {
		res.send400('You must define a service code.');
		return;
	}

	Service.find(function (error, services){
		if (error){
			res.send('Error finding service request types.');
		} else if (services.length === 0) {
			res.send404('Could not find any services.');
		} else {
			res.send(services);
		}
	});
}

function getServiceDescription(req, res){
	var serviceCode = req.params.serviceCode;

	if (typeof serviceCode === 'undefined') {
		res.send400('You need to provide a service code to search for.');
	}

	Service.find({service_code: serviceCode}, function serviceFound(err, result){
		if (result.length === 0) {
			res.send404('Could not find a service with that code.');
		} else {
			res.send(result);
		}
	});
}

function addService(req, res) {
	var service = new Service(req.body);

	service.save(function serviceSaved (error, service) {
		if (error) {
			res.send500('Error while trying to save the service.');
		}
		console.log('service.service_code', service.service_code);
		if (isUndefined(service.service_code)) {
			Service.findByIdAndUpdate(service._id, {$set:{service_code:service._id}}, function (error, service){
				if (error) {
					res.send500('Error while trying to save the service code.');
				} else {
					res.send(service);
				}
			});
		} else {
			res.send(service)
		}
	});
}

function updateService(req, res) {
	Service.findByIdAndUpdate(req.body._id, {$set: req.body}, function (error, service){
		if (error) {
			res.send500('Error while searching for service.')
		} else if (!service) {
			res.send404('Service not found.')
		} else {
			res.send(service)
		}
	});
}	

function deleteService (req, res) {
	Service.findByIdAndRemove(req.body.id, function(error) {
		if (error) {
			res.send500('Could not remove. Service may not exist, or some other error.');
		} else {
			res.send('Service deleted.');
		}
	});
}

function getMetadata (req, res) {
	var results = {};
	var servicesDone = 0;
	Service.find(function(error, services){
		services.forEach(function (service) {
			Request.count({service_code: service.service_code, status:'open'}, function(error, openCount) {
				results[service.service_code] = {};
				results[service.service_code].openCount = openCount;
				Request.count({service_code: service.service_code, status: 'closed'}, function(error, closedCount) {
					results[service.service_code].closedCount = closedCount;
					results[service.service_code].total = openCount + closedCount;
					servicesDone++;
					if (servicesDone === services.length) {
						res.send(results);
					}
				});
			});
		});
	});
}

module.exports = router;