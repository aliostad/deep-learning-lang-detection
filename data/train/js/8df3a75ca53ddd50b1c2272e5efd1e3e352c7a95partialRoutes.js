app.config(['$routeProvider',function ($routeProvider) {
  $routeProvider
    .when('/',{
        controller: 'DashboardController',
        controllerAs: 'dashCtrl',
        templateUrl: '/partials/dashboard.html'
    })
    .when('/dashboard',{
        controller: 'DashboardController',
        controllerAs: 'dashCtrl',
        templateUrl: '/partials/dashboard.html'
    })
    .when('/appointment',{
        controller: 'AppointmentController',
        controllerAs: 'apptCtrl',
        templateUrl: '/partials/appointment.html'
    })
    .when('/users', {
        controller: 'UsersController',
        controllerAs: 'usersCtrl',
        templateUrl: '/partials/users.partial.html'
    })
    .when('/appointment/user', {
        controller: 'DashboardController',
        controllerAs: 'apptCtrl',
        templateUrl: '/partials/dashboard.html'
    })
    .otherwise({
        redirectTo: '/',
    });
}]);