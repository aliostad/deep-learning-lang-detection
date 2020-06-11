/* global describe, it */
define([
	'jquery',
	'underscore',
	'backbone',

	'backboneController',
	'controller/intro'
], function ($, _, Backbone, Controller, IntroController) {
	'use strict';

	var test = {};
	// before(function(done){
	// 	setTimeout(function(){
	// 		a = 2;
	// 		done();
	// 	}, 1000)
	// });

	describe('controller', function () {
		describe('exists', function () {
			it('just Controller', function() {
				should.exist(Controller);
			});
			it('extented controller exists', function() {
				should.exist(Controller.extend);
			});
			it('generate new controller exists', function() {
				test.controller = new (Controller.extend());
				should.exist(test.controller);
			});
			it('generate new controller exists', function() {
				test.controller = new (Controller.extend());
				should.exist(test.controller);
			});
		});
		describe('extend and new controller', function () {
			it('intro controller', function() {
				test.introController = new IntroController();
				should.exist(test.introController);
			});
			it('run intro controller', function() {
				$('body').append('<section class="intro"></section>');
				test.introController = new IntroController();
				test.introController.run();
				should.exist(1);
			});
		});
	});
});