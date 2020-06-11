var _ = require('lodash');

var Service = require('../models/Service');
var ServiceType = require('../models/ServiceType');
var ServiceStatus = require('../models/ServiceStatus');

/**
 * GET /
 * Home page.
 */
exports.index = (req, res) => {
    Service.find({})
        .populate('type')
        .populate('status')
        .sort({timestamp: -1})
        .exec((err, list) => {
            "use strict";
            res.render('home', {
                title: 'Service status',
                services: list
            });
        });
};

exports.postCreateService = function (req, res) {
    var name = req.body.name;
    var address = req.body.address;
    var serviceType = "210d1d22be018c1121025be1";
    var serviceStatus = "530d1d22be018c1121025be1";

    var service = new Service({ name: name, url: address, type: serviceType, status: serviceStatus });
    service.save(function (err) {
        if (err) {
            req.flash('errors', { msg: err.message });
            res.redirect('/');
        } else {
            req.flash('success', { msg: 'Service added!' });
            res.redirect('/');
        }
    });
};
