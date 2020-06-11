'use strict';

const express = require('express');
const service = express();
const ServiceRegistry = require('./serviceRegistry');
const serviceRegistry = new ServiceRegistry();

service.set('serviceRegistry', serviceRegistry);

service.put('/service/:intent/:port', (req, res, next) => {
    const serviceIntent = req.params.intent;
    const servicePort = req.params.port;

    const serviceIp = req.connection.remoteAddress.includes('::') ? `[${req.connection.remoteAddress}]` : req.connection.remoteAddress;

    serviceRegistry.add(serviceIntent, serviceIp, servicePort);
    res.json({ result: `${serviceIntent} at ${serviceIp}:${servicePort}` });
})
module.exports = service;
