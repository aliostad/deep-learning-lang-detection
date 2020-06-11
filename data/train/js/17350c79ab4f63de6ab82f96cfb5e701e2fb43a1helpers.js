/* ѣ */
(function() {
	
	'use strict';
	
	var messageBarDirective = function(messageService) {
		return {
			restrict: 'E',
			templateUrl: 'views/helpers/message.html',
			link: function(scope, elem, attrs) {
				
				scope.message = {
					type: '',
					text: ""
				};
				
				scope.$watch(function() {
					return messageService.message.text;
				}, function(newValue) {
					scope.message.type = messageService.message.type;
					scope.message.text = messageService.message.text;
				});
				
				scope.clear = function() {
					messageService.clear();
				};
				
			}
		};
	};
	
	
	angular.module('racepoint')
	.directive('messageBar', messageBarDirective);
	
})();
