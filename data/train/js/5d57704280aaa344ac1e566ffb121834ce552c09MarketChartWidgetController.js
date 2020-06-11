'use strict';

/**
 * Market ChartWidget Controller
 */
angular.module('stockWatcher.Controllers')
	.controller('MarketChartWidgetController', ['$scope', function ($scope) {
		$scope.showTitle = true;
		$scope.showZoom = true;
		$scope.showDatePicker = true;
		$scope.showNavigator = true;


		$scope.toggleTitle = function() {
			$scope.showTitle = !$scope.showTitle;
		};

		$scope.toggleZoom = function() {
			$scope.showZoom = !$scope.showZoom;
		};

		$scope.toggleDatePicker = function() {
			$scope.showDatePicker = !$scope.showDatePicker;
		};

		$scope.toggleNavigator = function() {
			$scope.showNavigator = !$scope.showNavigator;
		};
	}]);
