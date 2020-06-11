'use strict';

var express = require('express'),
    controller = require('./attribute.controller'),
    router = express.Router();

router.get('/', controller.index);
router.get('/:id', controller.getOne);
router.get('attribute/:attributeId', controller.attributeByAttributeId);
router.get('/staticdata/list', controller.getStaticData);
router.post('/search', controller.search);
router.post('/', controller.create);
router.put('/:id', controller.update);
router.delete('/:id', controller.destroy);
module.exports = router;
