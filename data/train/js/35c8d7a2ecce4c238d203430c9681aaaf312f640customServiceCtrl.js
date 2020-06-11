var customServiceModule = angular.module("customServiceModule");

customServiceModule.controller("customServiceCtrl", customServiceCtrl);

function customServiceCtrl($scope, logService, myCystomService, myProviderService) {
    $scope.data = {
        cities: ["USA", "England", "France"],
        innerCounter: 0
    };
    $scope.$watch("data.innerCounter", function (newVal, oldVal, scope) {
        logService.log("Total click count: " + newVal);
        myCystomService.do();
        myProviderService.execute();
    })
}