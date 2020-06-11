var ServicesIntegration;
(function (ServicesIntegration) {
    ServicesIntegration.integrate = function () {
        /*******************************************************************/
        angular.module("toastService", []);
        angular.module("toastService").factory("ToastService", Toast);
        Toast.$inject = [
            "$q",
            "$mdToast"
        ];
        function Toast($q, $mdToast) {
            return new ToastService.Service($q, $mdToast);
        }
        /*******************************************************************/
        angular.module("dialogService", []);
        angular.module("dialogService").factory("DialogService", Dialog);
        Dialog.$inject = [
            "$q",
            "$mdDialog"
        ];
        function Dialog($q, $mdDialog) {
            return new DialogService.Service($q, $mdDialog);
        }
        /*******************************************************************/
        angular.module("contextsService", []);
        angular.module("contextsService").factory("ContextsService", Contexts);
        function Contexts($location) {
            return new PasspointContextsService.Service($location);
        }
        /*******************************************************************/
        angular.module("userService", []);
        angular.module("userService").factory("UserService", User);
        User.$inject = [
            "$q",
            "$http",
            "ToastService",
            "ContextsService"
        ];
        function User($q, $http, ToastService, ContextsService) {
            return new UserService.Service($q, $http, ToastService, ContextsService);
        }
        /*******************************************************************/
    };
})(ServicesIntegration || (ServicesIntegration = {}));
