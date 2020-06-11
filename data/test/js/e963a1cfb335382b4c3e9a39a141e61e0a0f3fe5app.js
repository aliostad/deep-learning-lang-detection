(function() {
	"use strict";

	angular.module("app", ["services"])
	.config(appConfig)
	// .config(decorSrv)
	.decorator("userService", userServiceLog)
	.controller("simpleController", simpleController);


	function appConfig(userGreetingServiceProvider, officialGreeting) {
		userGreetingServiceProvider.setGreeting(officialGreeting);
		// console.log(userGreetingServiceProvider);
	}

	// function decorSrv($provide) {
	// 	$provide.decorator("userService", userServiceLog);
	// }
	//simpleController.$inject = ["userService"];
	function simpleController(userService, personService, userGreetingService, userName) {
		 console.log(userService);
		 userService.setCurrentUser("Alex");
		 console.log(userService.getCurrentUser());

		//console.log(personService);
		// console.log(userGreetingService);
		userGreetingService.greet(userName);

	}

})();