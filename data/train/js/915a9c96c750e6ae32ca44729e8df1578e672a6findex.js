'use strict';

var express = require('express');
var controller = require('./item.controller');

var router = express.Router();

router.get('/', controller.index);
router.get('/cat', controller.category);
router.get('/catalogue', controller.catalogue);
router.get('/:id', controller.show);
router.post('/', controller.create);
router.put('/:id', controller.update);
router.put('/view/:id', controller.view);
router.put('/comment/:id', controller.addComment);
router.delete('/', controller.destroy);

module.exports = router;