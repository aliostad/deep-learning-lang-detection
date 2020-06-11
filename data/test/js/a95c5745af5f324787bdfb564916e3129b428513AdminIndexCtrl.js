angular.module('appControllers').controller('AdminIndexController', ['$scope', 'PostService', 'WorkService', 'SkillService', function($scope, PostService, WorkService, SkillService) {

	PostService.query(function(data) {
		$scope.posts = data;
	});

	WorkService.query(function(data) {
		$scope.work = data;
	});

	SkillService.query({ skill: 'categories' }, function(data) {
		$scope.categories = data.sort();
	});

	SkillService.query(function(data) {
		$scope.skills = data;
	});

	// Prism.highlightAll();

}]);