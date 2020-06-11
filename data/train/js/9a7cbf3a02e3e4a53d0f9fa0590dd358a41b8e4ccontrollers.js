(function () {

	//Main Controller
	function mainController($scope){
	    $scope.pageClass = 'page-home';
	}

	//About Controller
	function aboutController($scope){
	    $scope.pageClass = 'page-about';    
	}

	//Contact Controller
	function contactController($scope){
	    $scope.pageClass = 'page-contact';    
	}

	angular.module('transitionApp').controller('mainController', mainController);
	angular.module('transitionApp').controller('aboutController', aboutController);
	angular.module('transitionApp').controller('contactController', contactController);

})();