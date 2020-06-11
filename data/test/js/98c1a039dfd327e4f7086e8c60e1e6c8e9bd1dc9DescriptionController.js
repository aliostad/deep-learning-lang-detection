hrApp.controller('DescriptionController',['$rootScope','$scope', function($rootScope,$scope){
    $scope.descriptionShow = true;
    $scope.title = 'Two Way Binding Demo';
    $scope.childtemplate = 'templates/childscope.html';
    $scope.toggleDescriptionShow = function toggleDescriptionShow(){
        if($scope.descriptionShow==true){
            $scope.descriptionShow = false;
        }else{
            $scope.descriptionShow = true;
        }
        $scope.descriptionShow = $scope.descriptionShow;
    };
}]);