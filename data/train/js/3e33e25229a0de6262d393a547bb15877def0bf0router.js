var express = require('express');
var Controller = require(__dirname+'/controller');

function Router(model, singular, plural) {
  if (!plural) {
    var plural = singular+'s';
  }

  var controller = new Controller(model, singular, plural);
  var router = new express.Router();

  router.post('', controller.create.bind(controller));
  router.get('', controller.index.bind(controller));
  router.get('/:id', controller.show.bind(controller));
  router.put('/:id', controller.update.bind(controller));
  router.delete('/:id', controller.destroy.bind(controller));
  
  return router;
}

module.exports = Router;

