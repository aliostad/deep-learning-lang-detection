var express = require('express');
var router = express.Router();
var OurService = require('../../../models/ourService');
var fs = require('fs');

router.get('/:serviceId', function(req, res, next) {
    var serviceId = req.params.serviceId;
    console.log('Deleting the Service: ' + serviceId);

    OurService.findById(serviceId, (err, myService) => {
        if(err) {
            console.log('Error in finding the service: ' + err);
            res.redirect('/adminServiceList');
        } else {
            console.log('Name: ' + myService.serviceName);
            console.log('Image path : ./public' +  myService.serviceImagePath);
            console.log('Id: ' + myService._id);
            myService.remove((err, success) => {
                if(err) {
                    console.log('Error in removing the Service: ' + err);
                } else {
                    console.log('Service Removed successfully.');
                    fs.unlink('./public' + myService.serviceImagePath, (err) => {
                        if (err) {
                            console.log('Error in removing service image file: ' + myService.serviceImagePath + " error: " + err);
                        } else {
                            console.log('Removed image file: ' + myService.serviceImagePath);
                        }
                        res.redirect('/adminServiceList');
                    });
                }
            });
        }
    });
});

module.exports = router;