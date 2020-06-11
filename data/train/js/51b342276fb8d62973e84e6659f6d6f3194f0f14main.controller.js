/**
 * @ngdoc controller
 * @name cloudfastApp.main.controller:MainController
 * @description
 * Controls mainly nothing currently
 */

(function () {
	'use strict';

	// register the controller as MainController
	angular
		.module('cloudfastApp.main')
		.controller('MainController', MainController);

	/**
	 * @ngdoc function
	 * @name cloudfastApp.main.provider:MainController
	 * @description
	 * Provider of the {@link cloudfastApp.main.controller:MainController MainController}
	 *
	 * @param {Service} $scope The scope service to use
	 * @param {Service} $http The http service to use
	 */

	// MainController.$inject = [];

	function MainController() {
		var vm = this;
	}

})();
