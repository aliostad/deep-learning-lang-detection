/**
 * First controller
 * Full documentation for lifecycle: https://angular.github.io/router/lifecycle
 * @constructor
 */

var FirstController = function() {
	console.log('FirstController loaded');
};

FirstController.prototype.canActivate = function() {
	console.log('FirstController canActivate');
	return true;
};

FirstController.prototype.activate = function() {
	console.log('FirstController activate');
	return true;
};

FirstController.prototype.canDeactivate = function() {
	console.log('FirstController canDeactivate');
	return true;
};

FirstController.prototype.deactivate = function() {
	console.log('FirstController deactivate');
	return true;
};

app.controller('FirstController',[FirstController]);