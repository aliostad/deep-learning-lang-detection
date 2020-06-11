app = angular.module('TheApp', []);

function NavCtrl($scope, $location) {
    $scope.navVisible = false;

    $scope.toggleNav = function() {

        if ($scope.navVisible) {
            $scope.navClass="";
            $scope.navVisible = false;
        } else {
            $scope.navClass="selected";
            $scope.navVisible = true;
        }
    };

    var mq = window.matchMedia( "(min-width: 480px)" );
    if (mq.matches) {
        // window width is at least 500px
    }
    else {
        // window width is less than 500px
    }

}