var should = require('should');

describe('win32service', function(){
	// var win32 = require('../build/Release/win32service.node');
	
	var util  = require('util');


	it('require load', function(){
		var service = new win32.Win32Service();
		console.log(service.status);
	})

	// status.dwServiceType             = SERVICE_WIN32_OWN_PROCESS;
	// status.dwCurrentState            = SERVICE_STOPPED;
	// status.dwControlsAccepted        = SERVICE_ACCEPT_STOP;
	// status.dwWin32ExitCode           = 0;
	// status.dwServiceSpecificExitCode = 0;
	// status.dwCheckPoint              = 0;
	// status.dwWaitHint                = 0;
	it('createService', function(){
		var MyService = win32.createService({
			servcieName: 'MyService',
			status: {
				ServiceType      : win32.SERVICE_WIN32_OWN_PROCESS,
				CurrentState     : win32.SERVICE_STOPPED,
				ControlsAccepted : win32.SERVICE_ACCEPT_STOP
			},
			initialize: function(){

			},
			running: function(){

			},

		})

		service = new MyService();
		service.start();
	});
});