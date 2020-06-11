(function (angular) {
    'use strict';

    angular
        .module('Projects')
        .controller('Projects', projects);

    projects.$inject = [
        '$location',
        'PageHeadService',
        'NavbarService',
        'BreadcrumbService',
        'ProjectsService'
    ];

    function projects($location, pageHeadService, navbarService, breadcrumbService, projectsService) {
        /* jshint validthis: true */
        var vm = this;
        vm.ProjectsService = projectsService;

        activate();

        function activate() {
            pageHeadService.Title = 'Home';
            navbarService.DeactivateAll();
            projectsService.GetProjects().success(function () {
                breadcrumbService.Reset();
                breadcrumbService.AddNew($location, pageHeadService.Title);
            });
        }
    }
}(angular));