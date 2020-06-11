describe('PasswordController', function() {
  beforeEach(module('app'));

  var $controller;

  beforeEach(inject(function(_$controller_){
    $controller = _$controller_;
  }));

  describe('$scope.grade', function() {
    var controller;

    beforeEach(function() {
      controller = $controller('PasswordController', {});
    });

    it('sets the strength to "strong" if the password length is >8 chars', function() {
      controller.password = 'longerthaneightchars';
      controller.grade();
      expect(controller.strength).toEqual('strong');
    });

    it ('sets the strength to "medium" if the password length is <8 and >3 chars', function() {
      controller.password = "abcdef";
      controller.grade();
      expect(controller.strength).toEqual('medium');
    });

    it ('sets the strength to "easy" if the password length is <3 chars', function() {

      controller.password = "ab";
      controller.grade();
      expect(controller.strength).toEqual('weak');
    })
  });
});
