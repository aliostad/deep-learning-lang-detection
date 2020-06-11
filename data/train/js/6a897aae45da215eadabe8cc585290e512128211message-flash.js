angular.module('message.flash', [])
.factory('flashMessageService', ['$rootScope',function($rootScope) {
  var message = '';
  return {
    getMessage: function() {
      return message;
    },
    setMessage: function(newMessage) {
      message = newMessage;
      $rootScope.$broadcast('NEW_MESSAGE');
    }
  };
}])

.directive('messageFlash', [function() {
  return {
    controller: function($scope, flashMessageService, $timeout) {
      $scope.$on('NEW_MESSAGE', function() {
        $scope.message = flashMessageService.getMessage();
        $scope.isVisible = true;
        return $timeout(function() {
          $scope.isVisible = false;
          return $scope.message = '';
        }, 2500);
      })
    },
    template: '<p ng-if="isVisible" class="alert alert-info">{{message}}</p>'
    }
  }
]);