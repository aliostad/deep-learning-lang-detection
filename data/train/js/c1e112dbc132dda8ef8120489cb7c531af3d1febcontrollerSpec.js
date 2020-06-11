describe('Angular controller test', function() {
  var controllerFactory
    , myController
    , scope;

  function createController() {
    return controllerFactory('myController', {$scope: scope});
  }

  beforeEach(module("myApp"));
  beforeEach(inject(function(_$controller_, _$rootScope_) {
    scope = _$rootScope_.$new();
    controllerFactory = _$controller_;
  }));

  it('should have a getDate function which returns a date', function() {
    createController();
    expect(scope.getDate()).toBe('20140613');
  });
});
