'use strict';

var usersController = require('../controllers/usersController'),
    infoController = require('../controllers/infoController'),
    messagesController = require('../controllers/messagesController'),
    reportsController = require('../controllers/reportsController'),
    buildingsController = require('../controllers/buildingsController');

module.exports = {
    users: usersController,
    info: infoController,
    messages: messagesController,
    reports: reportsController,
    buildings : buildingsController
};