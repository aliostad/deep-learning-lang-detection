'use strict';

var InstanceListController = require('../../../../src/components/instance/controller/ListController');

describe('Components:Instance:Controller:InstanceListController', function () {

  var createController, instances;

  beforeEach(function () {
    angular.mock.inject(function ($injector) {
      var $controller = $injector.get('$controller');
      createController = function () {
        return $controller(InstanceListController, {instances: instances});
      };
    });
  });

  it('should init the instances', function () {
    instances = 'instances';
    var controller = createController();
    expect(controller.instances).toBe('instances');
  });

});