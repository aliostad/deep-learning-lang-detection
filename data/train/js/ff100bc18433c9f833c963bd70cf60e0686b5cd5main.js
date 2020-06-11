define(
	[
		'angular',
		'controllers/AcornController',
		'controllers/AcornsController',
		'controllers/FileController',
		'controllers/LoginController',
		'controllers/AddFileController',
		'controllers/AddAcornController'
	],
	function(angular, AcornController, AcornsController, FileController, LoginController, AddFileController, AddAcornController){
		

		return angular.module('sqrl.controllers', [])
			.controller('AcornController', AcornController)
			.controller('AcornsController', AcornsController)
			.controller('FileController', FileController)
			.controller('LoginController', LoginController)
			.controller('AddFileController', AddFileController)
			.controller('AddAcornController', AddAcornController);
	});