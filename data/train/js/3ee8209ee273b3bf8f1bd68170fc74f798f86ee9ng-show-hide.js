angular.module('app.ngShowHide', [])
.config(function($stateProvider, $urlRouterProvider) {
  $urlRouterProvider.otherwise('/ng-show-hide');
  $stateProvider
  .state('ngShowHide', {
    url: '/ng-show-hide',
    template: '<page-ng-show-hide></page-ng-show-hide>'
  });
})
.directive('pageNgShowHide', function() {
  return {
    replace: true,
    scope: {},
    controllerAs: 'vm',
    controller: function(Demo) {
      this.demo_config = Demo;
      this.show = true;
    },
    templateUrl: '/ng-show-hide/ng-show-hide-template.html'
  }
})
