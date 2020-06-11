'use strict';

var PlanListController = require('../../../../src/components/plan/controller/ListController');

describe('Components:Plan:Controller:ListController', function () {

  var createController, plans;

  beforeEach(function () {
    angular.mock.inject(function ($injector) {
      var $controller = $injector.get('$controller');
      createController = function () {
        return $controller(PlanListController, {plans: plans});
      };
    });
  });

  it('should init the plans', function () {
    plans = 'plans';
    var controller = createController();
    expect(controller.plans).toBe('plans');
  });

});