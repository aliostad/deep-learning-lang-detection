'use strict';

function notifyService($rootScope, usSpinnerService) {

    var service = this;
    
	service.startSpin = function(){
		service.working = true; 
        usSpinnerService.spin('spinner-1');
    }
    
    service.stopSpin = function(){
    	service.working = false;
        usSpinnerService.stop('spinner-1');
    }

    service.successMessage = function(message) {
		service.messageType = "success";
		service.message = message;
	}

    service.failMessage = function(message, error) {
		service.messageType = "danger";
		if (error === undefined) {
			service.message = message;
		}
		else {
			service.message = message + ' (' + error + ')';
		}
	}

  }

angular.module('App')
    .service('notifyService', notifyService);