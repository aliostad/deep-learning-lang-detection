moduleRegistrar.register('fl.dashboardNav');

angular.module('fl.dashboardNav', ['ui.router'])
  .controller('DashNavCtrl', [
    'flDashboardNav',
    '$state',

    function (flDashboardNav, $state) {

      var vm = this;

      vm.isCurrent = function (str) {
        return $state.current.name.indexOf( str.toLowerCase() ) >= 0;
      };

      /**
       * TODO: Cache navItems. There's no need to keep reloading
       */

      /**
       * TODO: What if this fails?
       */

      flDashboardNav.getNavItems().then(function (navItems) {
        vm.navItems = navItems;
      });

    }]
  );
