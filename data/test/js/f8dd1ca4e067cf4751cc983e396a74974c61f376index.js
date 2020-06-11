'use strict';

var express = require('express');
var controller = require('./sentiment.controller');

var router = express.Router();

router.post('/getEntities', controller.showEntity);
router.post('/getSentiments', controller.showSentiment);
router.post('/getText', controller.showText);
router.post('/getAuthor', controller.showAuthor);
router.get('/getArticles', controller.showArticles);
router.get('/', controller.index);
router.get('/:id', controller.show);
router.post('/', controller.create);
router.put('/:id', controller.update);
router.patch('/:id', controller.update);
router.delete('/:id', controller.destroy);

module.exports = router;