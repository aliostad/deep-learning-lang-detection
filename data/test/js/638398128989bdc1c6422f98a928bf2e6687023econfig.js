"use strict";

(function(){
    angular
        .module("MyBook")
        .config(Configure);

    function Configure($routeProvider) {
        $routeProvider
            .when("/home",{
                templateUrl: "views/home/home.view.html",
                controller: "HomeController",
                controllerAs: "model"
            })
            .when("/login", {
                templateUrl: "views/login/login.view.html",
                controller: "LoginController",
                controllerAs: "model"
            })
            .when("/register", {
                templateUrl: "views/register/register.view.html",
                controller: "RegisterController",
                controllerAs: "model"
            })
            .when("/profile", {
                templateUrl: "views/profile/profile.view.html",
                controller: "ProfileController",
                controllerAs: "model"
            })
            .when("/search/:keyword", {
                templateUrl: "views/search/search.view.html",
                controller: "SearchController",
                controllerAs: "model"
            })
            .when("/book/:bookId", {
                templateUrl: "views/book/book.view.html",
                controller: "BookController",
                controllerAs: "model"
            })
            .when("/bookEdit/:bookId", {
                templateUrl: "views/bookEdit/bookEdit.view.html",
                controller: "BookEditController",
                controllerAs: "model"
            })
            .when("/cart", {
                templateUrl: "views/cart/cart.view.html",
                controller: "CartController",
                controllerAs: "model"
            })
            .when("/checkout", {
                templateUrl: "views/checkout/checkout.view.html",
                controller: "CheckoutController",
                controllerAs: "model"
            })
            .when("/orders", {
                templateUrl: "views/orders/orders.view.html",
                controller: "OrdersController",
                controllerAs: "model"
            })
            .when("/order/:orderId", {
                templateUrl: "views/order/order.view.html",
                controller: "OrderController",
                controllerAs: "model"
            })
            .when("/allOrders", {
                templateUrl: "views/allOrders/allOrders.view.html",
                controller: "AllOrdersController",
                controllerAs: "model"
            })
            .when("/addBook", {
                templateUrl: "views/addBook/addBook.view.html",
                controller: "AddBookController",
                controllerAs: "model"
            })
            .when("/statistics", {
                templateUrl: "views/statistics/statistics.view.html",
                controller: "StatisticsController",
                controllerAs: "model"
            })
            .otherwise({
                redirectTo: "/home"
            });
        }
})();