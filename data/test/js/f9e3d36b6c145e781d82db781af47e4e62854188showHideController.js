(function () {

    var showHideController = function ($scope)
    {
        $scope.showText = true;
        $scope.buttonText = "Hide";
        $scope.toggleVisible = function () {
            $scope.showText = !$scope.showText;
            if ($scope.showText)
            {
                $scope.buttonText = "Hide";
            }
            else
            {
                $scope.buttonText = "Show";
            }
        };
    }

    mod = angular.module("ecknoModule");
    mod.controller("showHideController", ["$scope", showHideController]);
}())