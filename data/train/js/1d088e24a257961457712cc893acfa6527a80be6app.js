var serviceApp = angular.module('serviceApp', [
    'ngRoute',
    'ngCookies',
    'serviceControllers',
    'serviceFilters',
    'serviceServices',
    'filters'
]);

serviceApp.config(['$routeProvider',
    function($routeProvider) {
        $routeProvider.
            when('/', {
                templateUrl: '/static/js/app/views/service_list.html',
                controller: 'ServiceListCtrl'
            }).
            when('/detail/:serviceId', {
                templateUrl: '/static/js/app/views/service_detail.html',
                controller: 'ServiceDetailCtrl'
            }).
            otherwise({
                redirectTo: '/'
            });
    }]);
