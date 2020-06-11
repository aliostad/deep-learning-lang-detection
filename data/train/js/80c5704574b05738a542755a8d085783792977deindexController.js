'use strict';
app.controller('indexController', ['$scope', '$location', 'LoginService', 'authInterceptorService', function ($scope, $location, LoginService, authInterceptorService) {

    $scope.logOut = function () {
        LoginService.logOut();
        $location.path('/');
    }
    if (authInterceptorService.authData) {
        LoginService.authentication.isAuth = true;
        LoginService.authentication.userName = authInterceptorService.authData.userName;
    }
    $scope.authentication = LoginService.authentication;

}]);