define([
    "angular",
    "app/grumbler"
],
function(angular, grumbler) {
    return grumbler.factory("UserService", ["$rootScope", function($rootScope) {
        var UserService = { };
        
        UserService.CHANGE_BROADCAST = "UserService.CHANGE_BROADCAST";
        UserService.account = null;
        UserService.logoutUrl = null;
        UserService.loginUrl = null;
        
        UserService.set = function(userData) {
            angular.extend(UserService, userData);
            $rootScope.$broadcast(UserService.CHANGE_BROADCAST);
        };

        return UserService;
    }]);
});

