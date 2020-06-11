'use strict';

describe('Registration.LoginController', function() {
  var $controller;
  var session;
  var controller, createController, createControllerRouteParams;

  beforeEach(module('app'));

  beforeEach(inject(function($injector) {
    $controller = $injector.get('$controller');

    createController = function() {
      return $controller('LoginController', {});
    };

    createControllerRouteParams = function() {
      return $controller('LoginController', { $routeParams: { error: 'error' } });
    };
  }));

  it("should return false as login has not been attempted", function() {
    controller = createController();
    expect(controller.failedLogin()).toBe(false);
  });

  it("should return true as login was unsuccesful", function() {
    controller = createControllerRouteParams();
    expect(controller.failedLogin()).toBe(true);
  });
});