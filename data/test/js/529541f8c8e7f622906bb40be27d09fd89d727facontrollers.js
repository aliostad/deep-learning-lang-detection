/**
 * app.controllers module
 */
(function(angular) {
	'use strict';
	angular.module('app.controllers', [
		// Dependencies
		'app.controller.navigation',
		'app.controller.main',
		'app.controller.login',
		'app.controller.contact',
		'app.controller.rankings',
		'app.controller.prospects',
		'app.controller.admin',
		'app.controller.newGame',
        'app.controller.newBakerGame',
		'app.controller.bowler',
		'app.controller.team',
		'app.controller.account',
		'app.controller.blog',
		'app.controller.post'
	]);
}(angular));
