/* global angular */

(function () {
	'use strict';

	/* Define controllers ------------------------------------------------------- */
	angular
		.module('Application')
		.controller('ListCategoryController', ListCategoryController)
        .controller('NewCategoryController', NewCategoryController);
	/* ------------------------------------------------------- Define controllers */
    
    /* List Category Controller ------------------------------------------------- */
	ListCategoryController.$inject = ['$scope'];

	function ListCategoryController($scope) {

	};
	/* ------------------------------------------------- List Category Controller */

	/* New Category Controller -------------------------------------------------- */
	NewCategoryController.$inject = ['$scope'];

	function NewCategoryController($scope) {

	};
	/* -------------------------------------------------- New Category Controller */
}());