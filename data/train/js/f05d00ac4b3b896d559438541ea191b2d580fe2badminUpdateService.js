var express = require('express');
var router = express.Router();
var OurService = require('../../../models/ourService');
var fs = require('fs');

router.post('/', (req, res, next) => {
    console.log('This is Update Service: ' + JSON.stringify(req.body));

    var serviceId = req.body.serviceId;
    var serviceName = req.body.serviceName;
    var serviceSlogan = req.body.serviceSlogan;
    var serviceShortInformation = req.body.serviceShortInformation;
    var serviceFullInformation = req.body.serviceFullInformation;
    var serviceImagePath = req.body.serviceImagePath;

    console.log('id: ' + serviceId + '\nName: ' + serviceName + '\nslogan: ' + serviceSlogan + '\ncategory: ' + '\nshort info: ' + serviceShortInformation + '\nfull Info: ' + serviceFullInformation + '\nimagePath: ' + serviceImagePath);

    OurService.findById(serviceId, (err, service) => {
        if(err) {
            console.log('Error in finding the desired service: ' + err);
            res.redirect('/adminServiceList');
        } else {
            service.serviceName = serviceName;
            service.serviceSlogan = serviceSlogan;
            service.serviceShortInformation = serviceShortInformation;
            service.serviceFullInformation = serviceFullInformation;
            service.serviceImagePath = serviceImagePath;

            service.save((err) => {
                if(err) {
                    console.log('Error in updating service: ' + err);
                } else {
                    console.log('Service updated successfullt');
                }
                res.redirect('/adminServiceList');
            });
        }
    });
});

module.exports = router;