(function(){
	'use strict';
	
	angular.module('common')
		.service('AccountService', AccountService);

	AccountService.$inject = ['$window'];
	function AccountService($window){
		var service = this;
		service.account = null;
		
		service.setAccount = function(account_obj){
			service.account = account_obj;
			$window.localStorage.setItem('default', JSON.stringify(service.account));
			//console.log(service.account);
		};		

		service.getAccount = function(){
			service.account = JSON.parse($window.localStorage.getItem('default'));
			//console.log(service.account);
			return service.account
		};
	}
})();