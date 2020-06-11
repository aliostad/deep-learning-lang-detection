'use strict'
app.controller('ShowViewCtrl', function ($scope, $routeParams, $location, $filter, Show, Auth, Band) {
	var show = Show.get($routeParams.showId);
	$scope.bands = Show.getBands($routeParams.showId);
	$scope.deleteShow = false;
	$scope.notesEdit = false;
	show.$bindTo($scope, 'show');

	$scope.delete = function () {
		Show.delete($routeParams.showId);
		$location.path('/');
	};

	$scope.removePending = function () {
		Show.removePending($routeParams.showId);
	};

	$scope.status = function() {
		var today = new Date();
		var date = new Date($routeParams.showId * 1000);

		if (show.pending && date > today) {
			return 'PENDING';
		} else if (date > today) {
			return 'UPCOMING';
		} else if (date.toDateString() === today.toDateString()) {
			return 'TODAY';
		} else {
			return 'COMPLETE';
		}
	};

	$scope.setPending = function () {
		Show.setPending($routeParams.showId);
	};

	$scope.editNotes = function () {
		$scope.notesEdit = true;
	};

	$scope.saveNotes = function () {
		$scope.notesEdit = false;
	};

	$scope.deleteBand = function (band) {
		Show.deleteBand(band, $routeParams.showId);
	};

	$scope.user = Auth.user;
	$scope.signedIn = Auth.signedIn;
});