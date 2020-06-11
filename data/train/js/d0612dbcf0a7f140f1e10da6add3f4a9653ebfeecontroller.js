angular.module("kanmApp.back")
	.controller("ShowDetailsCtrl", function($scope, $state, shows, showInfo, fileUpload) {
		
		$scope.show = showInfo;

		if ($scope.show.ShowPicture) $scope.show.ShowPicture = $scope.show.ShowPicture + '?decache=' + Math.random(); // uncache show picture so it updates when user changes it

		$scope.updateDescription = function() {
			return shows.updateDescription(showInfo.pkey, $scope.updatedDescription)
				.then(function() {
					return $state.go(".", {}, {reload: true});
				});
		};

		var uploadPic = function() {
			fileUpload.uploadFile($scope.showPic, "/index.php/shows/picture/" + showInfo.pkey)
				.then(function() {
					return $state.go(".", {}, {reload: true});
				});
		};
		$scope.$watch("showPic", function() {
			if ($scope.showPic) uploadPic();
		});

	});
