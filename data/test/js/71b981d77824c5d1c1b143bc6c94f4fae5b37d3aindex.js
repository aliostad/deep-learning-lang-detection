'use strict';

var usersController = require('../controllers/usersController'),
    gameTasksController = require('../controllers/gameTasksController'),
    gameAttacksController = require('../controllers/gameAttacksController'),
    gameObjectsController = require('../controllers/gameObjectsController'),
    gameMessagesController = require('../controllers/gameMessagesController'),
    gameReportsController = require('../controllers/gameReportsController');

module.exports = {
    users: usersController,
    gameObjects: gameObjectsController,
    gameTasks: gameTasksController,
    gameAttacks: gameAttacksController,
    gameReports: gameReportsController,
    gameMessages: gameMessagesController
};