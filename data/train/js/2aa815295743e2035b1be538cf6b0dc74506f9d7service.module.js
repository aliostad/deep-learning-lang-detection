(function () {

    function blobServiceModule($interval, $q) {
        var BlobService = require('./modules/blobService');

        var cache = {};

        return {
            load: load
        };

        function load(name, key){
            if(!cache[name]){
                cache[name] = new BlobService(name, key);
            }

            var blobService = cache[name];

            return {
                get: get,
                listContainer: listContainer,
                listBlobs: listBlobs,
                download: download
            };

            function get() {
                blobService.get();
            }

            function listContainer() {
                return blobService.listContainer();
            }

            function listBlobs(container) {
                return blobService.listBlobs(container);
            }

            function download(container, blob) {
                return blobService.download(container, blob);
            }
        }
    }

    angular.module('azure').factory('blobServiceModule', blobServiceModule);
    blobServiceModule.$inject = ['$interval', '$q'];
})();

(function () {
    function accountServiceModule($interval, $q) {
        var AccountService = require('./modules/accountService');
        var accountService = new AccountService();

        return {
            validate: validate
        };

        function validate(name, key) {
            return accountService.validate(name, key);
        }
    }

    angular.module('azure').factory('accountServiceModule', accountServiceModule);
})();

(function () {
    function remoteServiceModule() {

        var remote = require('remote');

    }

    angular.module('azure').factory('remoteServiceModule', remoteServiceModule);
})();