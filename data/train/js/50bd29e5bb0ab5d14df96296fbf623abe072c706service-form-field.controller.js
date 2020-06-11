(function() {
    'use strict';

    angular
        .module('investhryApp')
        .controller('ServiceFormFieldController', ServiceFormFieldController);

    ServiceFormFieldController.$inject = ['ServiceFormField'];

    function ServiceFormFieldController(ServiceFormField) {

        var vm = this;

        vm.serviceFormFields = [];

        loadAll();

        function loadAll() {
            ServiceFormField.query(function(result) {
                vm.serviceFormFields = result;
                vm.searchQuery = null;
            });
        }
    }
})();
