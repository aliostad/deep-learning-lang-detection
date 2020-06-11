var Controller = require( "./controller" );

describe( "Controller", function() {
	it( "_parseRequest parse JSON", function() {
		var controller = new Controller();

		expect( controller._parseRequest( '{ "command" : "notifications", "data" : "" }' ) ).toEqual({
			command : 'notifications',
			data    : ''
		});
	});

	it( "_parseRequest wrong JSON return Error", function() {
		var controller = new Controller();

		expect( function() {
			controller._parseRequest( '{ "command" : }' );
		} ).toThrow();
	});	

	it( "_parseRequest fields 'command' and 'data' are required", function() {
		var controller = new Controller();

		expect( function() {
			controller._parseRequest( '{ "command" : "notifications" }' );
		} ).toThrow();

		expect( function() {
			controller._parseRequest( '{ "data" : "" }' );
		} ).toThrow();
	});

});