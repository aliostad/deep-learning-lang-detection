angular.module('localjam', [])
    .controller('mainCtrl', function($scope, $http) {
      $http.get('lessons').
			  success(function(data, status, headers, config) {
			    $scope.lessons = data;
			  }).
			  error(function(data, status, headers, config) {
			    console.log('somethign went wrong.')
			  });

    	function showLesson(lesson) {
    		$scope.activeLesson = lesson;
    		$scope.isShowLesson = true;
    		$scope.isShowLessons = false;
            $scope.isShowContact = false;
            $scope.isShowAbout = false;
    	}

    	function showLessons() {
    		$scope.activeLesson = null;
    		$scope.isShowLesson = false;
    		$scope.isShowLessons = true;
            $scope.isShowContact = false;
            $scope.isShowAbout = false;
    	}

        function showAbout() {
            $scope.isShowLesson = false;
            $scope.isShowLessons = false;
            $scope.isShowContact = false;
            $scope.isShowAbout = true;
        }

        function showContact() {
            $scope.isShowLesson = false;
            $scope.isShowLessons = false;
            $scope.isShowAbout = false;
            $scope.isShowContact = true;
        }

    	function init() {
    		$scope.isShowLessons = true;
    	}

    	$scope.showLesson = showLesson;
    	$scope.showLessons = showLessons;
        $scope.showAbout = showAbout;
        $scope.showContact = showContact;

    	init();
    });










