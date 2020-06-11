(function () {
    'use strict';

    angular
        .module('semjournals')
        .factory('SidebarService', SidebarService);

    SidebarService.$inject = ['$rootScope'];
    function SidebarService($rootScope) {
        var service = {};

        service.actions = [];

        service.LoadLoginActions = LoadLoginActions;
        service.LoadUserActions = LoadUserActions;
        service.LoadAdminActions = LoadAdminActions;

        return service;

        function LoadLoginActions() {
            service.actions = [
                {
                    name: 'login'
                }
            ];
        }

        function LoadUserActions() {
            service.actions = [
                {
                    name: 'journals'
                }, {
                    name: 'subscriptions'
                }, {
                    name: 'logout'
                }
            ];
        }

        function LoadAdminActions() {
            service.actions = [
                {
                    name: 'users'
                }, {
                    name: 'journals'
                }, {
                    name: 'logout'
                }
            ];
        }
    }

})();