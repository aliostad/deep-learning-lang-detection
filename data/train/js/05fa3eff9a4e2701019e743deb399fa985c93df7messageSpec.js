'use strict';

describe('Test AuthenticationService', function() {
	
	var authenticationService, sessionService,flashService,
		$httpBackend, rootScope, stateProvider, locationProvider;
	var credentials = {
			username: 'mary@demo.org',
			password: 'passwd'
	};
	
	beforeEach(function(){
		module('fdServices');
		
		inject(function(AuthenticationService, SessionService, 
				FlashService,$injector) {
			authenticationService = AuthenticationService;
			sessionService = SessionService;
			
			rootScope = $injector.get('$rootScope');
			flashService = FlashService;
		}, function(_$httpBackend_){
			$httpBackend = _$httpBackend_;
		});
	});
	
	it('logged in should be false if cookie tid is null', function() {

	});
	
});