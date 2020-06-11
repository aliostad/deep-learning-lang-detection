var locomotive = require('locomotive'),
    request = require('request'),
    async = require('async'),
    CachedPayload = require('../models/cachedpayload');

var TorqueController = new locomotive.Controller();

TorqueController.main = function () {
    var controller = this;
    controller.render();
    /*CachedPayload.savePayload('torque', controller.req.query, function (err, results) {
        if (err) {
            controller.error(err);
        }
    });
    console.log(controller.req.query);
    controller.res.send('OK!');*/
};

module.exports = TorqueController;