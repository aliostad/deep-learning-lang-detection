var angular = require('angular');

var app = angular.module('application', []);

// Controllers
var ApplicationController = require('./controllers/application-controller');
var SignInController = require('./controllers/sign-in-controller');
var CustomerController = require('./controllers/customer-controller');

app.controller('ApplicationController', ['$scope', ApplicationController]);
app.controller('SignInController', ['$scope', SignInController]);
app.controller('CustomerController', ['$scope', CustomerController]);

var PasswordDirective = require('./directives/password-directive')
app.directive('password', PasswordDirective);
