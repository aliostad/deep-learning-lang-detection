var app = angular.module('pickUpSoccer');


app.controller('mainCtrl', function($scope, dataService){

	$scope.locations = dataService.getData();

	$scope.addLocation = function(){
		
		dataService.addData($scope.location);
	};

	$scope.removeLocation = function(){
		dataService.removeData($scope.location);
	};

	$scope.searchLocation = '';
	$scope.showAdd = false;
	$scope.toggleAdd = function() {
		$scope.showAdd = !$scope.showAdd;
		$scope.showRemove = false;
		$scope.showSearch = false;
	};

	$scope.showSearch = false;
	$scope.toggleSearch = function() {
		$scope.showSearch = !$scope.showSearch;
		$scope.showRemove = false;
		$scope.showAdd = false;

	};

	$scope.showRemove = false;
	$scope.toggleRemove = function(){
		$scope.showRemove = !$scope.showRemove;
		$scope.showSearch = false;
		$scope.showAdd = false;

	};
		



});