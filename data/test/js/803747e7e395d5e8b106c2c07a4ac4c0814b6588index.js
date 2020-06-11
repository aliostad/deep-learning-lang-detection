'use strict';

var express = require('express');
var controller = require('./event.controller');

var router = express.Router();

router.get('/', controller.index);
router.get('/:id', controller.show);

router.post('/', controller.create);

router.put('/:id/register', controller.register);
router.put('/:id/unregister', controller.unregister);
router.put('/:id/updateregistration', controller.updateregistration);

router.put('/:id', controller.update);


router.delete('/:id', controller.destroy);

module.exports = router;
