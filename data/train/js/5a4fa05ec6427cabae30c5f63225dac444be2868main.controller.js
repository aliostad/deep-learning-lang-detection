/**
 * @ngdoc controller
 * @name brewApp.main.controller:MainController
 * @description
 * Controls mainly nothing currently
 */

(function () {
	'use strict';

	// register the controller as MainController
	angular
		.module('brewApp.main')
		.controller('MainController', MainController);

	/**
	 * @ngdoc function
	 * @name brewApp.main.provider:MainController
	 * @description
	 * Provider of the {@link brewApp.main.controller:MainController MainController}
	 *
	 * @param {Service} $scope The scope service to use
	 * @param {Service} $http The http service to use
	 */

	// MainController.$inject = [];

	function MainController() {
		var vm = this;
	}

})();
