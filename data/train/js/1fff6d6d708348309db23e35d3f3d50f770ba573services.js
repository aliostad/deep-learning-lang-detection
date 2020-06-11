/**
 * Created by K on 11/1/2016.
 */
var express = require('express');
var router = express.Router();
var Service = require('../models/service');

/**Request
 * body
 *  service_id
 *  service_name
 *  service_price
 * */
/**Response
 * service
 */

router.post('/create', function (req, res) {
    var service_name = req.body.service_name;
    var service_price = req.body.service_price;
    var service_desciption = req.body.service_desciption;
    var newService = new Service({
        service_name: service_name,
        service_price: service_price,
        service_desciption : service_desciption
    });

    Service.createService(newService, function (err, service) {
        if (err) throw err;
        res.json({
            success: true,
            msg: "Successfully Create Service",
            data: service
        });
    });
});

/**Request
 * param
 *  service_id
 * */
/**Response
 * service
 */

router.get('/findinfo/:id', function (req, res) {
    Service.getServiceById(req.params.id, function (err, service) {
        if (err) throw err;
        res.json({
            success: true,
            data: service
        });
    });
});

/**Request
 * param
 *  service_name
 * */
/**Response
 * service
 */

router.get('/findname/:name', function (req, res) {
    Service.getServiceByName(req.params.name, function (err, service) {
        if (err) throw err;
        res.json({
            success: true,
            data: service
        });
    });
});

/**Request
 * param
 *  service_price
 * */
/**Response
 * services
 */

router.get('/findprice/:price', function (req, res) {
    Service.getServiceByPrice(req.params.price, function (err, services) {
        if (err) throw err;
            res.json({
                success: true,
                msg: 'Service was found!',
                data: services
            });
    });
});

/**Request
 * param
 *  service_id
 *  body
 *  service_name
 *  service_desciption
 *  servce_price
 * */
/**Response
 * service
 */
router.put('/updateinfo/:id', function (req, res) {
    Service.getServiceById(req.params.id, function (err, service) {
        if (err) throw err;
        service.service_name = req.body.service_name;
        service.service_desciption = req.body.service_desciption;
        service.service_price = req.body.service_price;
        Service.createService(service, function (err, service) {
            if (err) throw err;
            res.json({
                success: true,
                msg: "Update Successfully!",
                data: service
            });
        });
    });
});

/**Request
 * param
 *  service_name
 * */
/**Response
 * service
 */

router.get('/findall', function (req, res) {
    Service.findAll(err,function(err,service){
        if(err) throw err;
        res.json({
            success : true,
            data : service
        });
    });
});

router.delete('/deleteservice/:id', function (req, res) {
    Service.removeService(req.params.id, function (err) {
        if (err) throw err;
        res.json({
            success: true,
            msg: "Delete successfully!"
        });
    });
});


module.exports = router;
