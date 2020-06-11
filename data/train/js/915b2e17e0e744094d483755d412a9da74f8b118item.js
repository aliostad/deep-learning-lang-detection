'use strict';

describe('Controller: ItemController', function () {

  var ItemController;
  var controllerService;

  // load the controller's module
  beforeEach(module('auction'));

  // Initialize the controller
  beforeEach(inject(function ($controller) {
    controllerService = $controller;

  }));

  it('product item is empty', function () {
    ItemController = controllerService('ItemController', {
      product: null
    });

    expect(ItemController.item).toBe(null)
  });

  it('product item is filled', function () {
    ItemController = controllerService('ItemController', {
      product: {}
    });
    expect(ItemController.product).exist()
  });
});