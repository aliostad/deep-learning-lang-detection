(function() {
    'use strict';
    var controllerId = 'shellController';
    angular
        .module('app')
        .controller(controllerId, shellController);

    shellController.$inject = ['$rootScope', 'common'];
    function shellController($rootScope, common) {
        var vm = this;
        

        init();
        ////////////////

        function init() {

            common.logger.log("shell controller loaded", null, controllerId);
            common.activateController([], controllerId);
        }
    }
})();
