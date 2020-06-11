/** Alleviate jshint on tests https://github.com/johnpapa/angular-styleguide#style-y196 */
/* jshint -W117, -W030 */
(function () {
  'use strict';

  describe('MyFirstFeatureController', function () {
    var controller, $controller;

    beforeEach(function () {
      angular.mock.module('app');
      angular.mock.module('app.myFirstFeature');
    });

    beforeEach(inject(function (_$controller_) {
      $controller = _$controller_;
    }));

    it('should exist', function () {
      controller = $controller('MyFirstFeatureController', []);
      expect(controller).not.toBe(null);
    });
  });
})();
