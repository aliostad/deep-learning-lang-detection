
describe('StoreController', function() {
  var $controller;
  beforeEach(module('gemStore'));

  beforeEach(inject(function(_$controller_) {
    $controller = _$controller_;
  }));
  
  describe('controller properties', function() {
    it('has a array of products. And its size is 3', function() {
      var controller = $controller('StoreController', {});
      //console.log(controller.products);
      //console.log(controller)
      return expect(controller.products.length).toEqual(3);
    });
  });
});


describe('TabController', function() {
  var $controller;
  beforeEach(module('gemStore'));

  beforeEach(inject(function(_$controller_) {
    $controller = _$controller_;
  }));
  
  describe('controller properties', function() {
    it('has a tab.', function() {
      var controller = $controller('TabController', {});
      //console.log(controller);

      return expect(controller.tab).toEqual(1);
    });
  });

  describe('setTab and isSet functions', function() {
    it('should handle tab', function() {
      var controller = $controller('TabController', {});
      controller.setTab(2);
      expect(controller.isSet(1)).toEqual(false);
      expect(controller.isSet(2)).toEqual(true);
      expect(controller.isSet(3)).toEqual(false);

      controller.setTab(3);
      expect(controller.isSet(1)).toEqual(false);
      expect(controller.isSet(2)).toEqual(false);
      expect(controller.isSet(3)).toEqual(true);
    });
  });



});



