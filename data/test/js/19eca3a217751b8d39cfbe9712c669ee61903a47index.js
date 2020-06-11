// controllers
var home_controller = require('./home')
  , auth_controller = require('./auth')
  , people_controller = require('./people')
  , upload_controller = require('./upload')
  , topics_controller = require('./topics')
  , tags_controller = require('./tags')
  , comments_controller = require('./comments')
  , assets_controller = require('./assets');

// exports
exports.home_controller = home_controller;
exports.auth_controller = auth_controller;
exports.people_controller = people_controller;
exports.upload_controller = upload_controller;
exports.topics_controller = topics_controller;
exports.tags_controller = tags_controller;
exports.comments_controller = comments_controller;
exports.assets_controller = assets_controller;