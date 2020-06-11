(function () {
    'use strict';

    angular.module('basicConfig.sysAccount').factory('SysAccountService', SysAccountService);
    SysAccountService.$inject = ['ShellJobServiceRestangular', 'AuthorityRestangular', 'DeviceServiceRestangular'];

    function SysAccountService(ShellJobServiceRestangular, AuthorityRestangular, DeviceServiceRestangular) {
        var sysAccountService;
        sysAccountService = {
            shell: ShellJobServiceRestangular.all('api/os-users'),
            role:AuthorityRestangular.all('api/authorities'),
            device: DeviceServiceRestangular.all('api/device-areas')
        };
        return sysAccountService;
    }
})();
