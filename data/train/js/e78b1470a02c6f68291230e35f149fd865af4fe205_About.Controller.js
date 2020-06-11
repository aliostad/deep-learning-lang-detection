(function (angular) {
    'use strict';

    angular
        .module('Common')
        .controller('About', about);

    about.$inject = [
        '$location',
        'PageHeadService',
        'BreadcrumbService',
        'NavbarService'
    ];

    function about($location, pageHeadService, breadcrumbService, navbarService) {
        /* jshint validthis: true */
        var vm = this;
        vm.PageHeadService = pageHeadService;
        vm.BreadcrumbService = breadcrumbService;
        vm.NavbarService = navbarService;

        activate();

        function activate() {
            pageHeadService.Title = "About";
            breadcrumbService.IsVisible = false;
            navbarService.DeactivateAll();
            navbarService.AboutMenu.SetAsActive();
        }
    }
}(angular));