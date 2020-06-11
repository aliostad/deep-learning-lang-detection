(function () {
	'use strict';
	angular.module('abt').config(function ($routeProvider) {
        $routeProvider
            .when('/', {
                controller: 'HomeController',
                controllerAs: 'vm',
                templateUrl: 'app/views/home/index.html'
            })
			.when('/students', {
                controller: 'StudentController',
                controllerAs: 'vm',
                templateUrl: 'app/views/student/index.html'
            })
			.when('/students/details/:id', {
                controller: 'StudentDetailsController',
                controllerAs: 'vm',
                templateUrl: 'app/views/student/details.html'
            })
			.when('/students/create', {
                controller: 'StudentCreateController',
                controllerAs: 'vm',
                templateUrl: 'app/views/student/create.html'
            })
			.when('/students/edit/:id', {
                controller: 'StudentEditController',
                controllerAs: 'vm',
                templateUrl: 'app/views/student/edit.html'
            })
			.when('/students/delete/:id', {
                controller: 'StudentDeleteController',
                controllerAs: 'vm',
                templateUrl: 'app/views/student/delete.html'
            });
    });
})();