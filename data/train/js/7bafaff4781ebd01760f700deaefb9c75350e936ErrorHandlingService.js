serviceModule.factory('errorHandling', ['$rootScope', function ($rootScope) {
    function ErrorHandling(rootScope) {
        this.add = function (message) {
            var errorMessage;
            if (message && typeof message === "object") {
                if (message.hasOwnProperty('message')) {
                    errorMessage = message.message;
                }
            } else {
                errorMessage = message;
            }
            rootScope.$broadcast('msg:notification', 'danger', errorMessage);
        };
    }

    return new ErrorHandling($rootScope);
}]);
