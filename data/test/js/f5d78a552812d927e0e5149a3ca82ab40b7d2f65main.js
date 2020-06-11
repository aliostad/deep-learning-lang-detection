app.controller('mainCtl', ['$scope', 'notifyService','cryptsyService', 'tradeStatsService','orderbookStatsService','detectionService'
,function($scope, notifyService, cryptsyService, tradeStatsService, orderbookStatsService, detectionService) {
	$scope.grantPermission = function() {
		notifyService.allow();
	}
	$scope.notifyAllowed = notifyService.isAllowed();

	cryptsyService.bind(169, function(data) {
		tradeStatsService.push(data);
		$scope.model = tradeStatsService.getState();
		$scope.$apply();
		detectionService.process();
	});
	cryptsyService.bindOrderbook(169, function(data) {
		orderbookStatsService.push(data);
		$scope.orderState = orderbookStatsService.getState();
		detectionService.process();
	});
	$scope.tab = 'last1';
}]);