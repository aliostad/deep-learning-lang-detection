function AccountService ($q, $http, ConfigService, VkService) {

    var AccountService = {};

    AccountService.asyncDestroy = function () {
        return $http.get(ConfigService.SERVER_URL + '/account.destroy').then(function (response) {
            return VkService.asyncDestroy();
        },
        function (response) {
            return $q.reject(new HttpError(response.status, 'account.destroy request failed'));
        });
    };

    return AccountService;
}

angular.module('spacebox').factory('AccountService',
    ['$q', '$http', 'ConfigService', 'VkService', AccountService]);