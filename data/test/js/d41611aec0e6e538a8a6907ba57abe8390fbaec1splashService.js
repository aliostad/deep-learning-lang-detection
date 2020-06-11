(function () {
    'use strict';

    app.factory('splashService', splashService);

    splashService.$inject = ['$log', 'localStorageService'];

    function splashService($log, localStorageService) {

        var service = {
            getShowSplash: getShowSplash,
            setShowSplash: setShowSplash,
            clearShowSplash: clearShowSplash
        };

        return service;

        function getShowSplash() {
            if (localStorageService.get('_showSplash') == null) {
                localStorageService.set('_showSplash', true);
            }

            var _showSplash = localStorageService.get('_showSplash');

            return (_showSplash == 'true');
        }

        function setShowSplash(showSplash) {
            localStorageService.set('_showSplash', showSplash);
        }

        function clearShowSplash() {
            _showSplash = null;
        }

    }
})();