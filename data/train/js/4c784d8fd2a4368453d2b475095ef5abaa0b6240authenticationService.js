/**
 * this service deals with login credentials
 */
(function (){
	angular.module('weaveAnalyst.configure.auth', []);
	
	//experimenting with another kind of angular provider factory vs service (works!!)
	angular.module('weaveAnalyst.configure.auth').factory('authenticationService', authenticationService);

	authenticationService.$inject = ['$rootScope', 'runQueryService', 'adminServiceURL'];

	function authenticationService (rootScope, runQueryService, adminServiceURL){
		var authenticationService = {};
		authenticationService.user;
		authenticationService.password;
		authenticationService.authenticated = false;
		
		//make call to server to authenticate
		 authenticationService.authenticate = function(user, password){

			 runQueryService.queryRequest(adminServiceURL, 'authenticate', [user, password], function(result){
	    		authenticationService.authenticated = result;
	          //if accepted
	            if(authenticationService.authenticated){
	            	
	            	authenticationService.user = user;
	            	authenticationService.password = password;
	            }
	            rootScope.$apply();
	        }.bind(authenticationService));
	   };
	   
	    authenticationService.logout = function(){
	    	console.log("loggin out");
	    	//resetting variables
	    	authenticationService.authenticated = false;
	    	authenticationService.user = "";
	    	authenticationService.password = "";
	    };
	   
	   
	   return authenticationService;
	};
})();//end of IIFE
