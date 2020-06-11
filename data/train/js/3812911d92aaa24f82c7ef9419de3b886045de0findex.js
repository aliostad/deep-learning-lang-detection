'use strict';

var
  _                    = require('lodash'),
  TagsController       = require('../../controllers/TagsController'),
  controller           = new TagsController();



module.exports = function(router) {

  router.route('/tickets/tags')
    .get(controller.getAll.bind(controller))
    .post(controller.create.bind(controller));

  router.route('/tickets/tags/:id')
    .get(controller.getOne.bind(controller))
    .put(controller.update.bind(controller))
    .patch(controller.updatePartial.bind(controller))
    .delete(controller.delete.bind(controller));
};
