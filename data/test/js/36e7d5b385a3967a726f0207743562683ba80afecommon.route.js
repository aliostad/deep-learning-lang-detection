'use strict'

module.exports = function (module) {
    //    console.log(__dirname + '/common.controller')
    console.log(module);
    var express = require('express');
    var controller = require(__dirname + '/common.controller'); // require('./country.controller');

    controller.init(module);
    var router = express.Router();

    router.get('/', controller.index);
    router.get('/:id', controller.show);
    router.post('/', controller.create);
    router.put('/:id', controller.update);
    router.patch('/:id', controller.update);
    router.delete('/:id', controller.destroy);
}
