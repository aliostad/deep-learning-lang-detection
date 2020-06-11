/*Controllers*/
function MainCtrl($scope, NameService, AboutService, ExperimentService,
		HomeService) {
	$scope.name = NameService.getName();
	$scope.about = AboutService.getAbout();
	$scope.experiment = ExperimentService.getExperiment();
	$scope.home = HomeService.getHome();
}

function aboutDetails($scope, AboutService) {
	$scope.about = AboutService.getAbout();
}

function experimentDetails($scope, ExperimentService) {
	$scope.experiment = ExperimentService.getExperiment();
}

function homeDetails($scope, HomeService) {
	$scope.home = HomeService.getHome();
}
// MainCtrl.$inject = ['$scope', 'NameService'];
