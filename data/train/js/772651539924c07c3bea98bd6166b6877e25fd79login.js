'use strict';

angular
    .module('loginApp', ['loginApp.loginModule']);

angular
    .module('loginApp.loginModule', [] )
    .controller('LoginController', LoginController);



function LoginController() {
    var vm = this;

    vm.isShowLogin = true;
    vm.isShowRegistration = false;
    vm.isShowForgotPassword = false;

    vm.showLogin = showLogin;
    vm.showRegistration = showRegistration;
    vm.showForgotPassword = showForgotPassword;

    function showLogin() {
        vm.isShowLogin = true;
        vm.isShowRegistration = false;
        vm.isShowForgotPassword = false;
    }

    function showRegistration() {
        vm.isShowLogin = false;
        vm.isShowRegistration = true;
        vm.isShowForgotPassword = false;
    }

    function showForgotPassword() {
        vm.isShowLogin = false;
        vm.isShowRegistration = false;
        vm.isShowForgotPassword = true;
    }
}