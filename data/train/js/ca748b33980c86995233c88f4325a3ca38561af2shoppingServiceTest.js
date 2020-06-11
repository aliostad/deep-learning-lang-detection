'use strict';

describe('ShoppingService - ', function () {

  // load the directive's module
  beforeEach(module('angularjsTestApp'));

  var _ShoppingService_;

  beforeEach(inject(function (ShoppingService) {
    _ShoppingService_ = ShoppingService;
  }));

  it('should have 6 items', inject(function ($compile) {

    var shoppingService = new _ShoppingService_();
    expect(shoppingService.getListOfItems().length).toBe(6);

  }));

  it('should add 1 item more', inject(function ($compile) {

    var shoppingService = new _ShoppingService_();

    shoppingService.add({item: 'Coconut', qty:1, value:0, must:false});

    expect(shoppingService.getListOfItems().length).toBe(7);

  }));

  it('should remove 1 item', inject(function ($compile) {

    var shoppingService = new _ShoppingService_();

    shoppingService.remove({});

    expect(shoppingService.getListOfItems().length).toBe(5);

  }));  


});