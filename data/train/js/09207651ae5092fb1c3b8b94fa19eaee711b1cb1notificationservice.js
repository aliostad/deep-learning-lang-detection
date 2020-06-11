var NotificationService = function() {
};

NotificationService.prototype.startservice = function(successCallback, errorCallback, args) {
    cordova.exec(
    	successCallback,
    	errorCallback,
    	'NotificationServicePlugin',
    	'startService',
        args);
};

NotificationService.prototype.stopservice = function(successCallback, errorCallback) {
    cordova.exec(
    	successCallback,
    	errorCallback,
    	'NotificationServicePlugin',
        'stopService',
        []);
};

cordova.addConstructor(function() {
	cordova.addPlugin('notificationService', new NotificationService());
});