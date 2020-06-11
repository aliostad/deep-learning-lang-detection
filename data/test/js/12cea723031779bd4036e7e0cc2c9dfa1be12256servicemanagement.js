phonegapdesktop.internal.parseConfigFile("pluginjs/servicemanagement.json");

window.plugins.ServiceManagementService = {
	connectService: function(successCallback, errorCallback){
		if (phonegapdesktop.internal.randomException("ServiceManagementService")) {
			errorCallback('A random error was generated');
		}
		else {
			successCallback(phonegapdesktop.internal.getDebugValue('ServiceManagementService', 'connectService'));
		}
		
	},
	disconnectService: function(successCallback, errorCallback){
		if (phonegapdesktop.internal.randomException("ServiceManagementService")) {
			errorCallback('A random error was generated');
		}
		else {
			successCallback(phonegapdesktop.internal.getDebugValue('ServiceManagementService', 'disconnectService'));
		}
		
	},
	
	getServices: function(cisId, successCallback, errorCallback){
		if (phonegapdesktop.internal.randomException("ServiceManagementService")) {
			errorCallback('A random error was generated');
		}
		else {
			successCallback(phonegapdesktop.internal.getDebugValue('ServiceManagementService', 'getServices'));
		}
	},
	
	getMyServices: function(successCallback, errorCallback){
		if (phonegapdesktop.internal.randomException("ServiceManagementService")) {
			errorCallback('A random error was generated');
		}
		else {
			successCallback(phonegapdesktop.internal.getDebugValue('ServiceManagementService', 'getServices'));
		}
	},
	
	shareMyService: function(jid, serviceObj, successCallback, errorCallback) {
		if (phonegapdesktop.internal.randomException("ServiceManagementService")) {
			errorCallback('A random error was generated');
		}
		else {
			successCallback("SUCCESS");
		}
	},
	
	unshareMyService: function(jid, serviceObj, successCallback, errorCallback) {
		if (phonegapdesktop.internal.randomException("ServiceManagementService")) {
			errorCallback('A random error was generated');
		}
		else {
			successCallback("SUCCESS");
		}
	},
	
	startService: function(serviceId, successCallback, errorCallback){
		if (phonegapdesktop.internal.randomException("ServiceManagementService")) {
			errorCallback('A random error was generated');
		}
		else {
			successCallback("SUCCESS");
		}
	},
	
	stopService: function(serviceId, successCallback, errorCallback){
		if (phonegapdesktop.internal.randomException("ServiceManagementService")) {
			errorCallback('A random error was generated');
		}
		else {
			successCallback("SUCCESS");
		}
	}
	
}

var ServiceManagementServiceHelper = {
	/**
	 * @methodOf ServiceManagementServiceHelper#
	 * @description Connect to Service Management native service
	 * @param {Object} function to be executed if connection successful
	 * @returns null
	 */

	connectToServiceManagement: function(actionFunction) {
		console.log("Connect to ServiceManagementService");
			
		function success(data) {
			actionFunction();
		}
		
		function failure(data) {
			alert("ServiceManagementService - failure: " + data);
		}
	    window.plugins.ServiceManagementService.connectService(success, failure);
	}
}
