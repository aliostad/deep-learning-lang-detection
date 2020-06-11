'use strict';

var angular = require('angular');

var UsersAdminModule = angular.module('broker.admin.users', [])
  .controller('UsersAdminController', require('./users_admin_controller'))
  .controller('ListUsersController', require('./list_users_controller'))
  .controller('AdminAddUserController', require('./admin_add_user_controller'))
  .controller('AdminEditUserController', require('./admin_edit_user_controller'))
  .controller('AdminUserFormController', require('./admin_user_form_controller'))
  .config(require('./routes'));

module.exports = UsersAdminModule;