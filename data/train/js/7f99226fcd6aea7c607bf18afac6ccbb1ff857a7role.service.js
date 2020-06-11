/**
 * 角色访问路径
 */
(function () {
    'use strict';

    angular.module('app.role').factory('RoleService', RoleService);
    RoleService.$inject = ['DeviceServiceRestangular','AuthorityRestangular'];

    function RoleService(DeviceServiceRestangular,AuthorityRestangular) {
        var roleService;
        roleService = {
            getSendDgRole: DeviceServiceRestangular.all('api/device-groups/role/'),
            resourcesAll : AuthorityRestangular.all('api/resources')

        };
        return roleService;
    }
})();
