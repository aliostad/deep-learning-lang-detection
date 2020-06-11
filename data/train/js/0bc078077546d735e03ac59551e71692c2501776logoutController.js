app.controller('logoutController', ['$location', 'usersService', 'authService', 'notifyService',
    function ($location, usersService, authService, notifyService) {
        usersService.logout(function () {
            authService.clearLocalStorage();
            notifyService.success('Logout successful.');
            $location.path('/');
        }, function (error) {
            authService.clearLocalStorage();
            notifyService.responseError(error);
            $location.path('/');
        });
    }]);