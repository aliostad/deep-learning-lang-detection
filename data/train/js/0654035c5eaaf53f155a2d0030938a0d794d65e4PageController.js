'use strict';

eventsApp.controller('PageController', 
	function ($scope) {

		$scope.ShowSubject = false;
		$scope.ShowDiscount = false;
		$scope.ShowUser = true;
		$scope.ShowCharge = false;
		$scope.ShowSemester = false;
		$scope.ShowBackUp = false;
		
		$scope.DiscountDetails = function() {

			$scope.ShowSubject = false;
			$scope.ShowDiscount = true;
			$scope.ShowUser = false;
			$scope.ShowCharge = false;
			$scope.ShowSemester = false;
			$scope.ShowBackUp = false;
		};
		
		$scope.SubjectDetails = function() {

			$scope.ShowSubject = true;
			$scope.ShowDiscount = false;
			$scope.ShowUser = false;
			$scope.ShowCharge = false;
			$scope.ShowSemester = false;
			$scope.ShowBackUp = false;
		};
		
		$scope.UserDetails = function() {

			$scope.ShowSubject = false;
			$scope.ShowDiscount = false;
			$scope.ShowUser = true;
			$scope.ShowCharge = false;
			$scope.ShowSemester = false;
			$scope.ShowBackUp = false;
		};
		
		$scope.ChargeDetails = function() {

			$scope.ShowSubject = false;
			$scope.ShowDiscount = false;
			$scope.ShowUser = false;
			$scope.ShowCharge = true;
			$scope.ShowSemester = false;
			$scope.ShowBackUp = false;
		};
		
		$scope.SemesterDetails = function() {

			$scope.ShowSubject = false;
			$scope.ShowDiscount = false;
			$scope.ShowUser = false;
			$scope.ShowCharge = false;
			$scope.ShowSemester = true;
			$scope.ShowBackUp = false;
		};
		
		$scope.BackUpDetails = function() {

			$scope.ShowSubject = false;
			$scope.ShowDiscount = false;
			$scope.ShowUser = false;
			$scope.ShowCharge = false;
			$scope.ShowSemester = false;
			$scope.ShowBackUp = true;
		};
	}
);