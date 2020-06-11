'use strict';

describe('Controller: HomeController', function () {

  var HomeController;
  var controllerService;

  // load the controller's module
  beforeEach(module('auction'));

  // Initialize the controller
  beforeEach(inject(function ($controller) {
    controllerService = $controller;

  }));

  it('products are empty', function () {
    HomeController = controllerService('HomeController', {
      products: []
    });

    expect(HomeController.products.length).toBe(0)
  });

  it('products are filled', function () {
    HomeController = controllerService('HomeController', {
      products: [{}, {}]
    });
    expect(HomeController.products.length).toBe(2)
  });
});