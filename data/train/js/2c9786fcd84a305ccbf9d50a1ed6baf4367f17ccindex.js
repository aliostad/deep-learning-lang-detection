'use strict';

var express = require('express');
var controller = require('./spin.controller');

var router = express.Router();

router.get('/', controller.index);
router.post('/insert', controller.insert);
router.get('/:id', controller.show);
router.post('/', controller.create);
router.put('/:id', controller.update);
router.patch('/:id', controller.update);
router.delete('/:id/remove', controller.remove);
router.delete('/:id', controller.destroy);
router.put('/:id/move', controller.move);

module.exports = router;