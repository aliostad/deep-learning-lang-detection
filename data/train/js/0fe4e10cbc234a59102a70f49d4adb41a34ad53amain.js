(function() {
    'use strict';

    angular
        .module('wattpad', ['ui.router'])
        .config(function($stateProvider, $urlRouterProvider, $locationProvider){
            
            // $urlRouterProvider.when("/callback:code", {
            //      templateUrl: "../partials.html",
            //      controller: "loginController",
            //      controllerAs: "vm"
            // });
            
            $stateProvider
                .state('home', {
                    url: '/',
                    templateUrl: '../partials/login.html',
                    controller: 'mainController',
                    controllerAs: 'vm'    
                })
                .state('discover', {
                    url: '/discover',
                    templateUrl: '../partials/discover.html',
                    controller: 'mainController',
                    controllerAs: 'vm'    
                })
                .state('callback', {
                    url: '/callback:code',
                    templateUrl: '../partials/discover.html',
                    controller: 'loginController',
                    controllerAs: 'vm'    
                });


                // .state('create', {
                //     url: '/create',
                //     templateUrl: '../partials/create.html',
                //     controller: 'createBlogController',
                //     controllerAs: 'vm'
                // })
                // .state('singleBlog', {
                //     url: '/blog',
                //     templateUrl: '../partials/singleblog.html',
                //     controller: 'singleBlogController',
                //     controllerAs: 'vm'
                // })
        });
        
})();

