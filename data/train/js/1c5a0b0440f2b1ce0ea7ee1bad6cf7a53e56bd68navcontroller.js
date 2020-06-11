module.controller('NavController',['$scope','$location','SocketFactory',function($scope,$location,SocketFactory){
    
    $scope.nav = {};
    $scope.nav.logout = function(){
        SocketFactory.logout();
    }
    
    $scope.nav.filterMessasges = function(){
        $location.path('/filter');
    }
    
    $scope.nav.newMessage = function(){
        $location.path('/new');
    }
    $scope.nav.recent = function(){
        $location.path('/user');
    }
    
    $scope.nav.delete = function(){
        $location.path('/delete');
    }
    
    $scope.nav.update = function(){
        $location.path('/update');
    }
    
}]);