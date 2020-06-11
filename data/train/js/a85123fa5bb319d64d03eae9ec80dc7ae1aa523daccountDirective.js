(function() {
  'use strict';

  angular
  .module('app.directives')
  .directive('account', account);

  account.$inject = ['AccountService', 'MenuService', 'UserService', 'StatusService'];

  /* @ngInject */
  function account(AccountService, MenuService, UserService, StatusService) {

    var directive = {
      link: link,
      restrict: 'E',
      templateUrl: 'app/core/utils/menu/account/accountView.html'
    };
    return directive;

    function link(scope, element, attrs) {
      scope.MenuService = MenuService;
      scope.UserService = UserService;

      scope.updateStatus = function () {
        StatusService.update({
          status: scope.status
        }, function (err, res) {
          if (!err) {
            console.log(res);
          }
        });
      };
    }
  }
})();
