'use strict';

app.controller('AppController',
    function ($scope, $location, authService, userService, currentUserService, notifyService, friendRequestService) {
		// Put the authService & userService in the $scope to make them accessible from all screens
        $scope.authService = authService;
        $scope.userService = userService;
        $scope.currentUserService = currentUserService;

        $scope.logout = function() {
            authService.logout();
            notifyService.showInfo("Logout successful");
            $location.path('/login');
        };

        $scope.editProfileSave = function(userData) {
            currentUserService.editCurrentUserProfile(userData);
            notifyService.showInfo("Change successful");
            $location.path('/');
        };

    }
);
