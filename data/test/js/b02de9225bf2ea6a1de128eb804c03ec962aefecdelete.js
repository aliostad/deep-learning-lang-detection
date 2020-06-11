angular.module('MyApp')
  .controller('AddCtrl', ['$scope', '$alert', 'Show', function($scope, $alert, Show) {
    $scope.addShow = function() {
      Show.save({ showName: $scope.showName },
        function() {
          $scope.showName = '';
          $scope.addForm.$setPristine();
          $alert({
            content: Show + 'has been added.',
            placement: 'top-right',
            type: 'success',
            duration: 3
          });
          console.log($scope.showName);
        },
        function(response) {
          $scope.showName = '';
          $scope.addForm.$setPristine();
          $alert({
            content: response.data.message,
            placement: 'top-right',
            type: 'danger',
            duration: 3
          });
        });
    };
    $scope.shows = Show.query();
  }]);