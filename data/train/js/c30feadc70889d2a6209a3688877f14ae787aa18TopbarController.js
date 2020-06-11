define([], function() {
    'use strict';

    function TopbarController ($location, GlobalFiltersService, DashboardService, StatisticsService, WordCloudService, SemanticFieldsService) {
        var vm = this;

        vm.routeMatch = function (route) {
            return (new RegExp(route)).test($location.path());
        }

        GlobalFiltersService.onUpdate(function () {
            DashboardService.update();
            StatisticsService.update();
            WordCloudService.update();
            SemanticFieldsService.clear();
        });
    }

    TopbarController.$inject = ['$location', 'GlobalFiltersService', 'DashboardService', 'StatisticsService', 'WordCloudService', 'SemanticFieldsService'];

    return TopbarController;
});
