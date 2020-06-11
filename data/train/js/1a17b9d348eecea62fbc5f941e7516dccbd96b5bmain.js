'use strict';

angular.module('myresumepageApp')
  .controller('MainCtrl', function ($scope) {
  	var currentHead;
  	var currentBody;
  	$scope.showCover = true;
    $scope.changeText = function (type) {
    	$scope.showCover = false;
    	$scope.showWeb = false;
    	$scope.showPeople = false;
    	$scope.showReferences = false;
    	$scope.showEducation = false;
    	if (type === "cover"){
    		$scope.showCover = true;
    	}
    	if (type === "web"){
    		$scope.showWeb = true;
    	}
    	if (type === "people"){
    		$scope.showPeople = true;
    	}
    	if (type === "references"){
    		$scope.showReferences = true;
    	}
    	if (type === "education"){
    		$scope.showEducation = true;
    	}

    }

  });
