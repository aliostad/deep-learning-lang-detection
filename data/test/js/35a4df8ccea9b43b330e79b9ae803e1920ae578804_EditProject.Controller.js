(function (angular) {
    'use strict';

    angular
        .module('Projects')
        .controller('EditProject', editProject);

    editProject.$inject = [
        '$location',
        '$routeParams',
        'PageHeadService',
        'NavbarService',
        'BreadcrumbService',
        'ProjectsService'
    ];

    function editProject($location, $routeParams, pageHeadService, navbarService, breadcrumbService, projectsService) {
        /* jshint validthis: true */
        var vm = this;
        vm.ProjectsService = projectsService;

        activate();

        function activate() {
            navbarService.DeactivateAll();
            projectsService.GetProjectDetails($routeParams.ProjectId).success(function () {
                pageHeadService.Title = 'Edit ' + projectsService.SelectedProject.Name;
                breadcrumbService.RemoveLast();
                breadcrumbService.AddNew($location, pageHeadService.Title);
            });
        }
    }
}(angular));