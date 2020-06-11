'use strict';

var ProductDetailController = require('../../../../src/components/product/controller/DetailController');

describe('Components:Product:Controller:DetailController', function () {

  var createController, product;

  beforeEach(function () {
    angular.mock.inject(function ($injector) {
      var $controller = $injector.get('$controller');
      createController = function () {
        return $controller(ProductDetailController, {product: product});
      };
    });
  });

  it('should init the Product', function () {
    product = 'product';
    var controller = createController();
    expect(controller.product).toBe('product');
  });

});