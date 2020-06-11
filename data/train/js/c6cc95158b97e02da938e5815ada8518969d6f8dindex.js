'use strict';

var express = require('express');
var controller = require('./instagram.controller');

var router = express.Router();

router.get('/', controller.index);
router.get('/:id', controller.show);
router.post('/', controller.create);
router.put('/:id', controller.update);
router.patch('/:id', controller.update);
router.delete('/:id', controller.destroy);

router.post('/tag', controller.tag);
router.post('/location', controller.bylocation);


router.get('/callback', controller.instCallback);
router.post('/callback', controller.postCallback);
router.get('/init', controller.init);

module.exports = router;