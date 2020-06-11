angular.module('trainer').controller('loginCtrl', ['$scope', 'userService', 'pageService',
    function($scope, userService, pageService) {
    
    //////////////////////////////////////////////////
    //  ATTRIBUTES
    //////////////////////////////////////////////////
    
    $scope.pageService = pageService;
    
    //////////////////////////////////////////////////
    //  METHODS
    //////////////////////////////////////////////////
    
    $scope.connect = function() {
        userService.connect($scope.name, $scope.password)
            .then(function(data) {
            },
            function(error) {
                //TODO
            });        
    };
  }]);