var spa5;
(function (spa5) {
    'use strict';
    angular.module('spa5', ['ngResource', 'ui.router', 'ui.bootstrap', 'oitozero.ngSweetAlert', 'cfp.hotkeys', 'kendo.directives'])
        .config(spa5.Config)
        .config(spa5.RouterConfig)
        .run(spa5.RunBlock)
        .controller('BalanceController', spa5.BalanceController)
        .controller('CpuController', CpuController)
        .controller('DurationController', spa5.DurationController)
        .controller('GridController', spa5.GridController)
        .controller('ICheckController', ICheckController)
        .controller('MainController', spa5.MainController)
        .controller('MinimalizaSidebarController', spa5.MinimalizaSidebarController)
        .controller('RightSidebarController', spa5.RightSidebarController)
        .controller('TitleClockController', spa5.TitleClockController)
        .controller('TopNavbarController', spa5.TopNavbarController)
        .directive('iCheck', iCheck)
        .directive('minimalizaSidebar', spa5.minimalizaSidebar)
        .directive('titleClock', spa5.titleClock);
})(spa5 || (spa5 = {}));
