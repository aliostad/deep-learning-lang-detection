(function() {
    'use strict';

    /**
     * sessionStorageService
     *
     * The sessionStorageService service provides wrapper functions for working with session storage.
     */
    angular
        .module('blocks.storage')
        .factory('sessionStorageService', sessionStorageService);

    /**
     * Internal function that returns the sessionStorageService object.
     * @param {object} storageService
     * @returns {object} the Angular service object
     */
    sessionStorageService.$inject = ['storageService'];
    function sessionStorageService(storageService) {
        return storageService.session;
    }

}());
