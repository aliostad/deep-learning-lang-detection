'use strict';

angular.module('WalletApp.sharedComponents.navDirective', [])
  .directive('navDir', ['$rootScope', function($rootScope){
    return {
      restrict: 'E',
      templateUrl: './app/shared_components/nav_panel.html',
      link: function(scope){
        var unableNav = function(){
          if(scope.navActive){
            if(!$rootScope.$$phase){
              scope.toggleNav();
              $rootScope.$apply();
              window.removeEventListener("resize", unableNav);
            }
          }
        }

        scope.navActive = false;

        scope.toggleNav = function(){
          window.addEventListener("resize", unableNav);
          scope.navActive = !scope.navActive;
        };

      }
    }
  }]);