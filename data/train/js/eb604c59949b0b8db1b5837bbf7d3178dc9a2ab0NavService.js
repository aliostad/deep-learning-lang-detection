'use strict';

InspectormanApp.factory('NavService', function ($rootScope) {

    var NavService = {};

    NavService.showNav = function () {
        $rootScope.$broadcast('show_nav');
    };
    NavService.hideNav = function () {
        $rootScope.$broadcast('hide_nav');
    };
    NavService.dashboarActive = function () {
        $rootScope.$broadcast('dashboard_active');
    };
    NavService.settingsActive = function () {
        $rootScope.$broadcast('settings_active');
    };
    NavService.detailActive = function () {
        $rootScope.$broadcast('detail_active');
    };
    NavService.formsActive = function () {
        $rootScope.$broadcast('forms_active');
    };
    NavService.summaryActive = function () {
        $rootScope.$broadcast('summary_active');
    };
    NavService.complaintsActive = function () {
        $rootScope.$broadcast('complaints_active');
    };
    NavService.historyActive = function () {
        $rootScope.$broadcast('history_active');
    };


    return NavService;
});
