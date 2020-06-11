var Application;
(function (Application) {
    Application.App = angular.module('Application', [
        'ngResource'
    ]).config([
        '$httpProvider',
        function ($httpProvider) {
            delete $httpProvider.defaults.headers.common['X-Requested-With'];
        }])
        .controller('ContentController', Application.ContentController)
        .controller('PersonController', Application.PersonController)
        .controller('AuthenticationController', Application.AuthenticationController)
        .controller('BookController', Application.BookController);

})(Application || (Application = {}));
