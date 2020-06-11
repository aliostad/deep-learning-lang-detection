var CoreAdminServicesIntegration;
(function (CoreAdminServicesIntegration) {
    CoreAdminServicesIntegration.integrate = function () {
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
        angular.module("countriesService", []);
        angular.module("countriesService").factory("CountriesService", Countries);
        //Countries.$inject = [];
        function Countries() {
            return new CountriesService.Service();
        }
        /*******************************************************************/
        angular.module("contextsService", []);
        angular.module("contextsService").factory("ContextsService", Contexts);
        Contexts.$inject = [
            "$location"
        ];
        function Contexts($location) {
            return new CoreAdminContextsService.Service($location);
        }
        /*******************************************************************/
        angular.module("profileService", []);
        angular.module("profileService").factory("ProfileService", Profile);
        Profile.$inject = [
            "$q",
            "$http",
            "$timeout",
            "ToastService",
            "ContextsService"
        ];
        function Profile($q, $http, $timeout, ToastService, ContextsService) {
            return new CoreAdminProfileService.Service($q, $http, $timeout, ToastService, ContextsService);
        }
        /*******************************************************************/
        angular.module("changeEmailAddressService", []);
        angular.module("changeEmailAddressService").factory("ChangeEmailAddressService", ChangeEmailAddress);
        ChangeEmailAddress.$inject = [
            "$mdDialog",
        ];
        function ChangeEmailAddress($mdDialog) {
            return new CoreAdminChangeEmailAddressService.Service($mdDialog);
        }
        /*******************************************************************/
        angular.module("changePasswordService", []);
        angular.module("changePasswordService").factory("ChangePasswordService", ChangePassword);
        ChangePassword.$inject = [
            "$mdDialog",
        ];
        function ChangePassword($mdDialog) {
            return new CoreAdminChangePasswordService.Service($mdDialog);
        }
        /*******************************************************************/
    };
})(CoreAdminServicesIntegration || (CoreAdminServicesIntegration = {}));
