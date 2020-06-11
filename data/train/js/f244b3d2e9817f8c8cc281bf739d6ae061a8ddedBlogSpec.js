describe('StoreController', function() {
  var $scope;

  beforeEach(module('controllers'));

  beforeEach(inject(function($rootScope, $controller) {
    $scope = $rootScope.$new();
    createController = function() {
          return $controller('StoreController', {
              '$scope': $scope
          });
      };
  }));

  it('call to prev() function', function() {
    var controller = createController();
    offset = controller.offset;
    limit = controller.limit;
    expect(controller.prev).toBeDefined();
    controller.prev();
    expect(controller.offset).toBe(offset - limit);
  });

  it('call to next() function', function() {
    var controller = createController();
    offset = controller.offset;
    limit = controller.limit;
    expect(controller.next).toBeDefined();
    controller.next();
    expect(controller.offset).toBe(offset + limit);
  });

});