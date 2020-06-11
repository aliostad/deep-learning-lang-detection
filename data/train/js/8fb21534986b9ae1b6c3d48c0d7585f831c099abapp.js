var app = angular.module('MyApp', ['ngRoute']);

app.config(function ($routeProvider) {
    $routeProvider.when('/',
    {
        templateUrl: "/app/partials/NewCustomer.html",
        controller: "NewCustomerController"
    })
    .when('/List',
    {
        templateUrl: "/app/partials/ListCustomers.html",
        controller: "ListCustomersController"
    });
});

app.controller('NewCustomerController', NewCustomerController)
    .controller('ListCustomersController', ListCustomersController)
    .controller('DeleteCustomerController', DeleteCustomerController);