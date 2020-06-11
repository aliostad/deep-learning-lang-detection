angular.module('tracker.directives', [])
  .directive('datetimePicker', function () {
    return {
      restrict: 'EA',
      templateUrl: 'directives/datetime.tpl.html',
      scope: {model: "=ngModel"},
      controller: function ($scope) {
        $scope.showDate = false;
        $scope.showTime = false;
        $scope.showDatePopup = function () {
          $scope.showDate = !$scope.showDate;
        };
        $scope.showTimePopup = function () {
          $scope.showTime = !$scope.showTime;
        };
        $scope.closeDatePopup = function() {
          $scope.showDate = false;
        };
      }
    };
  });
