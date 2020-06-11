angular.module('poc')
	.directive('studentMessage', function() {
		return{
			restrict: 'A',
			templateUrl: '/scripts/directives/message/message.html',
			scope: {
				message: '=message'
			},
			link: function($scope) {
				$scope.$watch('message', function(newValue, oldValue) {
					if ($scope.message.message.length >= 80) {
						$scope.message.message = $scope.message.message.substring(0,76) + "...";
					};
					$scope.message.sendDateTime = jQuery.timeago(new Date($scope.message.sendDateTime));
				});
			}
		}
	});