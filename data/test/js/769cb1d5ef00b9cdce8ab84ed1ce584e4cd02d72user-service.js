angular.
  module('grsApp').factory('userService', userService);

function userService(requestService, common, logger) {
  logger.info("init user service.");

  var service = {
    getUserInfo : getUserInfo,
    login : login,
    register : register
  };
  return service;

  function getUserInfo() {
    var service = common.activedApp.Service.BaseUserInfo;
    return requestService.request(common.activedApp.BaseUrl + service.Url, service.Method);
  }

  function login(user) {
    var service = common.activedApp.Service.Login;
    return requestService.request(common.activedApp.BaseUrl + service.Url, service.Method, user);
  }

  function register(user) {
    var service = common.activedApp.Service.Register;
    return requestService.request(common.activedApp.BaseUrl + service.Url, service.Method, user);
  }
}