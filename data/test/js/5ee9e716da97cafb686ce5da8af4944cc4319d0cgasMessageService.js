define([
	'services/module'
], function(services) {
	services.factory('gasMessageService', ['$rootScope', function($rootScope){
		var service = {};
		var gasMessage = {
			id: -1,
			PPM: 0,
			gatewayId: "",
			message: "",
			datetime: "",
			isReaded: false
		};

		service.handle = function(message){
			gasMessage.id = message.data.id;
			gasMessage.PPM = message.data.PPM;
			gasMessage.gatewayId = message.data.gatewayId;
			gasMessage.datetime = message.data.datetime;
			gasMessage.message = message.data.message;
			
			$rootScope.$broadcast("gasMsgEvent");
		}

		service.getGasMessage = function(){
			return gasMessage;
		}


		return service;
	}])
});