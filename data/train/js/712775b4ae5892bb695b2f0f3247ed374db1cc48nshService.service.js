(function () {
    'use strict';

    angular.module('basicConfig.nshService').factory('NshService', NshService);
    NshService.$inject = ['ShellJobServiceRestangular', 'DeviceServiceRestangular'];

    function NshService(ShellJobServiceRestangular, DeviceServiceRestangular) {
        var nshService;
        nshService = {
            nsh: ShellJobServiceRestangular.all('api/nsh-systems'),
            device: DeviceServiceRestangular.all('api/device-areas')
        };
        return nshService;
    }
})();
