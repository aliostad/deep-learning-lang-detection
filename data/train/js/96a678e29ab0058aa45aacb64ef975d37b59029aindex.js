var express = require('express');
var router = express.Router();

var UsersController = require('../controller/UsersController');
var UtilController = require('../controller/UtilController');

router.post('/deploy', UtilController.update.bind());
router.get('/users', UsersController.findAll.bind(UsersController));
router.get('/users/:_id', UsersController.findOne.bind(UsersController));
router.post('/users', UsersController.create.bind(UsersController));
router.put('/users/:_id', UsersController.update.bind(UsersController));
router.delete('/users/:_id', UsersController.delete.bind(UsersController));

module.exports = router;