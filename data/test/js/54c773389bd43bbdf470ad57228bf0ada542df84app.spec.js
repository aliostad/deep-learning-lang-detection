describe("Hello world", function() {

  it("passes", function() {
    expect(true).toEqual(true);
  });

  describe('An AngularJS Controller', function(){
    //Load the module with the controller under test
    beforeEach(module('app'));

    var $controller;
    var controller;

    beforeEach(inject(function(_$controller_){
      $controller = _$controller_;

      var scope = {};
      controller = $controller('MainCtrl', { $scope: scope });
    }));

    it("has a message Hello World", function() {
      expect(controller.message).toEqual("Hello World");
    });
  });
});
