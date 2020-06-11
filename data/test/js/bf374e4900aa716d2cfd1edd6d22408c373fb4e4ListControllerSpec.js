'use strict';

var ProductListController = require('../../../../src/components/product/controller/ListController');

describe('Components:Product:Controller:ListController', function () {

  var createController, products;

  beforeEach(function () {
    angular.mock.inject(function ($injector) {
      var $controller = $injector.get('$controller');
      createController = function () {
        return $controller(ProductListController, {products: products});
      };
    });
  });

  it('should init the products', function () {
    products = 'products';
    var controller = createController();
    expect(controller.products).toBe('products');
  });

});