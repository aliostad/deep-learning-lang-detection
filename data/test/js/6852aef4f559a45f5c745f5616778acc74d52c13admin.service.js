'use strict';

function adminService() {

  var message = {};
  message.text = '';
  message.advanced = '';

  var module = {};
  module.name = 'test';

  function clean() {
    message.text = '';
    message.advanced = '';
    module.name = '';
  }

  function setMessage(someMessage) {
    message = someMessage;
  }

  function getMessage() {
    return message;
  }

  var service = {
    clean: clean,
    setMessage: setMessage,
    getMessage: getMessage,
    module: module
  };
  return service;
}

angular
  .module('aStoreFrontend')
  .factory('adminService', adminService);