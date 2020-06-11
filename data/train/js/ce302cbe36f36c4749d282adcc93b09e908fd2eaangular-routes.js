currencyApp.config(function($routeProvider){
                                $routeProvider
                                    .when('/home',{templateUrl: 'partials/home.html', controller: 'currencyController'})
                                    .when('/currency',{templateUrl: 'partials/currencyList.html', controller: 'currencyController'})
                                    .when('/news',{templateUrl: 'partials/news.html', controller: 'currencyController'})
                                    .when('/links',{templateUrl: 'partials/links.html', controller: 'currencyController'})
                                    .when('/contacts',{templateUrl: 'partials/email.html', controller: 'currencyController'})
                                    .when('/single/:id',{templateUrl: 'partials/singleCurency.html', controller: 'currencyController'})
                                    .otherwise({redirectTo : '/home', templateUrl: 'partials/home.html', controller:'currencyController'});
                                })
