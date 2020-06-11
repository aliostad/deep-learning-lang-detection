'use strict';

/* jasmine specs for controllers go here */

describe('controllers', function () {
  beforeEach(module('myApp.controllers'));

  it('should ....', inject(function ($controller) {
    //spec body
    var listController = $controller('ListController', {
      $scope: {}
    });
    expect(listController).toBeDefined();
  }));

  it('should ....', inject(function ($controller) {
    //spec body
    var addController = $controller('AddController', {
      $scope: {}
    });
    expect(addController).toBeDefined();
  }));
});
