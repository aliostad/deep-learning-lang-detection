'use strict';

var PlayerSkinListController = require('../../../../src/components/player-skin/controller/ListController');

describe('Components:PlayerSkin:Controller:ListController', function () {

  var createController, playerSkins;

  beforeEach(function () {
    angular.mock.inject(function ($injector) {
      var $controller = $injector.get('$controller');
      createController = function () {
        return $controller(PlayerSkinListController, {playerSkins: playerSkins});
      };
    });
  });

  it('should init the playerSkins', function () {
    playerSkins = 'playerSkins';
    var controller = createController();
    expect(controller.playerSkins).toBe('playerSkins');
  });

});