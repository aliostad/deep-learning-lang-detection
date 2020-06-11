(function() {
    'use strict';

    angular
        .module('<%= scriptAppName %>')
        .service('<%= classedName %>Service',  <%= classedName %>Service);


    /* @ngInject */
    function <%= classedName %>Service() {
        var someValue = '';
        var service = {
            save: save,
            someValue: someValue,
            validate: validate
        };
        return service;

        ////////////

        function save() {
            /* */
        }

        function validate() {
            /* */
        }
    }

})();
