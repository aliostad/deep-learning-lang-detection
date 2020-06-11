'use strict';

var express = require('express');
var controller = require('./card.controller');

var router = express.Router();

router.get('/', controller.index);
router.get('/info', controller.info);
router.get('/upgrade', controller.upgrade);
router.get('/types/:type', controller.show);
router.get('/:id', controller.show);
router.post('/', controller.create);
router.put('/:id', controller.update);
router.patch('/:id', controller.update);
router.delete('/:id', controller.destroy);

module.exports = router;
