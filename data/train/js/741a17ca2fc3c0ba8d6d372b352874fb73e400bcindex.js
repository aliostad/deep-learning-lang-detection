'use strict';

var express = require('express');
var controller = require('./message.controller');


var router = express.Router();
//uncomment when finish
/*router.get('/', controller.index);*/
router.post('/', controller.index);
router.get('/:id', controller.show);
//uncomment when finish
//router.post('/', controller.create);
router.put('/:id', controller.update);
router.patch('/:id', controller.update);
router.delete('/:id', controller.destroy);
//just to test delete
//router.options('/', controller.index);
module.exports = router;