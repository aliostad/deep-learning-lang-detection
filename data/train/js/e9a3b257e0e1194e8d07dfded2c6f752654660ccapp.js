var myApp = angular.module('myApp',[]);

myApp.controller('FirstCtrl', ['FirstService', '$scope', function(MyService, $scope) {
    $scope.property = MyService.theNumber;
}]);

myApp.factory('FirstService', [ 'SecondService', 'ThirdService', function(secondService, thirdService) {

    console.log("Singleton? " + (thirdService === secondService.thirdService));

    return {
        theNumber: thirdService.theNumber,
        toUpercase: function(input){ return input.toUpercase()}
    }
}]);

myApp.factory('SecondService', [ 'ThirdService', function(thirdService) {
    return {
        theNumber: thirdService.theNumber,
        toUpercase: function(input){ return input.toLowerCase()},
        thirdService: thirdService
    }
}]);

myApp.factory('ThirdService', [ function() {
    return {
        theNumber: 42
    }
}]);