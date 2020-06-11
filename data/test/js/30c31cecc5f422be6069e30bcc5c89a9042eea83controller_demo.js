(function() {
	'use strict';

	var root = this;

	root.define([
		'controllers/controller_demo'
		],
		function( ControllerDemo ) {

			describe('ControllerDemo Controller', function () {

				it('should be an instance of ControllerDemo Controller', function () {
					var controller_demo = new ControllerDemo();
					expect( controller_demo ).to.be.an.instanceof( ControllerDemo );
				});

				it('should have more test written', function(){
					expect( false ).to.be.ok;
				});
			});

		});

}).call( this );