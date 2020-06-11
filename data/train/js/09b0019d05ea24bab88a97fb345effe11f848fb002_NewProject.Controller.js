(function (angular) {
    'use strict';

    angular
        .module('Projects')
        .controller('NewProject', newProject);

    newProject.$inject = [
        '$location',
        '$routeParams',
        'PageHeadService',
        'NavbarService',
        'BreadcrumbService',
        'ProjectsService'
    ];

    function newProject($location, $routeParams, pageHeadService, navbarService, breadcrumbService, projectsService) {
        /* jshint validthis: true */
        var vm = this;
        vm.ProjectsService = projectsService;
        vm.NewProjectDetails = {
            Name: '',
            Description: ''
        };

        activate();

        function activate() {
            pageHeadService.Title = 'Add New Project';
            navbarService.DeactivateAll();
            breadcrumbService.AddNew($location, pageHeadService.Title);
        }
    }
}(angular));