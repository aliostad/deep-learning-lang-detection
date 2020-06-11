define([
  'udare',
  'accounts/controllers/AccountsController',
  'accounts/controllers/AccountController',
  'accounts/services/AccountsService',
  'accounts/socket/AccountsSocket',
  ], function(udare, AccountsController, AccountController, AccountsService, AccountsSocket) {
  
  var accounts = udare.module('accounts', [AccountsSocket]);
  accounts.service('AccountsService', AccountsService);
  accounts.controller('AccountsController', AccountsController);
  accounts.controller('AccountController', AccountController);

  return accounts;
});