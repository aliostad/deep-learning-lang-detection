define([
  'config',
  'angular',
  'controller/<%= _.slugify(name) %>-controller'
], function(cfg, A) {
  return describe('<%= _.humanize(name) %> controller', function() {
    var $scope,
        createController;

    beforeEach(module(cfg.ngApp));
    beforeEach(inject(function($injector) {
      var $controller = $injector.get('$controller'),
          $rootScope = $injector.get('$rootScope');

      $scope = $rootScope.$new();

      createController = function() {
        return $controller('<%= _.classify(name) %>Controller', {
          $scope: $scope
        });
      };
    }));

    it('should load', function() {
      var controller = createController();
    });
  });
});
