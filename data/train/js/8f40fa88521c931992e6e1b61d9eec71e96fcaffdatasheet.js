'use strict';

openData.directive("datasheet", function() {
    return {
        restrict: "A",
        templateUrl: "templates/directives/datasheet.html",
        scope: {
            columns: "=columns",
            data: "=data",
            title: "=title"
        },
        controller: function($scope) {
            $scope.showRange = 10;
            $scope.showRanges = [10, 20, 50, 100];
            $scope.minShow = 0;
            $scope.maxShow= $scope.minShow + $scope.showRange;
            $scope.reverse = false;
            $scope.sortOrder = "";
            $scope.totalPag = $scope.data.length/$scope.showRange;
            $scope.crtPag = 1;


            $scope.$watch('showRange', function() {

                $scope.maxShow= $scope.minShow + (+$scope.showRange);

            }, true);

            $scope.showRow = function(index){

                if(index< $scope.maxShow && index >= $scope.minShow) return true;
                return false;
            }

            $scope.navigateLeft = function(){
                if($scope.minShow > 0){
                    $scope.minShow -= +$scope.showRange;
                    $scope.maxShow -= +$scope.showRange;
                    $scope.crtPag --;
                }
            }

            $scope.navigateRight = function(){
                if($scope.maxShow < $scope.data.length){
                    $scope.minShow += +$scope.showRange;
                    $scope.maxShow += +$scope.showRange;
                    $scope.crtPag ++;

                }
            }
        }
    }
})