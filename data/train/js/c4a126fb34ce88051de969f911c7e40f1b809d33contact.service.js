(function () {
    angular
        .module('app')
        .factory('contactService', contactService);

    contactService.$inject = ['serviceHelper'];

    /* @ngInject */
    function contactService(serviceHelper) {

        var resource = serviceHelper.contact;

        var service = {
            getPersons: getPersons,
            getPerson:getPerson
        };

        return service;

        ////////////////

        function getPersons() {
            return resource.query();
        }

        function getPerson(id) {
            return resource.get({personId: id});
        }

    }

})();
