'use strict';

var TranscoderProfileListController = require('../../../../src/components/transcoder-profile/controller/ListController');

describe('Components:TranscoderProfile:Controller:ListController', function () {

  var createController, transcoderProfiles;

  beforeEach(function () {
    angular.mock.inject(function ($injector) {
      var $controller = $injector.get('$controller');
      createController = function () {
        return $controller(TranscoderProfileListController, {transcoderProfiles: transcoderProfiles});
      };
    });
  });

  it('should init the transcoderProfiles', function () {
    transcoderProfiles = 'transcoderProfiles';
    var controller = createController();
    expect(controller.transcoderProfiles).toBe('transcoderProfiles');
  });

});