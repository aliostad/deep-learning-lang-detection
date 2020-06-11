goog.provide('net.skweez.forum.controllers');

goog.require('net.skweez.forum.app');
goog.require('net.skweez.forum.controller.DiscussionOverviewController');
goog.require('net.skweez.forum.controller.NewDiscussionController');
goog.require('net.skweez.forum.controller.DiscussionController');
goog.require('net.skweez.forum.controller.LoginController');
goog.require('net.skweez.forum.controller.AlertController');

var controllersModule = angular.module('net.skweez.forum.controllers', [
		'ngResource', 'ngCookies' ]);

controllersModule.controller('DiscussionsOverviewController',
		DiscussionOverviewController());
controllersModule.controller('NewDiscussionController',
		NewDiscussionController());
controllersModule.controller('DiscussionController', DiscussionController());
controllersModule.controller('LoginController', LoginController());
controllersModule.controller('AlertController', AlertController());
