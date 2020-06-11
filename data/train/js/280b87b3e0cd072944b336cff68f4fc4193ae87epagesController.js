(function () {
	angular
		.module('app')
		.controller('mainController', mainController);

	angular
		.module('app')
		.controller('workController', workController);

	angular
		.module('app')
		.controller('resumeController', resumeController);

	// angular
	// 	.module('app')
	// 	.controller('contactController', contactController);

		function mainController($scope) {
			$scope.pageClass = 'page-main';
		};

		function workController($scope) {
			$scope.pageClass = 'page-work';
		};

		function resumeController($scope) {
			$scope.pageClass = 'page-resume';
		};

		// function contactController($scope) {
		// 	$scope.pageClass = 'page-contact';
		// };
})();