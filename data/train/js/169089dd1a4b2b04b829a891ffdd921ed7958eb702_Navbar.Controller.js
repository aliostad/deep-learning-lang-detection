(function (angular) {
    'use strict';

    angular
        .module('Common')
        .controller('Navbar', navbar);

    navbar.$inject = [
        '$http',
        'NavbarService',
        'SimonVersionService'
    ];

    function navbar($http, navbarService, simonVersionService) {
        /* jshint validthis: true */
        var vm = this;
        vm.NavbarService = navbarService;
        vm.SimonVersionService = simonVersionService;

        activate();

        function activate() {
            navbarService.LoadTools($http);
            navbarService.LoadUser($http);
            simonVersionService.GetVersion();
        }
    }
}(angular));