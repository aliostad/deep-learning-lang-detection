//TEMPLATE OF THE MAIN CONTROLLER FOR MAIN TEMPLATE HTML
//CONTROLLER DEFINTIIONS SHOULD BE MINIMAL SPECIFYING WHICH CONTROLLER USES WHICH SERVICE, ETC.

define(["controllersFactory", 
	'services/tabService',
	'services/lightSliderService',
	'directives/directives'], 

	function(controllersFactory) {

		controllersFactory.controller('FrontCtrl', 
			['$scope', 
			'TabService',
			'LightSliderService',

			function($scope, 
				tabService,
				lightSliderService) {

				$scope.tabService = tabService.init($scope);
				$scope.clicked = tabService.clicked;
				$scope.lightSliderService = lightSliderService;

				$scope.lightSliderService.start();
		}]);
});