'use strict';

(function() {
  describe('PalindromeController', function() {
    beforeEach(module('main'));

    var $controller;

    beforeEach(inject(function(_$controller_){
      $controller = _$controller_;
    }));

    it('"tatbctat" is a not palindrome', function(){
      var PalindromeController = $controller('PalindromeController');
      PalindromeController.palindrome = "tatbctat";
      expect(PalindromeController.isPalindrome()).toBe(false);
    });

    it('"tattarrattat" is a palindrome', function(){
      var PalindromeController = $controller('PalindromeController');
      PalindromeController.palindrome = "tattarrattat";
      expect(PalindromeController.isPalindrome()).toBe(true);
    });

    it('"A Man, A Plan, A Canal-Panama!" is a palindrome', function()
    {
      var PalindromeController = $controller('PalindromeController');
      PalindromeController.palindrome = "A Man, A Plan, A Canal-Panama!";
      expect(PalindromeController.isPalindrome()).toBe(true);
    });
  });
}())
