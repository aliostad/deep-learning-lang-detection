'use strict';

var PlayerSkinDetailController = require('../../../../src/components/player-skin/controller/DetailController');

describe('Components:PlayerSkin:Controller:DetailController', function () {

  var createController, playerSkin;

  beforeEach(function () {
    angular.mock.inject(function ($injector) {
      var $controller = $injector.get('$controller');
      createController = function () {
        return $controller(PlayerSkinDetailController, {playerSkin: playerSkin});
      };
    });
  });

  it('should init the PlayerSkin', function () {
    playerSkin = 'playerSkin';
    var controller = createController();
    expect(controller.playerSkin).toBe('playerSkin');
  });

});