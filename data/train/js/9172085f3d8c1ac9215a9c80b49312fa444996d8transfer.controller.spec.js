(function() {
  /*jshint expr:true */
  'use strict';
  describe('TransferController', function() {
    var TransferController;
    var $scope;
    var $rootScope;
    var $controller;

    beforeEach(module('validate'));

    beforeEach(inject(function(_$rootScope_, _$controller_) {
      $rootScope = _$rootScope_;
      $scope = $rootScope.$new();
      $controller = _$controller_;

      TransferController = $controller('TransferController', {
        $scope: $scope
      });
    }));
    it('TransferController should exist', function() {
      expect('TransferController').to.exist;
    });
  });
})();