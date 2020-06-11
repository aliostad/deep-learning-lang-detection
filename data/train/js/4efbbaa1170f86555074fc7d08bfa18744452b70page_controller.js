var home_controller = require('./home_controller');
var contents_controller = require('./contents_controller');
var comments_controller = require('./comments_controller');
var local_account_controller = require('./local_account_controller');
var facebook_account_controller = require('./facebook_account_controller');
var profile_controller = require('./profile_controller');
var register_controller = require('./register_controller');

module.exports = function (app, passport) {
  home_controller(app, passport);
  contents_controller(app, passport);
  comments_controller(app, passport);
  local_account_controller(app, passport);
  facebook_account_controller(app, passport);
  profile_controller(app, passport);
  register_controller(app, passport);
}
