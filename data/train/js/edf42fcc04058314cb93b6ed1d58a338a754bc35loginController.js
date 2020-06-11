app.controller('loginController', ['$scope', function($scope) {

    $scope.showLogin = true;

    $scope.showSignin = false;

    $scope.showLogSign = function (){
        if ($scope.showLogin = true){
            $scope.showSignin = false;
        }
        else {
            $scope.showSignin = true;
        }
    };

    $scope.showSignLog = function (){
        if ($scope.showSignin = true){
            $scope.showLogin = false;
        }
        else {
            $scope.showLogin = true;
        }
    };

}]);