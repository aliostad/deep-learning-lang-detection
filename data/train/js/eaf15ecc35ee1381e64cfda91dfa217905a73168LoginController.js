(function() {
    var app = angular.module('controllers');

    app.directive('loginForm', ['$rootScope', 'Users', function($rootScope, Users) {
        return {
            restrict: 'E',
            templateUrl: 'templates/login-form.html',
            controllerAs: 'login',
            controller: function() {

            var controller = this;
            controller.logged = false;
            controller.username = '';
            controller.password = '';
            controller.loading = false;
            controller.show = false;
            var users = new Users();

            controller.loading = true;
            users.getSession(function(data, status, headers, config) {
                controller.loading = false;
                controller.logged = data.display_name;
                $rootScope.$broadcast('loggedIn');
            }, function() {
                controller.loading = false;
            });

            controller.login = function() {
                controller.loading = true;
                users.login(controller.username, controller.password, function(data, status, headers, config) {
                    controller.logged = data.display_name;
                    controller.loading = false;
                    controller.toggle();
                    $rootScope.$broadcast('loggedIn');
                }, function () {
                    controller.loading = false;
                });
            }

            controller.logout = function() {
                controller.loading = true;
                users.logout(function() {
                    controller.loading = false;
                    controller.logged = false;
                    controller.username = '';
                    controller.password = '';
                    controller.toggle();
                    $rootScope.$broadcast('loggedOut');
                });
            }

            controller.toggle = function () {
                controller.show = !controller.show;
            }

            }
        };
    }]);

})()