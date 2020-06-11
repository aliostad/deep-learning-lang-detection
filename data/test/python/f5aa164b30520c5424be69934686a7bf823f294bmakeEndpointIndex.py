__author__ = 'harshpatel'
def fill(path,endpoint):
    file = open(path +'/index.js', 'w')
    data = """
'use strict';

var express = require('express');
var controller = require('./%s.controller');

var router = express.Router();

router.get('/', controller.index);
router.get('/:id', controller.show);
router.post('/', controller.create);
router.put('/:id', controller.update);
router.patch('/:id', controller.update);
router.delete('/:id', controller.destroy);

module.exports = router;
""" %(endpoint["name"])
    file.write(data)