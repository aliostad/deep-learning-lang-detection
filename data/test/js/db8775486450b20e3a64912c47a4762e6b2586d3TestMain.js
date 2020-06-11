/**
 * @author John Pennock
 */

describe("Test Main Music Controller", function() {'use strict';
	var musicController = null;	
	
	beforeEach(function() {
		module('mainModule');			
	});
	
	beforeEach(inject(function($rootScope, $controller, $injector) {
		musicController = $rootScope.$new();		
		$controller('musicController', { $scope: musicController});		
	}));

	it("Check Name", function() {
		var actual = musicController.name;		
		expect(actual).toEqual('musicController');
	});	
		
});

describe("Test Main Book Controller", function() {'use strict';
	var bookController = null;	
	
	beforeEach(function() {
		module('mainModule');			
	});
	
	beforeEach(inject(function($rootScope, $controller, $injector) {
		bookController = $rootScope.$new();		
		$controller('bookController', { $scope: bookController});		
	}));

	it("Check Name", function() {
		var actual = bookController.name;		
		expect(actual).toEqual('bookController');
	});	
		
});


