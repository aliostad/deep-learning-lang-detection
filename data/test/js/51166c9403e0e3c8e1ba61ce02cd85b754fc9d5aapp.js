(function() {
    'use strict';

    function Config($routeProvider) {
        $routeProvider
            .when('/', {
                templateUrl: '/app/views/home.html',
                controller: 'HomeController',
                controllerAs: 'vm'
            })
            .when('/about/:id', {
                templateUrl: '/app/views/about.html',
                controller: 'AboutController',
                controllerAs: 'vm'
            })
            .when('/contact', {
                templateUrl: '/app/views/contact.html',
                controller: 'ContactController',
                controllerAs: 'vm'
            });
    }

    function HomeController($location) {
        var vm = this;
        vm.move = function (id) {
            $location.path('about/' + id);
        }
    }

    function AboutController($routeParams) {
        var vm = this;
        vm.message = "You passed in " + $routeParams.id;
    }
    function ContactController() {
        
    }

    angular.module('MyApp', ['ngRoute'])
        .config(Config)
        .controller('HomeController', HomeController)
        .controller('AboutController', AboutController)
        .controller('ContactController', ContactController);

})();